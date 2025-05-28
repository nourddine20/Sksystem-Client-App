// // ignore_for_file: unused_import

// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:path/path.dart' as path;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../Auth/Login.dart';
// import '../theme/constant.dart';
// import '../theme/urls.dart';
// // import 'package:url_launcher/url_launcher.dart';
// import 'Api.dart';
// import 'PdfViewer.dart';
// import 'statistic_cart.dart';

// class List_transactions extends StatefulWidget {
//   List_transactions({Key? key}) : super(key: key);

//   @override
//   _List_transactionsState createState() => _List_transactionsState();
// }

// class _List_transactionsState extends State<List_transactions> {
//   late List<Map<String, dynamic>> notes = [];
//   late ScrollController _scrollController;
//   // late bool _isLoading;
//   bool isLoading = true;
//   var cnt_allTotalPriceLivre = 0;
//   var cnt_allTotalPriceLivreNotPaid = 0;
//   var cnt_allTotalPriceParcels = 0;
//   var cnt_allTotalRevenueNet = 0;
//   var cnt_allparcelscount = 0;
//   var cnt_TotalNbrParcelsLivre = 0;
//   var cnt_TotalNbrParcelsEnProcess = 0;
//   var cnt_TotalNbrParcelsNouveau = 0;
//   var cnt_TotalNbrParcelsReturn = 0;
//   var cnt_totalwallet = 0;
//   var Customer_RIB = '';

//   Future<int> getparcellivre() async {
//     try {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String token = pref.getString('usertoken') ??
//           ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
//       bool isTokenValidvar = await ApiServices.isTokenValid(token);

//       if (!isTokenValidvar) {
//         // Redirect to login page or perform logout actions
//         // You might want to use a navigation library (e.g., Get) for navigation
//         print('Token expired or invalid. Redirecting to login page.');
//         // Example using Get library:
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.clear();
//         Get.offAll(() => Login()); // Replace '/login' with your login route
//       }

//       var response = await http.get(
//         Uri.parse(
//             '${Urls.baseUrl}api/general_statistics'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       print('good morning');

//       if (response.statusCode == 200) {
//         var jsonResponse = jsonDecode(response.body)['data'];

//         var allTotalPriceLivre = jsonResponse['allTotalPriceLivre'];
//         var allTotalPriceLivreNotPaid =
//             jsonResponse['allTotalPriceLivreNotPaid'];
//         var allTotalPriceParcels = jsonResponse['allTotalPriceParcels'];
//         var allTotalRevenueNet = jsonResponse['allTotalRevenueNet'];
//         var allParcelsCount = jsonResponse['allParcelsCount'];
//         var TotalNbrParcelsLivre = jsonResponse['TotalNbrParcelsLivre'];
//         var TotalNbrParcelsEnProcess = jsonResponse['TotalNbrParcelsEnProcess'];
//         var TotalNbrParcelsNouveau = jsonResponse['TotalNbrParcelsNouveau'];
//         var TotalNbrParcelsReturn = jsonResponse['TotalNbrParcelsReturn'];
//         var Customer_RIB_value = jsonResponse['Customer_RIB_value'];
//         var totalwallet = jsonResponse['TotalWallet'];
//         print("this is real");
//         print(Customer_RIB_value);
//         print(totalwallet);
//         setState(() {
//           cnt_totalwallet = totalwallet ?? 0;
//           cnt_allTotalPriceLivre = allTotalPriceLivre ?? 0;
//           cnt_allTotalPriceLivreNotPaid = allTotalPriceLivreNotPaid ?? 0;
//           cnt_allTotalPriceParcels = allTotalPriceParcels ?? 0;
//           cnt_allTotalRevenueNet = allTotalRevenueNet ?? 0;
//           cnt_allparcelscount = allParcelsCount ?? 0;
//           Customer_RIB = Customer_RIB_value ?? '';
//           cnt_TotalNbrParcelsLivre = TotalNbrParcelsLivre ?? 0;
//           cnt_TotalNbrParcelsEnProcess = TotalNbrParcelsEnProcess ?? 0;
//           cnt_TotalNbrParcelsNouveau = TotalNbrParcelsNouveau ?? 0;
//           cnt_TotalNbrParcelsReturn = TotalNbrParcelsReturn ?? 0;
//         });

