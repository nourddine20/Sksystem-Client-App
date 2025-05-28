import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Parcels.dart';
import 'package:flutter_application_1/pages/dashboard.dart';
import 'package:flutter_application_1/theme/constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/urls.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var id;
  var name;

  Future<String?> getpre() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    id = pref.getString('user_id').toString();
    name = pref.getString('username').toString();
    if (id != null) {
      setState(() {
        id = pref.getString('user_id').toString();
        name = pref.getString('username').toString();
      });
      return id + name;
    }
  }

  var cnt_delivered = 0;
  var cnt_distrubition = 0;
  var cnt_process = 0;
  var cnt_returned = 0;
  var cnt_allparcels = 0;
  var cnt_alltotalparcels = 0;
  var cnt_alltotalcommissions = 0;
  var cnt_alltotalversements = 0;

  Future<int> getparcellivre() async {
    try {
      var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/count_parcels'),
        body: {'id': id.toString()},
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var parcelCountDelivered = jsonResponse['parcel_count_delivered'];
        var parcelCountDistrubition = jsonResponse['parcel_count_distrubition'];
        var parcelCountProcess = jsonResponse['parcel_count_enprocess'];
        var parcelCountReturned = jsonResponse['parcel_count_returned'];
        var allparcelsCount = jsonResponse['all_parcels_count'];
        var alltotalparcels = jsonResponse['total_allparcels'];
        var alltotalcommissions = jsonResponse['total_allcommissionparcels'];
        var alltotalversements = jsonResponse['total_allversementparcels'];

        print(alltotalparcels);
        setState(() {
          cnt_delivered = parcelCountDelivered;
          cnt_distrubition = parcelCountDistrubition;
          cnt_process = parcelCountProcess;
          cnt_returned = parcelCountReturned;
          cnt_allparcels = allparcelsCount;
          cnt_alltotalparcels = alltotalparcels;
          cnt_alltotalcommissions = alltotalcommissions;
          cnt_alltotalversements = alltotalversements;
        });

        return cnt_delivered;
      }
    } catch (e) {
      print('An error occurred: $e');
    }
    return 0;
  }

  bool isLoading = true; // Initially, show loading screen

  @override
  void initState() {
    super.initState();
    getpre(); // Add this line to get user data
    // Simulate some async operation, e.g., loading data
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        isLoading = false; // Hide loading screen when done
      });
    }).then((value) {
      getparcellivre();
    });
  }

  int _currentIndex = 0; // Track the selected tab index

  // Define the pages for each tab
  final List<Widget> _pages = [
    Dashboard(),
    Parcels(), // Add your second screen widget here
  ];

  // Define the labels for each tab
  final List<String> _tabLabels = [
    'Home',
    'Parcels', // Add the label for the second tab here
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      // appBar: AppBar(
      //   backgroundColor: primary,
      //   title: Text(
      //     _tabLabels[_currentIndex] == 'Home'
      //         ? 'Accueil'
      //         : (_tabLabels[_currentIndex] == 'Parcels' ? 'Colis' : ''),
      //   ),
      //   actions: [
      //     // Add your filter button here
      //     IconButton(
      //       icon: Icon(Icons.tune),
      //       onPressed: () {
      //         // Add your filter button's action here
      //         // For example, you can open a filter dialog or navigate to a filter screen.
      //       },
      //     ),
      //     IconButton(
      //       onPressed: () async {
      //         setState(() {
      //           isLoading = true;
      //         });
      //         await getparcellivre();
      //         setState(() {
      //           isLoading = false;
      //         });
      //       },
      //       icon: Icon(
      //         Icons.refresh_rounded,
      //         size: 35,
      //       ),
      //     ),
      //     // Add your notification bell icon here
      //     IconButton(
      //       icon: Icon(Icons.notifications),
      //       onPressed: () {
      //         // Add your notification button's action here
      //         // For example, you can open a notifications screen.
      //       },
      //     ),
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await getparcellivre();
          setState(() {
            isLoading = false;
          });
        },
        child: isLoading
            ? Center(
                // Show loading indicator while isLoading is true
                child: CircularProgressIndicator(),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0), // Top-left corner radius
                    topRight: Radius.circular(20.0), // Top-right corner radius
                  ),
                  color: Colors.white, // Background color
                ),
                child: _pages[_currentIndex]),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Use Navigator to navigate to the CreateParcel page
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CreateParcel()),
      //     );
      //   },
      //   child: Icon(Icons.add),
      //   backgroundColor: primary,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       IconButton(
      //         icon: Icon(Icons.home),
      //         onPressed: () {
      //           _onTabTapped(0); // Activate the first tab
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.dashboard_sharp),
      //         onPressed: () {
      //           _onTabTapped(1); // Activate the second tab
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      // drawer: Drrawer(),
    );
  }
}
