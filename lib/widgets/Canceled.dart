import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/Login.dart';
import 'package:flutter_application_1/pages/dashboard.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../Services/Barcode_scan.dart';
import '../pages/CreateParcel.dart';
import '../pages/Parcels.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'Drrawer.dart';
import 'Parcellist.dart';

class ColisCanceled extends StatefulWidget {
  ColisCanceled({Key? key}) : super(key: key);

  @override
  _ColisCanceledState createState() => _ColisCanceledState();
}

class _ColisCanceledState extends State<ColisCanceled> {
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
        Uri.parse('${Urls.baseUrl}api/parcel/getcanceledparcels'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        // Clear the existing parcels before adding new data
        parcels.clear();

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: Text('Colis De Retour '),
        actions: [
          // Add your filter button here
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              // Add your filter button's action here
              // For example, you can open a filter dialog or navigate to a filter screen.
            },
          ),
          // IconButton(
          //   onPressed: () {
          //     showScanModal(context);
          //   },
          //   icon: Icon(
          //     Icons.search,
          //     size: 35,
          //   ),
          // ),
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

                        print(' list parcels : ');
                        print(parcel);
                        print(' end parcels : ');
                        // int timestamp = int.tryParse(
                        //         parcel['parcel_delivery_time'].toString()) ??
                        //     0;
                        // DateTime date = DateTime.fromMillisecondsSinceEpoch(
                        //     timestamp * 1000);
                        // String formattedDate =
                        //     DateFormat('dd/MM/yyyy').format(date);

                        Color? colorstatus;

                        parcel['parcel_status'] = 'Retour';

                        parcel['parcel_status_second'] = 'Annuler';
                        colorstatus = Colors.red;

                        print(parcel['reported_date']);
                        // var reportedate =
                        //     parcel['reported_date'] == null
                        //         ? 0
                        //         : parcel['reported_date'];

                        return Parcellist(
                          color_status: colorstatus,
                          parcel_statuts_code: parcel_statuts_code,
                          parcel_seconde_status:
                              parcel['parcel_status_second'] == null
                                  ? parcel['parcel_status']
                                  : parcel['parcel_status_second'],
                          parcel_type_date: parcel['reported_date'] == null
                              ? 0
                              : parcel['reported_date'],
                          parcel_status: parcel['parcel_status_second'],
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
                      },
                    ))
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
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.dashboard_sharp),
              onPressed: () async {
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
