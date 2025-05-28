import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import '../widgets/Api.dart';
import '../widgets/Drrawer.dart';
import '../widgets/Parcellist.dart';
import '../widgets/resultfilter.dart';
import '../widgets/searchbox.dart';
import 'CreateParcel.dart';
import 'home.dart';

class Parcels extends StatefulWidget {
  const Parcels({Key? key}) : super(key: key);

  @override
  State<Parcels> createState() => _ParcelsState();
}

class _ParcelsState extends State<Parcels> {
  late List<Map<String, dynamic>> parcels = [];
  late ScrollController _scrollController;
  // late bool _isLoading;
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
        Uri.parse('${Urls.baseUrl}api/parcel/getparcels'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        // Clear the existing parcels before adding new data
        parcels.clear();

        parcels.addAll(List<Map<String, dynamic>>.from(data));

        print(parcels);
      } else if (response.statusCode == 401) {
        // Token expired, navigate to login screen
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.remove('user_id');
        prefs.remove('username');
        prefs.remove('useremail');
        prefs.remove('userstore');
        prefs.remove('usertoken');
        Get.off(() => Login(), transition: Transition.cupertinoDialog);
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
        backgroundColor: primary,
        title: Text('Colis'),
        actions: [
          // Add your filter button here
          // IconButton(
          //   icon: Icon(Icons.tune),
          //   onPressed: () {
          //     // Add your filter button's action here
          //     // For example, you can open a filter dialog or navigate to a filter screen.
          //   },
          // ),
          IconButton(
            onPressed: () {
              showScanModal(context);
            },
            icon: Icon(
              Icons.search,
              size: 35,
            ),
          ),
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
                              print(_selectedItem);
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
          // Add your notification bell icon here
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Add your notification button's action here
              // For example, you can open a notifications screen.
            },
          ),
        ],
      ),
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
                print(parcels.length);
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: parcels.length,
                        itemBuilder: (context, index) {
                          final parcel = parcels[index];
                          int timestamp = int.tryParse(
                                  parcel['parcel_delivery_time'].toString()) ??
                              0;
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                              timestamp * 1000);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(date);
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

                          print(parcel['cities_nom']);
                          return Parcellist(
                            color_status: colorstatus,
                            parcel_statuts_code: parcel_statuts_code,
                            parcel_seconde_status:
                                parcel['parcel_status_second'] == null
                                    ? parcel['parcel_status']
                                    : parcel['parcel_status_second'],
                            parcel_status: parcel['parcel_status'],
                            parcel_type_date: parcel['reported_date'] == null
                                ? 0
                                : parcel['reported_date'],
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
                          );

                          // return Container(
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       color: Color.fromARGB(255, 244, 244, 244),
                          //       width: 2,
                          //     ),
                          //     color: Color.fromARGB(255, 255, 255, 255),
                          //     borderRadius: BorderRadius.circular(10),
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Color.fromARGB(255, 210, 210, 210)
                          //             .withOpacity(0.5),
                          //         spreadRadius: 2,
                          //         blurRadius: 5,
                          //         offset: Offset(0, 3),
                          //       ),
                          //     ],
                          //   ),
                          //   padding: EdgeInsets.all(20),
                          //   margin:
                          //       EdgeInsets.only(top: 20, right: 20, left: 20),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SingleChildScrollView(
                          //         scrollDirection: Axis.horizontal,
                          //         child: Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               parcel['parcel_code'].toString(),
                          //               style: TextStyle(
                          //                 color: Colors.grey,
                          //                 fontSize: 13,
                          //                 fontWeight: FontWeight.w700,
                          //               ),
                          //             ),
                          //             SizedBox(
                          //                 width:
                          //                     50), // Add some space between text and status
                          //             Container(
                          //               padding: EdgeInsets.symmetric(
                          //                   vertical: 3, horizontal: 5),
                          //               decoration: BoxDecoration(
                          //                 color: colorstatus,
                          //                 borderRadius:
                          //                     BorderRadius.circular(10),
                          //               ),
                          //               child: Text(
                          //                 parcel['parcel_status'].toString() +
                          //                     ' ' +
                          //                     (parcel['parcel_status']
                          //                                     .toString() ==
                          //                                 'Réporte' ||
                          //                             parcel['parcel_status']
                          //                                     .toString() ==
                          //                                 'Reporte' ||
                          //                             parcel['parcel_status']
                          //                                     .toString() ==
                          //                                 'Livre'
                          //                         ? formattedDate.toString()
                          //                         : ''),
                          //                 style: TextStyle(
                          //                   color: Colors.white,
                          //                   fontSize: 15,
                          //                 ),
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       Divider(
                          //         thickness: 1.5,
                          //       ),
                          //       Row(
                          //         children: [
                          //           Icon(
                          //             Icons.business,
                          //             size: 15,
                          //             color: seconde,
                          //           ),
                          //           Text(
                          //             '  ${parcel['parcel_receiver']}',
                          //             style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           Text(
                          //             '( ${parcel['parcel_price']} Dh )',
                          //             style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Divider(
                          //         thickness: 0,
                          //         color: Color(0xffE3F2FD),
                          //       ),
                          //       Row(
                          //         children: [
                          //           Icon(
                          //             Icons.phone,
                          //             size: 15,
                          //             color: seconde,
                          //           ),
                          //           Text(
                          //             '  ${parcel['parcel_phone']}',
                          //             style: TextStyle(
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Divider(
                          //         thickness: 0,
                          //         color: Color(0xffE3F2FD),
                          //       ),
                          //       SingleChildScrollView(
                          //         scrollDirection: Axis.horizontal,
                          //         child: Row(
                          //           children: [
                          //             Icon(
                          //               Icons.location_on,
                          //               size: 15,
                          //               color: seconde,
                          //             ),
                          //             parcel['parcel_address'] != null ||
                          //                     parcel['parcel_address'] != ""
                          //                 ? Text(
                          //                     '${parcel['parcel_address']}',
                          //                     maxLines: 1,
                          //                   )
                          //                 : Text(
                          //                     '${parcel['parcel_city']}',
                          //                     maxLines: 1,
                          //                   ),
                          //           ],
                          //         ),
                          //       ),
                          //       Divider(
                          //         thickness: 1.5,
                          //       ),
                          //       // Add more parcel info widgets here as needed
                          //     ],
                          //   ),
                          // );
                        },
                      ),
                    ),
                    // Loading indicator at the end of the list
                    // if (hasMoreData)
                    //   Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: CircularProgressIndicator(),
                    //   ),
                  ],
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Use Navigator to navigate to the CreateParcel page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateParcel()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Activate the first tab
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.dashboard_sharp),
              onPressed: () async {
                // Activate the second tab

                setState(() {
                  isLoading = true;
                });
                await fetchData();
                setState(() {
                  isLoading = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
