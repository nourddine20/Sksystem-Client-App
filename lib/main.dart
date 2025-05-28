import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'splash/Splash_view.dart';
import 'theme/constant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sksystem Clients',
      theme: ThemeData(
        primaryColor: primary,
      ),
      home: Splashpage(),
    );
  }
}
