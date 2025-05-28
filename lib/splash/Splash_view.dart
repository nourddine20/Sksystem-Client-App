import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Welcome.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashpage extends StatefulWidget {
  Splashpage({Key? key}) : super(key: key);

  @override
  _SplashpageState createState() => _SplashpageState();
}

class _SplashpageState extends State<Splashpage> {
  var islogin;
  Future _getuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    islogin = prefs.getString('username');
    setState(() {
      islogin = prefs.getString('username');
    });
  }

  @override
  void initState() {
    _getuser().whenComplete(() async => Timer(Duration(seconds: 5), () {
          Get.off(() => islogin == null ? Welcome() : Home());
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/loading.gif',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                height: 150,
                width: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
