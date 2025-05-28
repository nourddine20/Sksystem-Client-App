import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/urls.dart';

class ApiServices {
// Retrieve user token from SharedPreferences
  static Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('usertoken');
  }

  static Future<bool> isTokenValid(String authToken) async {
    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}api/verifyToken'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      // print(jsonDecode(
      //     response.body)['expires_in']); // Check expiration time of the token

      return response.statusCode == 200;
    } catch (error) {
      print('An error occurred while verifying the token: $error');
      return false;
    }
  }

  static Future registerClient(
    String full_name,
    String gmail,
    String phone,
    String city,
    String password,
    String confirm_password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${Urls.baseUrl}api/register-client'),
        body: {
          'new_customers_name': full_name,
          'new_customers_email': gmail,
          'new_customers_phone': phone,
          'new_customers_city': city,
          'new_customers_password': password,
          'new_customers_password_confirmation': confirm_password
        },
        headers: {
          "Accept": "application/json",
        },
      );

      // You can handle success here, e.g., show a success dialog
      final responseBody = json.decode(response.body);

      final status = response.statusCode;
      final message = responseBody['message'];

      return {'status': status, 'message': message};
    } catch (e) {
      print('An error occurred while registering client: $e');
      // Handle the exception, show an error dialog, etc.
      return 'An error occurred while registering client: $e';
    }
  }

  static Future<bool> isThereAreNewParcels() async {
    final response = await http.get(
        Uri.parse('${Urls.baseUrl}api/parcel/check-newParcels'),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> validateEmailisAlreadyExist(email) async {
    final response = await http
        .post(Uri.parse('${Urls.baseUrl}api/check-existingClient'), body: {
      'email': email,
    }, headers: {
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse['exists']);
      print('good morning');
      return jsonResponse['exists'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> validatePhoneisAlreadyExist(phone) async {
    final response = await http
        .post(Uri.parse('${Urls.baseUrl}api/check-existingPhone'), body: {
      'phone': phone,
    }, headers: {
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['exists'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
