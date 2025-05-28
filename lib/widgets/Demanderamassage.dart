import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/Validation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';

class DemandeRamassage extends StatefulWidget {
  DemandeRamassage({Key? key}) : super(key: key);

  @override
  _DemandeRamassageState createState() => _DemandeRamassageState();
}

class _DemandeRamassageState extends State<DemandeRamassage> {
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

      final response = await http.get(
        Uri.parse('${Urls.baseUrl}api/pickuprequest/getpickuprequests'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        print(data);
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

  void whatsappmgs({@required numberphone, @required message}) async {
    String url = "whatsapp://send?phone=+212$numberphone&text=$message";
    print(url);
    await canLaunch(url) ? launch(url) : print('No cant');
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
        title: Text('Demandes de Ramassage'),
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
                                  parcel['pickup_request_time'].toString()) ??
                              0;
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              timestamp * 1000);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(date);

                          if (parcel['pickup_request_statut'] ==
                              "NEW_DEMANDE") {
                            parcel['pickup_request_statut'] =
                                'Nouvelle Demande';
                            colorstatus = Colors.green;
                          } else if (parcel['pickup_request_statut'] ==
                              "ASSIGN_TO_PICKUP") {
                            parcel['pickup_request_statut'] =
                                'Affecter au Ramasseur';
                            colorstatus = Colors.orange;
                          } else if (parcel['pickup_request_statut'] ==
                              "SUCCESS_PICKUP") {
                            parcel['pickup_request_statut'] =
                                'Ramassage Reussi';
                            colorstatus = Colors.lightBlue;
                          } else if (parcel['pickup_request_statut'] ==
                              "FAILED_PICKUP") {
                            parcel['pickup_request_statut'] = 'Echec Ramassage';
                            colorstatus = Colors.red;
                          } else if (parcel['pickup_request_statut'] ==
                              "ON_CALL") {
                            parcel['pickup_request_statut'] =
                                'Appel du Ramassage';
                            colorstatus = Colors.blueGrey;
                          }

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
                                        parcel['pickup_request_note']
                                            .toString(),
                                        style: TextStyle(
                                          color: primary,
                                          fontSize: 15,
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
                                          parcel['pickup_request_statut']
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
                                Divider(
                                  thickness: 1.5,
                                ),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.userAlt,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    Text('  ${parcel['pickup_request_note']}'),
                                  ],
                                ),
                                Divider(
                                  thickness: 0,
                                  color: Color(0xffE3F2FD),
                                ),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.typo3,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      '  Type ( ' +
                                          (parcel['pickup_request_type'] ==
                                                  'SIMPLE_PARCEL'
                                              ? 'Ramassage Colis'
                                              : (parcel['pickup_request_type'] ==
                                                      'STOCK'
                                                  ? 'Ramassage Stock'
                                                  : '')) +
                                          ' )',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0,
                                  color: Color(0xffE3F2FD),
                                ),
                                // Row(
                                //   children: [
                                //     FaIcon(
                                //       FontAwesomeIcons.phoneAlt,
                                //       size: 15,
                                //       color: Colors.amber,
                                //     ),
                                //     Text(
                                //       '  ${parcel['pickup_request_phone']}',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Divider(
                                //   thickness: 0,
                                //   color: Color(0xffE3F2FD),
                                // ),
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.phoneAlt,
                                      size: 15,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      ' Ramasseur : ${parcel['users_phone']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0,
                                  color: Color(0xffE3F2FD),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.locationArrow,
                                        size: 15,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${parcel['pickup_request_address']}',
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 0,
                                  color: Color(0xffE3F2FD),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.calendar,
                                        size: 15,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '${formattedDate}',
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1.5,
                                ),
                                Row(children: [
                                  IconButton(
                                    onPressed: () async {
                                      await FlutterPhoneDirectCaller.callNumber(
                                          parcel['users_phone']);
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.phoneAlt,
                                      color: Colors.blue,
                                      size: 26,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      whatsappmgs(
                                          numberphone: parcel['users_phone'],
                                          message:
                                              "Bonjour, Je suis votre livreur Quick Livraison Je vous confirme pour livrer le colis MAD a payer a la livraison. Trés bon journée");
                                    },
                                    icon: FaIcon(
                                      FontAwesomeIcons.whatsapp,
                                      color: primary,
                                      size: 31,
                                    ),
                                  ),
                                ])
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
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            builder: (context) => NewDemandeModal(context),
          );
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

  final Map<String, dynamic> requestData = {
    'type': selectedType,
    'remark': remarkController.text,
    'phone': phoneController.text,
    'address': addressController.text,
  };
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestData),
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
          .push(MaterialPageRoute(builder: (context) => DemandeRamassage()));
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

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController remarkController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController addressController = TextEditingController();
String selectedType = 'SIMPLE_PARCEL';

Widget NewDemandeModal(BuildContext context) => SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type de demande',
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: 'SIMPLE_PARCEL',
                        child: Text('Ramassage colis simple'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'STOCK',
                        child: Text('Ramassage colis stock'),
                      ),
                    ],
                    onChanged: (value) {
                      selectedType = value!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez sélectionner le type de demande';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: remarkController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Votre remarque *',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer votre remarque';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Téléphone *',
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          validatePhoneNumber(value) == false) {
                        return 'Veuillez entrer un numéro de téléphone valide';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: addressController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Adresse *',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Veuillez entrer une adresse';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              CreateNewDemande(context);
                            }
                          },
                          child: Text('Enregistrer'),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
