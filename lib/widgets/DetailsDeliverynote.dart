import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../Auth/Login.dart';
import '../theme/urls.dart';
import 'Api.dart';

class DetailsDeliverynote extends StatefulWidget {
  const DetailsDeliverynote(BuildContext context, bare_code, {super.key});

  @override
  State<DetailsDeliverynote> createState() => _DetailsDeliverynoteState();
}

class _DetailsDeliverynoteState extends State<DetailsDeliverynote> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Widget buildTrackingResultContent(List<dynamic> trackingHistory) {
  return Container(
    height: double.infinity,
    width: 300,
    child: ListView.builder(
      itemCount: trackingHistory.length,
      itemBuilder: (context, index) {
        String status =
            trackingHistory[index]['parcel_history_statu_name'] ?? 'Unknown';
        Color colorstatus = Colors.black;

        if (status == 'DELIVERED') {
          status = 'Livre';
          colorstatus = Colors.green;
        } else if (status == 'DISTRIBUTION') {
          status = 'Distribution';
          colorstatus = Colors.blue;
        } else if (status == 'NEW_PARCEL') {
          status = 'Nouveau Colis';
          colorstatus = Colors.cyanAccent;
        } else if (status == 'WAITING_PICKUP') {
          status = 'Attente Ramassage';
          colorstatus = Colors.amber;
        } else if (status == 'PICKED_UP') {
          status = 'Ramasser';
          colorstatus = Colors.deepOrange;
        } else if (status == 'SENT') {
          status = 'envoi';
          colorstatus = Colors.indigo;
        } else if (status == 'RECEIVED') {
          status = 'Recevoir';
          colorstatus = Colors.teal;
        } else if (status == 'IN_PROGRESS') {
          status = 'En Progress';
          colorstatus = Colors.yellow;
        } else if (status == 'RETURNED') {
          status = 'Retour';
          colorstatus = Colors.red;
        } else if (status == 'SENT_BY_AMANA') {
          status = 'envoi par amana';
          colorstatus = Colors.grey;
        } else if (status == 'RETURN_BY_AMANA') {
          status = 'Retour par amana';
          colorstatus = Colors.limeAccent;
        } else if (status == 'PROG') {
          status = 'Prog';
          colorstatus = Colors.brown;
        }

        return TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == trackingHistory.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: colorstatus,
          ),
          endChild: Container(
            constraints: const BoxConstraints(
              minHeight: 50,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    status,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Date: " +
                        trackingHistory[index]
                            ['parcel_history_time'], // Add the formatted date
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  // Add any other details you want to display
                  Text(
                    "Additional Info : \nLivreur: ${trackingHistory[index]["parcel_history_livreur"] ?? ''}\nComment : ${trackingHistory[index]["parcel_history_comment"] ?? ''}",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  // Add more Text widgets for additional information
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

void fetchAndShowDetailsDeliverynote(
    BuildContext context, String trackingCode) async {
  try {
    if (trackingCode != null) {
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
        Uri.parse('${Urls.baseUrl}api/note/getParcelsByTypeEdit'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
        // body: jsonEncode({
        //   "type_action": type_action,
        //   "deliverynote_ref": widget.deliverynote_ref
        // })
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        var parcelscheck = responseBody['message'];
        print('Response Message: $parcelscheck');

        final List<dynamic>? trackingHistory = responseBody['data'];
        print('Tracking History: $trackingHistory');

        if (trackingHistory != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Suivi Colis : $trackingCode"),
                content: buildTrackingResultContent(trackingHistory),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle API call failure
        print("Failed to track parcel. Status code: ${response.statusCode}");
        // Show an error message in a modal
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Failed to track parcel. Please try again."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show a snackbar for empty tracking code
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a tracking code'),
        ),
      );
    }
  } catch (e) {
    print('Error: $e');
    String errorMessage = 'An error occurred';

    if (e.toString().contains("Failed host lookup")) {
      errorMessage = 'Please check your connection.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }
}
