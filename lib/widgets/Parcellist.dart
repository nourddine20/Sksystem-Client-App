// ignore_for_file: unused_local_variable, duplicate_import, deprecated_member_use, duplicate_ignore

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'Claim.dart';
import 'TrackParcelByCode.dart';
// import 'Status.dart';

class Parcellist extends StatefulWidget {
  final parcel_id;
  final vendeur_store;

  final vendeur_phone;
  final vendeur_name;
  final parcel_status;
  final parcel_seconde_status;
  final parcel_type_date;
  final bare_code;
  final parcel_client;
  final parcel_price;
  final parcel_edited;
  final parcel_replace;
  final parcel_phone;
  final parcel_adress;
  final parcel_livreur;
  final parcel_city;
  final parcel_note;
  final parcel_customer;
  final Color? color_status;
  final String? pay_parcels_statut;

  final parcel_statuts_code;

  const Parcellist(
      {Key? key,
      this.parcel_id,
      this.vendeur_store,
      this.vendeur_phone,
      this.vendeur_name,
      this.parcel_status,
      this.bare_code,
      this.parcel_client,
      this.parcel_price,
      this.parcel_edited,
      this.parcel_replace,
      this.parcel_phone,
      this.parcel_adress,
      this.parcel_city,
      this.parcel_livreur,
      this.parcel_note,
      this.parcel_customer,
      this.parcel_seconde_status,
      this.parcel_type_date,
      this.pay_parcels_statut,
      this.color_status,
      this.parcel_statuts_code})
      : super(key: key);

  @override
  _ParcellistState createState() => _ParcellistState();
}

String dateFormated(int timeStamp) {
  var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return DateFormat('dd-MM-yyyy hh:mm').format(dateFromTimeStamp);
}

