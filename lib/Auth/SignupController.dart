import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../pages/home.dart';
import '../theme/urls.dart';

class SignupController extends GetxController {
  var username;
  //save data in cach
  // Future savePref(String id, String username, String email, userdata) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('user_id', id);
  //   prefs.setString('username', username);
  //   prefs.setString('useremail', email);
  //   prefs.setString('user_isramasseur', userdata);
  // }

  // Future<String?> getPref() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   username = pref.getString('username');
  //   return username;
  // }

  //function login
  Future Signup(full_name, cin, gmail, phone, store_name, website, city,
      address, companytype, password, confirm_password) async {
    try {
      if (full_name.toString().isNotEmpty &&
          city.toString().isNotEmpty &&
          phone.toString().isNotEmpty &&
          store_name.toString().isNotEmpty &&
          address.toString().isNotEmpty &&
          gmail.toString().isNotEmpty &&
          cin.toString().isNotEmpty &&
          password.toString().isNotEmpty &&
          confirm_password.toString().isNotEmpty) {
        Map<String, dynamic> requestData = {
          "fullName": full_name,
          "city": city,
          "phone": phone,
          "cin": cin,
          "gmail": gmail,
          "store_name": store_name,
          "address": address,
          "website": website,
          "companytype": companytype,
          "password": password,
          "confirm_password": confirm_password,
          // ... other fields ...
        };

        var response = await http.post(
            Uri.parse('${Urls.baseUrl}MyApi_AppClient/api/register-client'),
            body: json.encode(requestData),
            headers: {"Accept": "application/json"});

        if (response.statusCode == 200) {
          var userdata = jsonDecode(response.body);
          // savePref(userdata[0]['users_id'], userdata[0]['users_name'],
          //     userdata[0]['users_email'], userdata[0]['users_is_ramasseur']);
          Get.offAll(() => Home());
          //Get.snackbar('Alert', 'login');
        } else {
          Get.snackbar('Error', 'Fatal Error cant create account try again !!!',
              icon: Icon(
                Icons.error,
                color: Colors.white,
              ),
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      } else {
        Get.snackbar('Error', 'Please fill all invalid inputs !!!',
            icon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white);
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
