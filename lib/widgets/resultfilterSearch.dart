import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../pages/Parcels.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'Drrawer.dart';
import 'Parcellist.dart';
import 'resultfilter.dart';

class resultfiltersearch extends StatefulWidget {
  resultfiltersearch({Key? key}) : super(key: key);

  @override
  _resultfiltersearchState createState() => _resultfiltersearchState();
}

class _resultfiltersearchState extends State<resultfiltersearch> {
  late List<Map<String, dynamic>> parcels = [];
  late ScrollController _scrollController;
  // late bool _isLoading;
  bool isLoading = true;
  String status = '';
  @override
  void initState() {
    setState(() {
      status = Get.arguments;
    });
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
      var response = await http.post(
          Uri.parse('${Urls.baseUrl}api/parcel/filterparcelsbysearch'),
          headers: {
            "Authorization": "Bearer $token",
          },
          body: {
            'filter_by': status
          });

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        // Clear the existing parcels before adding new data
        parcels.clear();

        print(data);
        parcels.addAll(List<Map<String, dynamic>>.from(data));
      } else {
        print('Response: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      String errorMessage = 'An error occurred';

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
      appBar: AppBar(
          title: Text('Search Filtrer'),
          centerTitle: true,
          backgroundColor: primary,
          leading: IconButton(
            onPressed: () {
              // Navigator.of(context).pop();
              Get.to(() => Parcels());
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  Get.off(() => resultfiltersearch(),
                      transition: Transition.fade);
                });
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: 35,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Get.to(() => resultfilter(),
                                    arguments: _selectedItem);
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.thumbsUp,
                                size: 15,
                              ),
                              label: Text('  Appliquer   '),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                              ),
                            ),
                          ],
                          title: Center(
                            child: Text('Filtrer Par Status'),
                          ),
                          content: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Column(
                              children: [
                                AwesomeDropDown(
                                  isPanDown: _isPanDown,
                                  dropDownList: [
                                    'Status',
                                    'Livre',
                                    'Reporte',
                                    'Pas de reponse',
                                    'Injoignable',
                                    'Hors-zone',
                                    'Annule',
                                    'Refuse',
                                    'Numero-Errone',
                                    'Deuxieme Appel',
                                    'Troisieme Appel',
                                    'Distribution',
                                    'Nouveau Colis',
                                    'Attente ramassage',
                                    'Ramasser',
                                    'envoi',
                                    'Recevoir',
                                    'En Progress',
                                    'Retour',
                                    'envoi par amana',
                                    'Retour par amana',
                                    'Prog',
                                    // Add more options as needed
                                  ],
                                  dropDownIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                    size: 23,
                                  ),
                                  selectedItem: _selectedItem,
                                  onDropDownItemClick: (selectedItem) {
                                    _selectedItem = selectedItem;
                                  },
                                  dropStateChanged: (isOpened) {
                                    _isDropDownOpened = isOpened;
                                    if (!isOpened) {
                                      _isBackPressedOrTouchedOutSide = false;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: Icon(
                Icons.filter_alt_outlined,
                size: 35,
              ),
            ),
          ]),
      drawer: Drrawer(),
      body: isLoading
          ? Center(
              // Show loading indicator while isLoading is true
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<void>(
              future: fetchData(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                // final bool hasMoreData =
                //     snapshot.connectionState == ConnectionState.done &&;
                print('sdfsdf');
                print(parcels.length);
                print('goood');
                if (parcels.length > 0) {
                  return Column(children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: parcels.length,
                        itemBuilder: (context, index) {
                          final parcel = parcels[index];
                          var parcel_statuts_code = parcel['parcel_status'];

                          Color? colorstatus;
                          if (parcel['parcel_status'] == 'DELIVERED' ||
                              parcel['parcel_status_second'] == 'DELIVERED') {
                            parcel['parcel_status'] = 'Livre';
                            colorstatus = Colors.green;
                          } else if (parcel['parcel_status'] ==
                              'DISTRIBUTION') {
                            parcel['parcel_status'] = 'Distribution';
                            colorstatus = Colors.blue;
                          } else if (parcel['parcel_status'] == 'NEW_PARCEL') {
                            parcel['parcel_status'] = 'Nouveau Colis';
                            colorstatus = Colors.cyanAccent;
                          } else if (parcel['parcel_status'] ==
                              'WAITING_PICKUP') {
                            parcel['parcel_status'] = 'Attente Ramassage';
                            colorstatus = Colors.amber;
                          } else if (parcel['parcel_status'] == 'PICKED_UP') {
                            parcel['parcel_status'] = 'Ramasser';
                            colorstatus = Colors.deepOrange;
                          } else if (parcel['parcel_status'] == 'SENT') {
                            parcel['parcel_status'] = 'envoi';
                            colorstatus = Colors.indigo;
                          } else if (parcel['parcel_status'] == 'RECEIVED') {
                            parcel['parcel_status'] = 'Recevoir';
                            colorstatus = Colors.teal;
                          } else if (parcel['parcel_status'] == 'IN_PROGRESS') {
                            parcel['parcel_status'] = 'En Progress';
                            colorstatus = Colors.yellow;
                          } else if (parcel['parcel_status'] == 'RETURNED') {
                            parcel['parcel_status'] = 'Retour';
                            colorstatus = Colors.red;
                          } else if (parcel['parcel_status'] ==
                              'SENT_BY_AMANA') {
                            parcel['parcel_status'] = 'envoi par amana';
                            colorstatus = Colors.grey;
                          } else if (parcel['parcel_status'] ==
                              'RETURN_BY_AMANA') {
                            parcel['parcel_status'] = 'Retour par amana';
                            colorstatus = Colors.limeAccent;
                          } else if (parcel['parcel_status'] == 'PROG') {
                            parcel['parcel_status'] = 'Prog';
                            colorstatus = Colors.brown;
                          }

                          switch (parcel['parcel_status_second']) {
                            case 'POSTPONED':
                              parcel['parcel_status_second'] = 'Réporte';
                              colorstatus = Colors.purple;
                              break;
                            case 'NOANSWER':
                              parcel['parcel_status_second'] = 'Pas de reponse';
                              colorstatus = Colors.amber;
                              break;
                            case 'UNREACHABLE':
                              parcel['parcel_status_second'] = 'Injoignable';
                              colorstatus = Colors.orange;
                              break;
                            case 'OUT_OF_AREA':
                              parcel['parcel_status_second'] = 'Hors-zone';
                              colorstatus = Colors.redAccent;
                              break;
                            case 'CANCELED':
                              parcel['parcel_status_second'] = 'Annule';
                              colorstatus = Colors.red;
                              break;
                            case 'REFUSE':
                              parcel['parcel_status_second'] = 'Refuse';
                              colorstatus = Colors.red;
                              break;
                            case 'ERR':
                              parcel['parcel_status_second'] = 'Numero-Errone';
                              colorstatus = Colors.red;
                              break;
                            case 'DEUXIEME':
                              parcel['parcel_status_second'] = 'Deuxieme appel';
                              colorstatus = Colors.green;
                              break;
                            case 'TROIXIEME':
                              parcel['parcel_status_second'] =
                                  'Troisieme appel';
                              colorstatus = Colors.green;
                              break;
                          }

                          return Parcellist(
                              color_status: colorstatus,
                              parcel_statuts_code: parcel_statuts_code,
                              parcel_seconde_status:
                                  parcel['parcel_status_second'] == null
                                      ? parcel['parcel_status']
                                      : parcel['parcel_status_second'],
                              parcel_type_date:
                                  parcel['parcel_delivery_time'] ?? 0,
                              parcel_status:
                                  (parcel['parcel_status_second'] == null ||
                                          parcel['parcel_status_second'] == '')
                                      ? parcel['parcel_status']
                                      : parcel['parcel_status_second'],
                              bare_code: parcel['parcel_code'],
                              parcel_client: parcel['parcel_receiver'],
                              parcel_price: parcel['parcel_price'],
                              parcel_edited: parcel['parcel_edited'],
                              parcel_replace: parcel['parcel_replace'],
                              parcel_phone: parcel['parcel_phone'],
                              parcel_adress: parcel['parcel_address'],
                              parcel_city: parcel['cities_nom'],
                              parcel_livreur: parcel['parcel_livreur'],
                              parcel_note: parcel['parcel_note'],
                              parcel_id: parcel['parcel_id'],
                              parcel_customer: parcel['parcel_customer'],
                              pay_parcels_statut: parcel['pay_parcels_statut']);
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
                          'Pas Trouver',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }
}
