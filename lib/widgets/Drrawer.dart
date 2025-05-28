// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
// ignore: unnecessary_import
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/Auth/LoginController.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:flutter_application_1/theme/constant.dart';
import 'package:flutter_application_1/widgets/Claim.dart';
import 'package:flutter_application_1/widgets/Ramassagenote.dart';
import 'package:flutter_application_1/widgets/searchbox.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../pages/Parcels.dart';
import '../theme/urls.dart';
import 'Canceled.dart';
import 'Delivered.dart';
import 'Deliverynote.dart';
import 'Demanderamassage.dart';
import 'Facture.dart';
import 'List_transactions.dart';
import 'ParcelDistrubition.dart';
import 'Returnnote.dart';
import 'in_progress.dart';

class Drrawer extends StatefulWidget {
  const Drrawer({super.key});

  @override
  State<Drrawer> createState() => _DrrawerState();
}

class _DrrawerState extends State<Drrawer> {
  var email;
  var username;
  var store;

  Logincontroller testDeConnexion = Get.put(Logincontroller());

  getpref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    email = pref.getString('useremail');

    if (username != null && email != null) {
      setState(() {
        username = pref.getString('username');
        email = pref.getString('useremail');
        store = pref.getString('userstore');
      });
    }
  }

  var cnt_delivered = 0;
  var cnt_distrubition = 0;
  var cnt_process = 0;
  var cnt_returned = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   getpref();
  //   getpre().then((value) {
  //     getparcellivre();
  //   });
  // }

  @override
  void initState() {
    super.initState();
    getpref();
  }

  @override
  Widget build(BuildContext context) {
    Color titleColor = Colors.black;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Column(children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(height: 10),
                Text(
                  username ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  email ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ]),
              decoration: BoxDecoration(color: primary)),
          ListTile(
            title: Text("Accueil"),
            leading: Icon(Icons.home),
            onTap: () {
              Get.to(() => Home());
            },
          ),
          ListTile(
            title: Text("Portefeuille"),
            leading: Icon(Icons.wallet),
            onTap: () {
              Get.to(() => List_transactions());
            },
          ),
          ExpansionTile(
            backgroundColor: primary,
            leading: Icon(
              Icons.inventory_2,
              size: 20,
              color: Colors.grey,
            ),
            trailing: Icon(
              Icons.expand_more,
              color: Colors.grey,
            ),
            onExpansionChanged: (isExpanded) {
              setState(() {
                // Change title color on click
                titleColor = isExpanded ? Colors.red : Colors.green;
              });
            },
            title: Text('Colis', style: TextStyle(color: titleColor)),
            children: <Widget>[
              ListTile(
                title: Text(
                  'Colis En Attente Ramassage ',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                leading: Icon(
                  Icons.local_shipping,
                  size: 20,
                  color: Colors.white,
                ),
                hoverColor: Colors.amber,
                onTap: () {
                  Get.to(() => ParcelDistrubition());
                },
              ),
              ListTile(
                title: Text(
                  "Colis En Process ",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                leading: Icon(
                  Icons.wifi_protected_setup_sharp,
                  size: 20,
                  color: Colors.white,
                ),
                hoverColor: Colors.amber,
                onTap: () {
                  Get.to(() => Colisinprocess());
                },
              ),
              ListTile(
                title: Text(
                  "Colis En Livraison ",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                leading: Icon(
                  Icons.delivery_dining_outlined,
                  size: 20,
                  color: Colors.white,
                ),
                hoverColor: Colors.amber,
                onTap: () {
                  Get.to(() => ColisDelivered());
                },
              ),
              ListTile(
                title: Text(
                  "Colis En Annulation",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                leading: Icon(
                  Icons.cancel,
                  size: 20,
                  color: Colors.white,
                ),
                hoverColor: Colors.amber,
                onTap: () {
                  Get.to(() => ColisCanceled());
                },
              ),
            ],
          ),
          ListTile(
            title: Text("Bon De Ramassage"),
            leading: Icon(Icons.receipt),
            onTap: () {
              Get.to(() => Ramassagenote());
            },
          ),
          ListTile(
            title: Text("Demande Ramassage"),
            leading: Icon(Icons.local_shipping),
            onTap: () {
              Get.to(() => DemandeRamassage());
            },
          ),
          ListTile(
            title: Text("Reclamation"),
            leading: Icon(Icons.feedback),
            onTap: () {
              Get.to(() => Claim());
            },
          ),
          // ListTile(
          //   title: Text("List Transactions"),
          //   leading: Icon(FontAwesomeIcons.moneyBillTransfer),
          //   onTap: () {
          //     Get.to(() => List_transactions());
          //   },
          // ),
          ListTile(
            title: Text("Bon Retour"),
            leading: Icon(Icons.undo),
            onTap: () {
              Get.to(() => Returnnote());
            },
          ),
          ListTile(
            title: Text("Facture"),
            leading: Icon(Icons.list_alt),
            onTap: () {
              Get.to(() => Facture());
            },
          ),
          ListTile(
            title: Text("Support"),
            leading: Icon(Icons.support),
            onTap: () {},
          ),
          ListTile(
            title: Text("Paramètres"),
            leading: Icon(Icons.settings),
            onTap: () {},
          ),
          ListTile(
            title: Text("Deconnexion"),
            leading: Icon(Icons.logout),
            onTap: () async {
              testDeConnexion.logout();
            },
          )
        ],
      ),
    );
  }
}
