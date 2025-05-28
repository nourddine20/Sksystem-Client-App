import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Parcels.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import '../widgets/Api.dart';
import '../widgets/Drrawer.dart';
import '../widgets/resultfilter.dart';
import '../widgets/searchbox.dart';
import '../widgets/statistic_cart.dart';
import 'CreateParcel.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var id = "";
  var name = "";

  Future<String?> getpre() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id') ?? "";
    name = pref.getString('username') ?? "";
    if (id.isNotEmpty) {
      return id + name;
    }
    return null;
  }

  var cnt_allTotalPriceLivre = 0;
  var cnt_allTotalPriceLivreNotPaid = 0;
  var cnt_allTotalPriceParcels = 0;
  var cnt_allTotalRevenueNet = 0;
  var cnt_allparcelscount = 0;
  var cnt_TotalNbrParcelsLivre = 0;
  var cnt_TotalNbrParcelsEnProcess = 0;
  var cnt_TotalNbrParcelsNouveau = 0;
  var cnt_TotalNbrParcelsReturn = 0;
  var cnt_totalwallet = 0;
  var Customer_RIB = '';
  Future<int> getparcellivre() async {
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
        Uri.parse('${Urls.baseUrl}api/general_statistics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body)['data'];

        var allTotalPriceLivre = jsonResponse['allTotalPriceLivre'];
        var allTotalPriceLivreNotPaid =
            jsonResponse['allTotalPriceLivreNotPaid'];
        var allTotalPriceParcels = jsonResponse['allTotalPriceParcels'];
        var allTotalRevenueNet = jsonResponse['allTotalRevenueNet'];
        var allParcelsCount = jsonResponse['allParcelsCount'];
        var TotalNbrParcelsLivre = jsonResponse['TotalNbrParcelsLivre'];
        var TotalNbrParcelsEnProcess = jsonResponse['TotalNbrParcelsEnProcess'];
        var TotalNbrParcelsNouveau = jsonResponse['TotalNbrParcelsNouveau'];
        var TotalNbrParcelsReturn = jsonResponse['TotalNbrParcelsReturn'];
        var Customer_RIB_value = jsonResponse['Customer_RIB_value'];
        var totalwallet = jsonResponse['TotalWallet'];

        setState(() {
          cnt_totalwallet = totalwallet ?? 0;
          cnt_allTotalPriceLivre = allTotalPriceLivre ?? 0;
          cnt_allTotalPriceLivreNotPaid = allTotalPriceLivreNotPaid ?? 0;
          cnt_allTotalPriceParcels = allTotalPriceParcels ?? 0;
          cnt_allTotalRevenueNet = allTotalRevenueNet ?? 0;
          cnt_allparcelscount = allParcelsCount ?? 0;
          Customer_RIB = Customer_RIB_value ?? '';
          cnt_TotalNbrParcelsLivre = TotalNbrParcelsLivre ?? 0;
          cnt_TotalNbrParcelsEnProcess = TotalNbrParcelsEnProcess ?? 0;
          cnt_TotalNbrParcelsNouveau = TotalNbrParcelsNouveau ?? 0;
          cnt_TotalNbrParcelsReturn = TotalNbrParcelsReturn ?? 0;
        });

        return cnt_allTotalPriceLivre;
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

    return 0;
  }

  bool isLoading = true;

  @override
  void initState() {
    getpre().then((value) {});

    getparcellivre().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    super.initState();
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
        title: Text('Accueil'),
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
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await getparcellivre();
              setState(() {
                isLoading = false;
              });
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 35,
            ),
          ),

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
                                  'Attente Ramassage',
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
      body: isLoading
          ? Center(
              // Show loading indicator while isLoading is true
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       // Text(
                  //       //   "BIENVENUE",
                  //       //   style: TextStyle(
                  //       //     fontSize: 30,
                  //       //     fontWeight: FontWeight.bold,
                  //       //   ),
                  //       // ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  ElevatedCardExample(
                      textCart: "Portefeuille",
                      code_text: 'totalwallet',
                      dataDegree: cnt_totalwallet,
                      TotalParcels: cnt_allparcelscount,
                      type_card: 'wallet',
                      customer_rib: Customer_RIB),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                  Column(
                    children: [
                      ElevatedCardExample(
                        textCart: "Total Colis",
                        code_text: 'total_all_price_parcels',
                        dataDegree: cnt_allparcelscount,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'numbers',
                        customer_rib: '',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: " Chiffre D'affaire ",
                        code_text: 'total_all_price_parcels',
                        dataDegree: cnt_allTotalPriceParcels,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'static',
                        customer_rib: '',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: 'Total Livré',
                        code_text: 'total_all_price_livre',
                        dataDegree: cnt_allTotalPriceLivre,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'static',
                        customer_rib: '',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: 'Revenue Net',
                        code_text: 'total_revenue_net',
                        dataDegree: cnt_allTotalRevenueNet,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'static',
                        customer_rib: '',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: "Total Colis Nouveau",
                        code_text: 'total_nbr_parcels_nouveau',
                        dataDegree: cnt_TotalNbrParcelsNouveau,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'numbers',
                        customer_rib: '',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: "Total Colis En Cours",
                        code_text: 'total_nbr_parcels_enprocess',
                        dataDegree: cnt_TotalNbrParcelsEnProcess,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'numbers',
                        customer_rib: '',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: "Total Colis Livre",
                        code_text: 'total_nbr_parcels_livre',
                        dataDegree: cnt_TotalNbrParcelsLivre,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'numbers',
                        customer_rib: '',
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedCardExample(
                        textCart: 'Total Colis Retour',
                        code_text: 'total_nbr_parcels_return',
                        dataDegree: cnt_TotalNbrParcelsReturn,
                        TotalParcels: cnt_allparcelscount,
                        type_card: 'numbers',
                        customer_rib: '',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                ],
              ),
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
              onPressed: () async {
                // Activate the first tab
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Home()),
                // );
                setState(() {
                  isLoading = true;
                });
                await getparcellivre();
                setState(() {
                  isLoading = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.dashboard_sharp),
              onPressed: () {
                // Activate the second tab
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Parcels()),
                );
              },
            ),
          ],
        ),
      ),
      drawer: Drrawer(),
    );
  }
}
