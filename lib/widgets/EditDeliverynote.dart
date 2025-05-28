import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';

class EditDeliverynote extends StatefulWidget {
  final deliverynote_ref;
  final type_action;
  EditDeliverynote(this.type_action, this.deliverynote_ref, {Key? key})
      : super(key: key);

  @override
  _EditDeliverynoteState createState() => _EditDeliverynoteState();
}

class _EditDeliverynoteState extends State<EditDeliverynote> {
  late List<Map<String, dynamic>> parcels = [];
  late ScrollController _scrollController;
  bool isLoading = true;

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

  Future DeleteParcelFromDeliverynote(deliverynote_ref, parcel_id) async {
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
          Uri.parse('${Urls.baseUrl}api/note/DeleteParcelFromDeliverynote'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "deliverynote_ref": widget.deliverynote_ref,
            "parcel_id": parcel_id
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'le colis a été supprimé de ${widget.deliverynote_ref}  avec succès!',
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Handle the success case as needed
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

  Future AddParcelToDeliverynote(deliverynote_ref, parcel_id) async {
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
          Uri.parse('${Urls.baseUrl}api/note/AddParcelToDeliverynote'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "deliverynote_ref": widget.deliverynote_ref,
            "parcel_id": parcel_id
          }));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Le colis a été ajouter en ${widget.deliverynote_ref} avec succès!',
          icon: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Handle the success case as needed
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
      print(widget.type_action);
      var response = await http.post(
          Uri.parse('${Urls.baseUrl}api/note/getParcelsByTypeEdit'),
          headers: {
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "type_action": widget.type_action,
            "deliverynote_ref": widget.deliverynote_ref
          }));

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

  // Function to dismiss the dialog and navigate back
  void navigateBack(BuildContext context) {
    // Dismiss the dialog if it's showing
    Navigator.of(context).pop();

    // Navigate back to the previous page
    Navigator.of(context).pop();
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
        title: Text(
            'Colis de ' + widget.deliverynote_ref.toString().substring(0, 8)),
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
                          int timestamp =
                              int.tryParse(parcel['parcel_time'].toString()) ??
                                  0;
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              timestamp * 1000);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(date);

                          // if (parcel['delivery_note_delivered'] == "1") {
                          //   parcel['delivery_note_delivered'] = 'Recu';
                          //   colorstatus = Colors.green;
                          // } else {
                          //   parcel['delivery_note_delivered'] = 'Nouveau';
                          //   colorstatus = Colors.blueAccent;
                          // }

                          return Container(
                            margin: EdgeInsets.all(15),
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
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text(
                                        parcel['parcel_code'].toString(),
                                        style: TextStyle(
                                          color: primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
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
                                          '${formattedDate}',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1.5,
                                ),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.cube,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      '  ${parcel['parcel_receiver']} ( ${parcel['parcel_price'].toString()} Dh )',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0,
                                  color: Color(0xffE3F2FD),
                                ),
                                // SingleChildScrollView(
                                //   scrollDirection: Axis.horizontal,
                                //   child: Row(
                                //     children: [

                                //   ),
                                // ),
                                // Divider(
                                //   thickness: 1.5,
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    widget.type_action == "add"
                                        ? IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await // Add your add new colis logic here
                                                  AddParcelToDeliverynote(
                                                      widget.deliverynote_ref,
                                                      parcel['parcel_id']);
                                              // For example, navigate to the add new colis screen
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            icon: Icon(Icons.add_circle,
                                                color: Colors.green),
                                          )
                                        : Container(),
                                    widget.type_action == "delete"
                                        ? IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await // Add your edit delivery note logic here
                                                  DeleteParcelFromDeliverynote(
                                                      widget.deliverynote_ref,
                                                      parcel['parcel_id']);
                                              // For example, navigate to the edit delivery note screen
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            icon: Icon(Icons.delete,
                                                color: Colors.redAccent),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          );
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
          //   builder: (context) => NewDemandeModal(context),
          // );
        },
        child: Icon(Icons.add),
        backgroundColor: primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