//         return cnt_allTotalPriceLivre;
//       } else {
//         print('Response: ${response.body}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       String errorMessage = 'An error occurred';

//       if (e.toString().contains("Failed host lookup")) {
//         errorMessage = 'Please check your connection.';
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           icon: Icon(
//             Icons.error,
//             color: Colors.white,
//           ),
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     }

//     return 0;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _scrollController.addListener(_scrollListener);

//     getparcellivre().then((value) {
//       setState(() {
//         isLoading = false;
//       });
//     });

//     _getpdf().then((value) {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       _getpdf().then((value) {
//         setState(() {
//           isLoading = false;
//         });
//       });
//     }
//   }

//   Future<void> _getpdf() async {
//     try {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String token = pref.getString('usertoken') ??
//           ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
//       bool isTokenValidvar = await ApiServices.isTokenValid(token);

//       if (!isTokenValidvar) {
//         // Redirect to login page or perform logout actions
//         // You might want to use a navigation library (e.g., Get) for navigation
//         print('Token expired or invalid. Redirecting to login page.');
//         // Example using Get library:
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.clear();
//         Get.offAll(() => Login()); // Replace '/login' with your login route
//       }

//       var response = await http.get(
//         Uri.parse(
//             '${Urls.baseUrl}api/wallet/getlist_transactions'),
//         headers: {
//           "Accept": "application/json",
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json'
//         },
//       );
//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body)['data'];

//         // Clear the existing parcels before adding new data
//         notes.clear();

//         notes.addAll(List<Map<String, dynamic>>.from(data));
//       } else {
//         print('Response: ${response.body}');
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       print('Error: $e');
//       String errorMessage = 'An error occurred';

