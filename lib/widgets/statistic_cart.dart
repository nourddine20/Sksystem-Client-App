import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Parcels.dart';
import 'package:flutter_application_1/theme/constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'Canceled.dart';
import 'Delivered.dart';
import 'List_transactions.dart';
import 'ParcelDistrubition.dart';
import 'in_progress.dart';

class ElevatedCardExample extends StatelessWidget {
  final String textCart;
  final int dataDegree;
  final int TotalParcels;
  final String customer_rib;
  final String type_card;
  final String code_text;
  ElevatedCardExample(
      {required this.textCart,
      required this.dataDegree,
      required this.TotalParcels,
      required this.type_card,
      required this.code_text,
      required this.customer_rib,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var calc_statis;

    calc_statis = (dataDegree.toDouble() * 100) / TotalParcels.toDouble();

    // ignore: unused_local_variable
    Color chosenColor = Colors.white;
    IconData ChosenIcon = Icons.refresh;
    MaterialColor ColorChart = MaterialColor(0xFF000000, {});

    if (code_text == "total_all_price_livre" ||
        code_text == "total_nbr_parcels_livre") {
      chosenColor = Colors.white;

      ChosenIcon = Icons.delivery_dining_rounded;
    }
    if (code_text == "total_all_price_livre") {
      ColorChart = MaterialColor(0xFF006400, {});
    }

    if (code_text == "total_nbr_parcels_livre") {
      ColorChart = MaterialColor(0xFF90EE90, {});
    }

    if (code_text == "total_all_price_parcels") {
      chosenColor = Colors.white;
      ColorChart = MaterialColor(0xFF006400, {});
      ChosenIcon = Icons.grade_outlined;
    }
    if (code_text == "total_nbr_parcels_nouveau") {
      chosenColor = Colors.white;
      ColorChart = MaterialColor(0xFFADD8E6, {});
      ChosenIcon = Icons.grade_outlined;
    }
    if (code_text == "total_revenue_net") {
      chosenColor = Colors.white;
      ColorChart = MaterialColor(0xFF006400, {});
      ChosenIcon = Icons.payments_outlined;
    }
    if (code_text == "total_nbr_parcels_enprocess") {
      ColorChart = MaterialColor(0xFFCCAF00, {});
      ChosenIcon = Icons.payments_outlined;
    }
    if (code_text == "total_nbr_parcels_return") {
      ColorChart = MaterialColor(0xff860F07, {});
      ChosenIcon = Icons.payments_outlined;
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          // border: type_card == 'wallet' || type_card == 'static'
          //     ? Border.all(
          //         color: type_card == 'wallet'
          //             ? Color.fromARGB(255, 240, 240, 240)
          //             : primary,
          //         width: 2,
          //       )
          //     : null,
          color: type_card == 'wallet'
              ? Color.fromARGB(255, 240, 240, 240)
              : (type_card == 'static' ? primary : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 25,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Card(
          color: (type_card == 'wallet'
              ? primary
              : (type_card == 'numbers' ? Colors.white : chosenColor)),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 15),
            child: SizedBox(
              width: 250,
              height: 150,
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Spacer(),
                        Text(
                          textCart,
                          style: TextStyle(
                              fontSize: type_card == 'wallet' ? 20 : 15,
                              fontWeight: FontWeight.bold,
                              color: type_card == 'wallet'
                                  ? Colors.white
                                  : (type_card == 'static'
                                      ? primary
                                      : Colors.black)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          dataDegree.toString() +
                              (type_card == 'static' || type_card == 'wallet'
                                  ? " DH"
                                  : ""),
                          textAlign: TextAlign
                              .left, // Use the provided dataDegree value
                          style: TextStyle(
                            fontSize: type_card == 'wallet' ? 20 : 25,
                            fontWeight: FontWeight.bold,
                            color: type_card == 'wallet'
                                ? Colors.white
                                : (type_card == 'static'
                                    ? primary
                                    : Colors.black),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: type_card == 'numbers'
                        ? Column(
                            children: [
                              Transform.scale(
                                scale: 1.7,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2, top: 25),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: calc_statis.isFinite
                                            ? calc_statis / 100
                                            : 0,
                                        strokeWidth: 5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                ColorChart),
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                      ),
                                      Text(
                                        calc_statis.isFinite
                                            ? "${calc_statis.toStringAsFixed(2)}%"
                                            : "0.00%",
                                        style: TextStyle(
                                          fontSize: 5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  // Button action
                                  if (code_text == "total_nbr_parcels_livre") {
                                    Get.to(() => ColisDelivered());
                                  } else if (code_text ==
                                      "total_nbr_parcels_nouveau") {
                                    Get.to(() => ParcelDistrubition());
                                  } else if (code_text ==
                                      "total_nbr_parcels_enprocess") {
                                    Get.to(() => Colisinprocess());
                                  } else if (code_text ==
                                      "total_nbr_parcels_return") {
                                    Get.to(() => ColisCanceled());
                                  } else if (code_text ==
                                      "total_all_price_parcels") {
                                    Get.to(() => Parcels());
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: BorderSide(
                                        width: 1.0,
                                        color:
                                            Color.fromARGB(255, 236, 236, 236)),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255)),
                                child: Text(
                                  'voir les détails',
                                  style:
                                      TextStyle(fontSize: 10, color: primary),
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Container(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 20.0, top: 20),
                                  child: IconButton(
                                    onPressed: () async {},
                                    icon: type_card == 'wallet'
                                        ? Icon(Icons.monetization_on,
                                            size: 60, color: Colors.white)
                                        : Icon(ChosenIcon,
                                            size: 50, color: primary),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              type_card == 'wallet'
                                  ? Container(
                                      width: 100,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          // Your button action
                                          // if (code_text == "delivery") {
                                          //   Get.to(() => ColisDelivered());
                                          // } else if (code_text == "distribution") {
                                          //   Get.to(() => ParcelDistribution());
                                          // } else if (code_text == "process") {
                                          //   Get.to(() => ColisInProcess());
                                          // } else if (code_text == "returned") {
                                          //   Get.to(() => ColisCanceled());
                                          // }

                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          20.0)),
                                            ),
                                            builder: (context) =>
                                                NewRetraitModal(
                                                    context, customer_rib),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          side: BorderSide(
                                            width: 1.0,
                                            color: Color.fromARGB(
                                                255, 236, 236, 236),
                                          ),
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        child: Text(
                                          'Retrait',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green[300],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future CreateNewRetrait(customer_rib) async {
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

    final String apiUrl = '${Urls.baseUrl}api/wallet/ajouter-retrait';
    Map<String, dynamic> requestData = {};
    // if (parcel_code != null) {
    requestData = {
      'montant': MontantController.text,
      'rib': customer_rib.toString(),
    };
    // } else {
    // requestData = {
    //   'type': parcel_code,
    //   'object': MontantController.text,
    //   'message': messageController.text,
    // };
    // }$

    print(requestData);

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
      print(response.statusCode);
      if (response.statusCode == 200) {
        Get.snackbar(
          'Succès',
          'Retrait créée avec succès.',
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => List_transactions());
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['message'] ??
            'Échec de la création de la Retrait. Veuillez réessayer.';

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
  TextEditingController MontantController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  // TextEditingController RibController = TextEditingController();

  Widget NewRetraitModal(BuildContext context, customer_rib) =>
      SingleChildScrollView(
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
                    TextFormField(
                      controller: MontantController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Votre Montant *',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre montant';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      // controller: RibController,
                      initialValue: customer_rib,
                      readOnly:
                          true, // Set readOnly to true to make it read-only
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'RIB Bancaire *',
                      ),
                      // Optionally remove the validator if it's not needed
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Veuillez entrer le RIB';
                      //   }
                      //   return null;
                      // },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                CreateNewRetrait(customer_rib);
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
}