class _ParcellistState extends State<Parcellist> {
  DeleteParcel(parcelid, parcel_statut_code) async {
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
    var response =
        await http.post(Uri.parse('${Urls.baseUrl}api/parcel/delete-parcel'),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
            body: ({
              'id_parcel': parcelid.toString(),
              'parcel_statut_code': parcel_statut_code.toString()
            }));

    if (response.statusCode == 200) {
      // Reload the widget
      setState(() {});
    } else {
      print(jsonDecode(response.body)['message']);
      Get.snackbar(
        'Error',
        jsonDecode(response.body)['message'],
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // var id;
  // Future<String?> getid() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   id = pref.getString('user_id').toString();
  //   if (id != null) {
  //     id = pref.getString('user_id').toString();
  //   }
  // }

  /*Future getcustumer(idcustomer) async {
    var response = await http.post(
        Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/GetCustum'),
        body: ({'custumer_id': idcustomer.toString()}));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
  }*/

  List<dynamic> lstst = [];
  // Future getstatus() async {
  //   var response = await http.get(
  //     Uri.parse('${Urls.baseUrl}Api_delivery/Rest_Api/getstatus'),
  //   );
  //   if (response.statusCode == 200) {
  //     lstst.addAll(jsonDecode(response.body));
  //   }
  // }

  Future updtstatus(parcel, status) async {
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
    var response = await http
        .post(Uri.parse("${Urls.baseUrl}api/parcel/updatestatut"), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    }, body: {
      'parcel': parcel.toString(),
      'status': status.toString()
    });

    if (response.statusCode == 200) {
      print("is changed statut to call");
    }
  }

  // @override
  // void initState() {
  //   getid();
  //   getstatus();
  //   super.initState();
  // }

  // void whatsappmgs({@required numberphone, @required message}) async {
  //   String url = "whatsapp://send?phone=+212$numberphone&text=$message";
  //   await canLaunch(url) ? launch(url) : print('No cant');
  // }

  void _handleCommentSubmitted(String value) {
    // Do something with the text value
  }

  Future CreateNewRec(parcel_code) async {
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

    final String apiUrl = '${Urls.baseUrl}api/claim/add';
    Map<String, dynamic> requestData = {};
    if (parcel_code == null) {
      requestData = {
        'type': 'GENERAL',
        'object': objectController.text,
        'message': messageController.text,
      };
    } else {
      print(parcel_code);
      requestData = {
        'type': parcel_code,
        'object': objectController.text,
        'message': messageController.text,
      };
    }

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
          'Reclamation créée avec succès.',
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Claim()),
        );
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        final String errorMessage = errorResponse['message'] ??
            'Échec de la création de la Reclamation. Veuillez réessayer.';

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
  TextEditingController objectController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Widget NewReclamationModal(BuildContext context, parcel_code) =>
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
                      controller: objectController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Votre object *',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer votre object';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Message *',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer une Message';
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
                                CreateNewRec(parcel_code);
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

  @override
  Widget build(BuildContext context) {
    int timestamp = int.tryParse(widget.parcel_type_date.toString()) ?? 0;
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    var isButtonEnabedForEdit = true;
    var isButtonEnabedForDelivered = true;
    var isParcelEnabedForDeleted = false;
    var ispay_parcels_statutEnabled = false;
    // Timestamp? DeliveredDate;
    if (widget.parcel_status == 'Livre' ||
        widget.parcel_status == 'Refuse' ||
        widget.parcel_status == 'Annule' ||
        widget.parcel_status == 'Hors-zone') {
      isButtonEnabedForEdit = false;

      isButtonEnabedForDelivered = false;
    }

    if (widget.parcel_statuts_code == "NEW_PARCEL" ||
        widget.parcel_statuts_code == "WAITING_PICKUP") {
      isParcelEnabedForDeleted = true;
    }

    if (widget.pay_parcels_statut != null &&
        (widget.pay_parcels_statut == 'DELIVERED' ||
            widget.pay_parcels_statut == 'REFUSE')) {
      ispay_parcels_statutEnabled = true;
    }

    print(widget.parcel_city);

    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 244, 244, 244), width: 2),
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 210, 210, 210).withOpacity(0.5),
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
                widget.parcel_edited.toString() == "1"
                    ? FaIcon(
                        FontAwesomeIcons.edit,
                        size: 15,
                        color: Colors.amber,
                      )
                    : Container(),
                SizedBox(width: 3),
                widget.parcel_replace.toString() == "1"
                    ? FaIcon(
                        FontAwesomeIcons.repeat,
                        size: 15,
                        color: Colors.amber,
                      )
                    : Container(),
                SizedBox(width: 5),
                Text(
                  widget.bare_code.toString(),
                  style: TextStyle(
                      color: primary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                    color: widget.color_status,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.parcel_status.toString() +
                        ' ' +
                        (widget.parcel_status == 'Réporte' ||
                                widget.parcel_status == 'Reporte' ||
                                widget.parcel_status == 'Livre'
                            ? formattedDate.toString()
                            : ''),
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
              Text('  ${widget.parcel_client}'),
              Text(
                '( ' + widget.parcel_price + 'Dh' + ' )',
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
          Row(
            children: [
              FaIcon(
                FontAwesomeIcons.phoneAlt,
                size: 15,
                color: Colors.amber,
              ),
              Text(
                '  ${widget.parcel_phone}',
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
                Text(
                  '${widget.parcel_adress}',
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.5,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  updtstatus(widget.parcel_id, "ONCALL");
                  await FlutterPhoneDirectCaller.callNumber(
                      widget.parcel_phone);
                },
                icon: FaIcon(
                  FontAwesomeIcons.phoneAlt,
                  color: Colors.blue,
                  size: 26,
                ),
              ),

              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Fermer'),
                            ),
                          ],
                          title: Center(
                            child: Text(
                              'Colis Information',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Container(
                            width: 500,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 500,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Code Suivi:',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 80, 80, 80),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.bare_code.toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Destinataire:',
                                        style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 80, 80, 80),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.parcel_client.toString(),
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Téléphone:',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 80, 80),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.parcel_phone.toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Ville:',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 80, 80),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.parcel_city.toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Adresse:',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 80, 80),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.parcel_adress.toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Commentaire:',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 80, 80),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.parcel_note.toString(),
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Cbrt:',
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 80, 80, 80),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        widget.parcel_price.toString(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                icon: FaIcon(
                  FontAwesomeIcons.eye,
                  color: primary,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () async {
                  trackParcelByCode(context, widget.bare_code);
                },
                icon: FaIcon(
                  FontAwesomeIcons.history,
                  color: Colors.orange,
                  size: 26,
                ),
              ),

              widget.parcel_status.toString() != "NEW_PARCEL" &&
                      widget.parcel_status.toString() != "WAITING_PICKUP" &&
                      widget.parcel_status.toString() != "RECEIVED" &&
                      widget.parcel_status.toString() != "SENT" &&
                      widget.parcel_status.toString() != "PICKED_UP" &&
                      widget.parcel_livreur != null
                  ? IconButton(
                      onPressed: () async {
                        updtstatus(widget.parcel_id, "ONCALL_DELIVERY");

                        await FlutterPhoneDirectCaller.callNumber(
                            widget.parcel_livreur.toString());
                      },
                      icon: Image.asset(
                        'assets/images/iconliv.png',
                        width: 50, // Set the size as needed
                        height: 50,
                        color: Colors
                            .blue, // Only works if your image supports color blending
                      ),
                    )
                  : Container(),
              IconButton(
                onPressed: () async {
                  // trackParcelByCode(context, widget.bare_code);
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    builder: (context) =>
                        NewReclamationModal(context, widget.bare_code),
                  );
                },
                icon: FaIcon(
                  Icons.help,
                  color: Colors.deepOrange,
                  size: 30,
                ),
              ),

              // IconButton(
              //   onPressed: () {
              //     whatsappmgs(
              //         numberphone: widget.parcel_phone,
              //         message:
              //             "Bonjour, Je suis votre livreur Sksystem Je vous confirme pour livrer le colis " +
              //                 widget.bare_code.toString() +
              //                 " de " +
              //                 widget.parcel_price +
              //                 " MAD a payer a la livraison. Trés bon journée");
              //   },
              //   icon: FaIcon(
              //     FontAwesomeIcons.whatsapp,
              //     color: Color(0xFF128C7E),
              //     size: 31,
              //   ),
              // ),
              // Visibility(
              //   visible: isButtonEnabedForDelivered,
              //   child: IconButton(
              //     onPressed: () {
              //       int? ChoosenDate_seconds = 0;
              //       Timestamp? CurrentDate;
              //       DateTime date = DateTime.now();
              //       CurrentDate = Timestamp.fromMillisecondsSinceEpoch(
              //           date.millisecondsSinceEpoch);
              //       ChoosenDate_seconds = CurrentDate.seconds;

              //       AwesomeDialog(
              //         context: context,
              //         dialogType: DialogType.WARNING,
              //         animType: AnimType.BOTTOMSLIDE,
              //         title: 'Confirmation ',
              //         desc: 'Cet Colis Livré Avec Success!!',
              //         btnOkText: 'Oui, Colis Livré',
              //         btnCancelOnPress: () {
              //           Get.back();
              //         },
              //         btnOkOnPress: () {
              //           livre(id.toString(), widget.parcel_id.toString(),
              //               ChoosenDate_seconds);
              //         },
              //       )..show();
              //     },
              //     icon: FaIcon(
              //       FontAwesomeIcons.checkCircle,
              //       color: Colors.blue,
              //       size: 30,
              //     ),
              //   ),
              // ),
              Spacer(),
              Visibility(
                visible: ispay_parcels_statutEnabled,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  decoration: BoxDecoration(
                    color: (widget.pay_parcels_statut.toString() ==
                                "DELIVERED" ||
                            widget.pay_parcels_statut.toString() == "REFUSE")
                        ? Colors.lightBlue
                        : Colors.deepPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (widget.pay_parcels_statut.toString() == "DELIVERED" ||
                                widget.pay_parcels_statut.toString() ==
                                    "REFUSE")
                            ? Icons.paid
                            : Icons.info, // Replace with the desired icon
                        color: Colors.white,
                        size: 15,
                      ),
                      SizedBox(
                          width:
                              5), // Adjust the spacing between the icon and text
                      Text(
                        widget.pay_parcels_statut == null
                            ? "Non Payé"
                            : ((widget.pay_parcels_statut.toString() ==
                                        "DELIVERED" ||
                                    widget.pay_parcels_statut.toString() ==
                                        "REFUSE")
                                ? "Payé"
                                : "Non Payé"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                visible: isParcelEnabedForDeleted,
                child: IconButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      // dialogType: DialogType.DANGER,
                      // animType: AnimType.BOTTOMSLIDE,
                      title: 'Confirmation',
                      desc: 'Cet Colis doit Etre Supprimer !!',
                      btnOkText: 'Oui, Supprimer',
                      btnCancelOnPress: () {
                        // Close the dialog without using Get.back()
                      },
                      btnOkOnPress: () {
                        DeleteParcel(
                            widget.parcel_id, widget.parcel_statuts_code);
                      },
                    )..show();
                  },
                  icon: Icon(
                    Icons.delete, // Replace with the icon you want to use
                    color: Colors.red, // Customize the color if needed
                    size: 30, // Customize the size if needed
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