//       if (e.toString().contains("Failed host lookup")) {
//         errorMessage = 'Please check your connection.';
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           icon: Icon(
//             Icons.error,
//             color: Colors.white,
//           ),
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Helper functions to get the color and status text
//     Color getColor(String status) {
//       switch (status) {
//         case 'PAYE_FACTURE':
//           return Colors.deepPurpleAccent;
//         case 'ENREGISTRE':
//           return Colors.blueGrey;
//         case 'BROUILLON':
//           return Colors.orangeAccent;
//         case 'NEW':
//           return Colors.greenAccent;
//         case 'APPROVED':
//           return Colors.blueAccent;
//         case 'REFUSED':
//           return Colors.redAccent;
//         case 'PAYED':
//           return Colors.purpleAccent;
//         default:
//           return Colors.black;
//       }
//     }

//     String getStatusText(String status) {
//       switch (status) {
//         case 'PAYE_FACTURE':
//           return 'Payer (Facture)';
//         case 'ENREGISTRE':
//           return 'Enregistrer';
//         case 'BROUILLON':
//           return 'Brouillon';
//         case 'NEW':
//           return 'Nouveau';
//         case 'APPROVED':
//           return 'Approuvé';
//         case 'REFUSED':
//           return 'Refusé';
//         case 'PAYED':
//           return 'Payé';
//         default:
//           return '';
//       }
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//           title: Text('List Transactions'),
//           centerTitle: true,
//           backgroundColor: primary,
//           leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: Icon(Icons.arrow_back),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 setState(() {
//                   isLoading = true;
//                 });
//                 await _getpdf();
//                 await getparcellivre();
//                 setState(() {
//                   isLoading = false;
//                 });
//               },
//               icon: Icon(
//                 Icons.refresh_rounded,
//                 size: 35,
//               ),
//             ),
//           ]),
//       body: isLoading
//           ? Center(
//               // Show loading indicator while isLoading is true
//               child: CircularProgressIndicator(),
//             )
//           : // SizedBox(
//           //   height: MediaQuery.of(context).size.height / 18,
//           // ),
//           FutureBuilder<void>(
//               future: _getpdf(),
//               builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
//                 // final bool hasMoreData =
//                 //     snapshot.connectionState == ConnectionState.done &&;
//                 print('sdfsdf');

//                 print(notes.length);
//                 print('goood');
//                 if (notes.length > 0) {
//                   return Column(children: [
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 18,
//                     ),
//                     ElevatedCardExample(
//                         textCart: "Portefeuille",
//                         code_text: 'totalwallet',
//                         dataDegree: cnt_totalwallet,
//                         TotalParcels: cnt_allparcelscount,
//                         type_card: 'wallet',
//                         customer_rib: Customer_RIB),
//                     SizedBox(
//                       height: MediaQuery.of(context).size.height / 18,
//                     ),
//                     Expanded(
//                         child: ListView.builder(
//                       controller: _scrollController,
//                       itemCount: notes.length,
//                       itemBuilder: (context, index) {
//                         final note = notes[index];
//                         // Inside your ListView.builder or other widget build methods
//                         var date = DateTime.fromMillisecondsSinceEpoch(
//                             int.parse(note['wallet_history_time'].toString()) *
//                                 1000);
//                         var formattedDate =
//                             DateFormat('yyyy-MM-dd').format(date);

//                         return Column(
//                           children: [
//                             ListTile(
//                               title: Text(note['wallet_history_ref']),
//                               subtitle: Row(
//                                 children: [
//                                   Text(
//                                     note['wallet_history_type'].toString() ==
//                                             '1'
//                                         ? '+${note['wallet_history_montant']} dh'
//                                         : (note['wallet_history_type']
//                                                     .toString() ==
//                                                 '2'
//                                             ? '-${note['wallet_history_montant']} dh'
//                                             : ''),
//                                     style: TextStyle(
//                                       color: note['wallet_history_type']
//                                                   .toString() ==
//                                               '1'
//                                           ? Colors.green
//                                           : Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                   // Expanded(
//                                   //   child: Text(
//                                   //     note['wallet_history_type'].toString() ==
//                                   //             '1'
//                                   //         ? 'Entrer'
//                                   //         : (note['wallet_history_type']
//                                   //                     .toString() ==
//                                   //                 '2'
//                                   //             ? 'Sortie '
//                                   //             : ''),
//                                   //   ),
//                                   // ),
//                                   Spacer(),
//                                   Text(formattedDate.toString())
//                                 ],
//                               ),
//                               leading: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   FaIcon(
//                                     note['wallet_history_type'].toString() ==
//                                             '1'
//                                         ? FontAwesomeIcons.arrowUpLong
//                                         : (note['wallet_history_type']
//                                                     .toString() ==
//                                                 '2'
//                                             ? FontAwesomeIcons.arrowDown
//                                             : null),
//                                     color: note['wallet_history_type']
//                                                 .toString() ==
//                                             '1'
//                                         ? Colors.green
//                                         : (note['wallet_history_type']
//                                                     .toString() ==
//                                                 '2'
//                                             ? Colors.red
//                                             : null),
//                                   ),
//                                 ],
//                               ),
//                               trailing: Container(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 4, horizontal: 8),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       getColor(note['wallet_history_statut']),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   getStatusText(note['wallet_history_statut']),
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                               ),
//                               onTap: () async {},
//                             ),
//                             Divider(
//                               thickness: 1,
//                             ),
//                           ],
//                         );
//                       },
//                     ))
//                   ]);
//                 } else {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.sentiment_dissatisfied,
//                           size: 48.0,
//                           color: Colors.red,
//                         ),
//                         SizedBox(height: 8.0),
//                         Text(
//                           'Pas Trouver',
//                           style: TextStyle(fontSize: 16.0),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               }),
//     );
//   }
// }

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
import 'PdfViewer.dart';
import 'statistic_cart.dart';

class List_transactions extends StatefulWidget {
  List_transactions({Key? key}) : super(key: key);

  @override
  _List_transactionsState createState() => _List_transactionsState();
}

