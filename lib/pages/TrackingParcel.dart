import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../widgets/TrackParcelByCode.dart';

class TrackingParcel extends StatefulWidget {
  const TrackingParcel({Key? key}) : super(key: key);

  @override
  State<TrackingParcel> createState() => _TrackingParcelState();
}

class _TrackingParcelState extends State<TrackingParcel> {
  TextEditingController _trackingCodeController = TextEditingController();
  bool isTrackingCodeValid = false;
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
                      "Additional Info : \nLivreur: ${trackingHistory[index]["parcel_history_livreur"] != null ? trackingHistory[index]["parcel_history_livreur"] : ''}\nComment : ${trackingHistory[index]["parcel_history_comment"] != null ? trackingHistory[index]["parcel_history_comment"] : ''}",
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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                padding: EdgeInsets.only(top: 30),
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(
                  height: 20), // Add some space between AppBar and content
              Text(
                "Suivi Votre Colis",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Entrez votre code de suivi pour suivre votre colis",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Image.asset(
                  "assets/images/tracking_parcel.png",
                  width: double.infinity,
                  height: 250,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                            controller: _trackingCodeController,
                            decoration: InputDecoration(
                              labelText: "Enter votre suivi code de coli",
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // Validate the input here (you can replace the validation logic)
                              setState(() {
                                isTrackingCodeValid = value.isNotEmpty;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10), // Adjust the spacing as needed
              // "Suivi" button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle the "Suivi" button press
                    // You can use _trackingCodeController.text to get the input value
                    // For example, you can print the value for now
                    // Handle the "Suivi" button press
                    // You can use _trackingCodeController.text to get the input value
                    String trackingCode = _trackingCodeController.text;

                    // Make the API call
                    trackParcelByCode(context, trackingCode);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    "Suivi",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // Already have an account? Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Vous avez déjà un compte? ",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(),
                        ),
                      );
                    },
                    child: const Text(
                      "Connexion",
                      style: TextStyle(
                        color: seconde,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // // Function to make the API call and show the tracking result in a modal
  // void trackParcelByCode(BuildContext context, String trackingCode) async {
  //   // Replace 'YOUR_API_ENDPOINT' with the actual API endpoint
  //   // You may need to modify the headers or request parameters based on your API
  //   // SharedPreferences pref = await SharedPreferences.getInstance();
  //   // String token = pref.getString('usertoken') ?? "";

  //   try {
  //     if (trackingCode.isNotEmpty) {
  //       var response = await http.post(
  //         Uri.parse(
  //             '${Urls.baseUrl}api/tracking-parcel'),
  //         headers: {"Accept": "application/json"},
  //         body: {'parcel_code': trackingCode},
  //       );

  //       final Map<String, dynamic> responseBody = jsonDecode(response.body);

  //       if (response.statusCode == 200) {
  //         var parcelscheck = responseBody['message'];
  //         print('Response Message: $parcelscheck');

  //         final List<dynamic>? trackingHistory = responseBody['data'];
  //         print('Tracking History: $trackingHistory');

  //         if (trackingHistory != null) {
  //           showDialog(
  //             context: context,
  //             builder: (BuildContext context) {
  //               return AlertDialog(
  //                 title: Text("Suivi Colis : $trackingCode"),
  //                 content: buildTrackingResultContent(trackingHistory),
  //                 actions: <Widget>[
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Text("Close"),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         }
  //       } else {
  //         // Handle API call failure
  //         print("Failed to track parcel. Status code: ${response.statusCode}");
  //         // Show an error message in a modal
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text("Error"),
  //               content: Text("Failed to track parcel. Please try again."),
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text("Close"),
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     } else {
  //       Get.snackbar(
  //         'Alert',
  //         'Please enter a tracking code',
  //         icon: Icon(
  //           Icons.warning_rounded,
  //           color: Colors.white,
  //         ),
  //         backgroundColor: Color(0xffFFCD42),
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     String errorMessage = 'An error occurred';

  //     if (e.toString().contains("Failed host lookup")) {
  //       errorMessage = 'Please check your connection.';
  //       Get.snackbar(
  //         'Error',
  //         errorMessage,
  //         icon: Icon(
  //           Icons.error,
  //           color: Colors.white,
  //         ),
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   }
  // }
}
