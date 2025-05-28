import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'DetailsDeliverynote.dart';
import 'EditDeliverynote.dart';
import 'PdfViewer.dart';

class Ramassagenote extends StatefulWidget {
  Ramassagenote({Key? key}) : super(key: key);

  @override
  _RamassagenoteState createState() => _RamassagenoteState();
}

class _RamassagenoteState extends State<Ramassagenote> {
  late List<Map<String, dynamic>> parcels = [];
  late ScrollController _scrollController;
  bool isLoading = true;
  late int parcels_nums = 0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchData().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchData().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future DeleteDeliverynote(deliverynote_ref) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ??
          ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
      bool isTokenValidvar = await ApiServices.isTokenValid(token);

      if (!isTokenValidvar) {
        // Redirect to login page or perform logout actions
        // You might want to use a navigation library (e.g., Get) for navigation
        print('Token expired or invalid. Redirecting to login page.');
        // Example using Get library:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login()); // Replace '/login' with your login route
      }

      var response = await http.post(
          Uri.parse('${Urls.baseUrl}api/note/DeleteDeliverynote'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({"deliverynote_ref": deliverynote_ref}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // setState(() {
        //   isLoading = true;
        // });
        // await
        // setState(() {
        //   isLoading = false;
        // });
        fetchData();

        Get.snackbar(
          'Success',
          'Le Bon de livraison ${deliverynote_ref} a été supprimer  avec succès!',
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Handle the success case as needed
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['message'];

        print('API request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');

        Get.snackbar(
          'Erreur',
          errorMessage,
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Erreur: $e');
      String errorMessage = 'Une erreur s\'est produite';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
        Get.snackbar(
          'Error',
          errorMessage,
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> CreateDeliverynote() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ??
          ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
      bool isTokenValidvar = await ApiServices.isTokenValid(token);

      if (!isTokenValidvar) {
        // Redirect to login page or perform logout actions
        // You might want to use a navigation library (e.g., Get) for navigation
        print('Token expired or invalid. Redirecting to login page.');
        // Example using Get library:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login()); // Replace '/login' with your login route
      }

      var response = await http.post(
        Uri.parse('${Urls.baseUrl}api/note/CreateDeliverynote'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var new_deliverynote_ref =
            jsonDecode(response.body)['new_delivery_note_ref'];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Le Bon de Ramassage a été créé avec succès!\n'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.pop(context);
                    // Navigate to page to add a new parcel to the delivery note
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditDeliverynote(
                              'add', new_deliverynote_ref.toString())),
                    );
                  },
                  child: Text('Générer Tickets'),
                ),
                TextButton(
                  onPressed: () {
                    // Refresh the page
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Ramassagenote()),
                    );
                  },
                  child: Text('Passer'),
                ),
              ],
            );
          },
        );
      } else {
        print('Response: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Erreur: $e');
      String errorMessage = 'Une erreur s\'est produite';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
        Get.snackbar(
          'Error',
          errorMessage,
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> fetchData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ??
          ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
      bool isTokenValidvar = await ApiServices.isTokenValid(token);

      if (!isTokenValidvar) {
        // Redirect to login page or perform logout actions
        // You might want to use a navigation library (e.g., Get) for navigation
        print('Token expired or invalid. Redirecting to login page.');
        // Example using Get library:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login()); // Replace '/login' with your login route
      }

      var response = await http.get(
        Uri.parse('${Urls.baseUrl}api/note/getDeliverynotes'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        parcels.clear();
        parcels.addAll(List<Map<String, dynamic>>.from(data));
      } else {
        print('Réponse: ${response.body}');
        throw Exception('Échec du chargement des données');
      }
    } catch (e) {
      print('Erreur: $e');
      String errorMessage = 'Une erreur s\'est produite';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
        Get.snackbar(
          'Error',
          errorMessage,
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _selectedItem = '';
    bool _isDropDownOpened = false;
    bool _isBackPressedOrTouchedOutSide = false;
    bool _isPanDown = false;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Bon de Ramassage'),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await fetchData();
              setState(() {
                isLoading = false;
              });
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 35,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<void>(
              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                if (parcels.length > 0) {
                  return Column(children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: parcels.length,
                        itemBuilder: (context, index) {
                          final parcel = parcels[index];
                          Color? colorstatus;
                          int timestamp = int.tryParse(
                                  parcel['delivery_note_time'].toString()) ??
                              0;
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              timestamp * 1000);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(date);
                          var statuts_delivered = '';
                          if (int.parse(parcel['delivery_note_delivered']) ==
                              1) {
                            statuts_delivered = 'Recu';
                            colorstatus = Colors.green;
                          } else {
                            statuts_delivered = 'Nouveau';
                            colorstatus = Colors.blueAccent;
                          }

                          parcels_nums = int.parse(parcel['num_parcels']);
                          return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color.fromARGB(255, 244, 244, 244),
                                    width: 2),
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 210, 210, 210)
                                        .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(right: 2),
                              child: Row(children: [
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        String token =
                                            pref.getString('usertoken') ?? "";
                                        bool isTokenValidvar =
                                            await ApiServices.isTokenValid(
                                                token);

                                        if (!isTokenValidvar) {
                                          print(
                                              'Token expired or invalid. Redirecting to login page.');
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.clear();
                                          Get.offAll(() => Login());
                                        }
                                        String pdfUrl =
                                            '${Urls.baseUrl}clients/pdf-delivery-note?dn-ref=${parcel['delivery_note_ref']}&app_token=${token}';

                                        final response =
                                            await http.get(Uri.parse(pdfUrl));

                                        final tempDir =
                                            await Directory.systemTemp;
                                        final file = File(path.join(
                                            tempDir.path,
                                            '${parcel['delivery_note_ref']}.pdf'));

                                        await file
                                            .writeAsBytes(response.bodyBytes);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PdfViewer(
                                              filePath: file.path,
                                              filecode:
                                                  parcel['delivery_note_ref'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.print,
                                        color: Colors.lightGreen,
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        // Add your edit delivery note logic here
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        String token =
                                            pref.getString('usertoken') ?? "";
                                        bool isTokenValidvar =
                                            await ApiServices.isTokenValid(
                                                token);

                                        if (!isTokenValidvar) {
                                          print(
                                              'Token expired or invalid. Redirecting to login page.');
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.clear();
                                          Get.offAll(() => Login());
                                        }
                                        // String pdfUrl =
                                        //     '${Urls.baseUrl}clients/pdf-delivery-note?dn-ref=${parcel['delivery_note_ref']}&app_token=${token}';

                                        String pdfUrl =
                                            '${Urls.baseUrl}clients/pdf-delivery-note-tickets?dn-ref=${parcel['delivery_note_ref']}&app_token=${token}';

                                        final response =
                                            await http.get(Uri.parse(pdfUrl));

                                        final tempDir =
                                            await Directory.systemTemp;
                                        final file = File(path.join(
                                            tempDir.path,
                                            '${parcel['delivery_note_ref']}.pdf'));

                                        await file
                                            .writeAsBytes(response.bodyBytes);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PdfViewer(
                                              filePath: file.path,
                                              filecode:
                                                  parcel['delivery_note_ref'],
                                            ),
                                          ),
                                        );
                                        // For example, navigate to the edit delivery note screen
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.fileInvoice,
                                        color: Color.fromARGB(255, 175, 161, 0),
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        // Add your edit delivery note logic here
                                        // Add your edit delivery note logic here
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        String token =
                                            pref.getString('usertoken') ?? "";
                                        bool isTokenValidvar =
                                            await ApiServices.isTokenValid(
                                                token);

                                        if (!isTokenValidvar) {
                                          print(
                                              'Token expired or invalid. Redirecting to login page.');
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.clear();
                                          Get.offAll(() => Login());
                                        }
                                        // String pdfUrl =
                                        //     '${Urls.baseUrl}clients/pdf-delivery-note?dn-ref=${parcel['delivery_note_ref']}&app_token=${token}';

                                        String pdfUrl =
                                            '${Urls.baseUrl}clients/pdf-delivery-note-tickets-4-4?dn-ref=${parcel['delivery_note_ref']}&app_token=${token}';

                                        final response =
                                            await http.get(Uri.parse(pdfUrl));

                                        final tempDir =
                                            await Directory.systemTemp;
                                        final file = File(path.join(
                                            tempDir.path,
                                            '${parcel['delivery_note_ref']}.pdf'));

                                        await file
                                            .writeAsBytes(response.bodyBytes);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PdfViewer(
                                              filePath: file.path,
                                              filecode:
                                                  parcel['delivery_note_ref'],
                                            ),
                                          ),
                                        );
                                        // For example, navigate to the edit delivery note screen
                                        // For example, navigate to the edit delivery note screen
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.ticket,
                                        color: Color.fromARGB(255, 146, 0, 175),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 150,
                                  child: VerticalDivider(
                                      color:
                                          Color.fromARGB(255, 206, 206, 206)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Text(
                                              parcel['delivery_note_ref']
                                                  .toString(),
                                              style: TextStyle(
                                                color: primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 3, horizontal: 5),
                                              decoration: BoxDecoration(
                                                color: colorstatus,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                parcel['delivery_note_delivered_name']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: Divider(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206)),
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.cube,
                                            size: 10,
                                            color: Colors.amber,
                                          ),
                                          Text(
                                            "  Nombre de Colis    ",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            '${parcel['num_parcels']}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 150,
                                        child: Divider(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206)),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.calendar,
                                              size: 10,
                                              color: Colors.amber,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${formattedDate}',
                                              maxLines: 1,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: Divider(
                                            color: Color.fromARGB(
                                                255, 206, 206, 206)),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              // Add your add new colis logic here
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailsDeliverynote(
                                                            context,
                                                            parcel[
                                                                'delivery_note_ref'])),
                                              );
                                              // For example, navigate to the add new colis screen
                                            },
                                            icon: Icon(
                                              Icons.remove_red_eye_outlined,
                                              color: Colors.lightBlue,
                                              size: 20,
                                            ),
                                          ),
                                          (int.parse(parcel['num_parcels']) >
                                                      0 &&
                                                  int.parse(parcel[
                                                          'delivery_note_delivered']) ==
                                                      0)
                                              ? IconButton(
                                                  onPressed: () {
                                                    // Add your add new colis logic here

                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20.0)),
                                                      ),
                                                      builder: (context) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                          color: Colors
                                                              .white, // Optionally, you can set a background color
                                                        ),
                                                        child:
                                                            FractionallySizedBox(
                                                          heightFactor:
                                                              0.8, // Set to 90% of the screen height
                                                          child: EditDeliverynote(
                                                              'delete',
                                                              parcel[
                                                                  'delivery_note_ref']),
                                                        ),
                                                      ),
                                                    );

                                                    // For example, navigate to the add new colis screen
                                                  },
                                                  icon: Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.pink,
                                                    size: 20,
                                                  ),
                                                )
                                              : Container(),
                                          (int.parse(parcel[
                                                      'delivery_note_delivered']) ==
                                                  0)
                                              ? IconButton(
                                                  onPressed: () {
                                                    // Add your add new colis logic here
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        20.0)),
                                                      ),
                                                      builder: (context) =>
                                                          Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    20.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    20.0),
                                                          ),
                                                          color: Colors
                                                              .white, // Optionally, you can set a background color
                                                        ),
                                                        child:
                                                            FractionallySizedBox(
                                                          heightFactor:
                                                              0.8, // Set to 90% of the screen height
                                                          child: EditDeliverynote(
                                                              'add',
                                                              parcel[
                                                                  'delivery_note_ref']),
                                                        ),
                                                      ),
                                                    );

                                                    // For example, navigate to the add new colis screen
                                                  },
                                                  icon: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.green,
                                                    size: 20,
                                                  ),
                                                )
                                              : Container(),
                                          (int.parse(parcel['num_parcels']) ==
                                                      0 &&
                                                  int.parse(parcel[
                                                          'delivery_note_delivered']) ==
                                                      0)
                                              ? IconButton(
                                                  onPressed: () async {
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                    await // Add your edit delivery note logic here
                                                        DeleteDeliverynote(parcel[
                                                            'delivery_note_ref']);
                                                    // For example, navigate to the edit delivery note screen
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.orange,
                                                    size: 20,
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ]));
                        },
                      ),
                    ),
                  ]);
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 48.0,
                          color: Colors.red,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Non trouvé',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // showModalBottomSheet(
          //   context: context,
          //   isScrollControlled: true,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          //   ),
          //   builder: (context) =>,
          // );
          CreateDeliverynote();
        },
        child: Icon(Icons.add),
        backgroundColor: primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Future<void> CreateNewDemande(context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String token = pref.getString('usertoken') ??
      ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
  bool isTokenValidvar = await ApiServices.isTokenValid(token);

  if (!isTokenValidvar) {
    // Redirect to login page or perform logout actions
    // You might want to use a navigation library (e.g., Get) for navigation
    print('Token expired or invalid. Redirecting to login page.');
    // Example using Get library:
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAll(() => Login()); // Replace '/login' with your login route
  }

  final String apiUrl = '${Urls.baseUrl}api/pickuprequest/create';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: {},
    );

    if (response.statusCode == 200) {
      Get.snackbar(
        'Succès',
        'Demande de ramassage créée avec succès.',
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Ramassagenote()));
    } else {
      final Map<String, dynamic> errorResponse = jsonDecode(response.body);
      final String errorMessage = errorResponse['message'] ??
          'Échec de la création de la demande de ramassage. Veuillez réessayer.';

      print('API request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Get.snackbar(
        'Erreur',
        errorMessage,
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  } catch (e) {
    print('Erreur lors de la requête API : $e');
  }
}