class _List_transactionsState extends State<List_transactions> {
  late List<Map<String, dynamic>> notes = [];
  late ScrollController _scrollController;
  bool isLoading = true;
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
        print('Token expired or invalid. Redirecting to login page.');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login());
      }

      var response = await http.get(
        Uri.parse('${Urls.baseUrl}api/general_statistics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('good morning');

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
        print("this is real");
        print(Customer_RIB_value);
        print(totalwallet);
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

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    getparcellivre().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    _getpdf().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getpdf().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _getpdf() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ??
          ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
      bool isTokenValidvar = await ApiServices.isTokenValid(token);

      if (!isTokenValidvar) {
        print('Token expired or invalid. Redirecting to login page.');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login());
      }

      var response = await http.get(
        Uri.parse('${Urls.baseUrl}api/wallet/getlist_transactions'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        notes.clear();
        notes.addAll(List<Map<String, dynamic>>.from(data));
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
  Widget build(BuildContext context) {
    Color getColor(String status) {
      switch (status) {
        case 'PAYE_FACTURE':
          return Colors.deepPurpleAccent;
        case 'ENREGISTRE':
          return Colors.blueGrey;
        case 'BROUILLON':
          return Colors.orangeAccent;
        case 'NEW':
          return Colors.greenAccent;
        case 'APPROVED':
          return Colors.blueAccent;
        case 'REFUSED':
          return Colors.redAccent;
        case 'PAYED':
          return Colors.purpleAccent;
        default:
          return Colors.black;
      }
    }

    String getStatusText(String status) {
      switch (status) {
        case 'PAYE_FACTURE':
          return 'Payer (Facture)';
        case 'ENREGISTRE':
          return 'Enregistrer';
        case 'BROUILLON':
          return 'Brouillon';
        case 'NEW':
          return 'Nouveau';
        case 'APPROVED':
          return 'Approuvé';
        case 'REFUSED':
          return 'Refusé';
        case 'PAYED':
          return 'Payé';
        default:
          return '';
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Portefeuille'),
        centerTitle: true,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await _getpdf();
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
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<void>(
                future: _getpdf(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (notes.length > 0) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                        ),
                        ElevatedCardExample(
                          textCart: "Portefeuille",
                          code_text: 'totalwallet',
                          dataDegree: cnt_totalwallet,
                          TotalParcels: cnt_allparcelscount,
                          type_card: 'wallet',
                          customer_rib: Customer_RIB,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 18,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              var date = DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(note['wallet_history_time']
                                          .toString()) *
                                      1000);
                              var formattedDate =
                                  DateFormat('yyyy-MM-dd').format(date);

                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    title: Text(
                                      note['wallet_history_ref'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            note['wallet_history_type']
                                                        .toString() ==
                                                    '1'
                                                ? '+${note['wallet_history_montant']} dh'
                                                : (note['wallet_history_type']
                                                            .toString() ==
                                                        '2'
                                                    ? '-${note['wallet_history_montant']} dh'
                                                    : ''),
                                            style: TextStyle(
                                              color: note['wallet_history_type']
                                                          .toString() ==
                                                      '1'
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            formattedDate.toString(),
                                            style: TextStyle(fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FaIcon(
                                          note['wallet_history_type']
                                                      .toString() ==
                                                  '1'
                                              ? FontAwesomeIcons.arrowUpLong
                                              : (note['wallet_history_type']
                                                          .toString() ==
                                                      '2'
                                                  ? FontAwesomeIcons.arrowDown
                                                  : null),
                                          color: note['wallet_history_type']
                                                      .toString() ==
                                                  '1'
                                              ? Colors.green
                                              : (note['wallet_history_type']
                                                          .toString() ==
                                                      '2'
                                                  ? Colors.red
                                                  : null),
                                        ),
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: getColor(
                                            note['wallet_history_statut']),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        getStatusText(
                                            note['wallet_history_statut']),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (note['wallet_history_type']
                                              .toString() ==
                                          '1') {
                                        SharedPreferences pref =
                                            await SharedPreferences
                                                .getInstance();
                                        String token = pref
                                                .getString('usertoken') ??
                                            ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
                                        bool isTokenValidvar =
                                            await ApiServices.isTokenValid(
                                                token);

                                        if (!isTokenValidvar) {
                                          // Redirect to login page or perform logout actions
                                          // You might want to use a navigation library (e.g., Get) for navigation
                                          print(
                                              'Token expired or invalid. Redirecting to login page.');
                                          // Example using Get library:
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.clear();
                                          Get.offAll(() =>
                                              Login()); // Replace '/login' with your login route
                                        }
                                        String pdfUrl =
                                            '${Urls.baseUrl}clients/pdf-invoices?inv-ref=${note['wallet_history_motif']}&app_token=${token}';
                                        print(pdfUrl);
                                        final response =
                                            await http.get(Uri.parse(pdfUrl));

                                        final tempDir = await Directory
                                            .systemTemp; // Get the temporary directory
                                        final file = File(path.join(
                                            tempDir.path,
                                            '${note['wallet_history_motif']}.pdf')); // Construct file path using path package

                                        await file
                                            .writeAsBytes(response.bodyBytes);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PdfViewer(
                                              filePath: file.path,
                                              filecode:
                                                  note['wallet_history_motif'],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    );
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
            ),
    );
  }
}
