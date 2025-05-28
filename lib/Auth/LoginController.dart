import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/Login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/dashboard.dart';
import '../theme/urls.dart';

class Logincontroller extends GetxController {
  var username;
  //save data in cach
  Future savePref(String id, String username, String email, String userStore,
      usertoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', id);
    prefs.setString('username', username);
    prefs.setString('useremail', email);
    prefs.setString('userstore', userStore);
    prefs.setString('usertoken', usertoken);
  }

  Future<String?> getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    username = pref.getString('username');
    return username;
  }

  //function login

  Future logout() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ?? "";

      var response = await http.post(
        Uri.parse('${Urls.baseUrl}api/client-logout'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
// Decode the JSON string into a Map

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();

        Get.offAll(() => Login());
        //Get.snackbar('Alert', 'login');

      } else {
        Get.snackbar(
          'Alert',
          'Error Logout Server down',
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFFCD42),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      String errorMessage = 'An error occurred';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
      }

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

  Future login(email, pass) async {
    try {
      if (email.toString().isNotEmpty && pass.toString().isNotEmpty) {
        var response = await http.post(
            Uri.parse('${Urls.baseUrl}api/client-login'),
            body: ({
              'customers_email': email.toString(),
              'customers_password': pass.toString()
            }),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 201 || response.statusCode == 200) {
// Decode the JSON string into a Map

          Map<String, dynamic> data = json.decode(response.body);

          // print(data['user']['customers_name']);
          // print(data['token']);
          // Access individual fields
          String userId = data['user']['customers_id'].toString();
          String userName = data['user']['customers_name'].toString();
          String userEmail = data['user']['customers_email'].toString();
          String userStore = data['user']['customers_store'].toString();
          String userToken = data['token'].toString();

// Now you can use these variables as needed

          savePref(userId, userName, userEmail, userStore, userToken);

          Get.offAll(() => Dashboard());
          //Get.snackbar('Alert', 'login');
        } else {
          Get.snackbar('Error', 'Email Or Password Incorrect!!!',
              icon: Icon(
                Icons.error,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar(
          'Alert',
          'Please Insert Your Email And password',
          icon: Icon(
            Icons.warning_rounded,
            color: Colors.white,
          ),
          backgroundColor: Color(0xffFFCD42),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error: $e');
      String errorMessage = 'An error occurred';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
      }

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
