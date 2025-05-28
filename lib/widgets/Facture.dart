// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'Api.dart';
import 'PdfViewer.dart';

class Facture extends StatefulWidget {
  Facture({Key? key}) : super(key: key);

  @override
  _FactureState createState() => _FactureState();
}

class _FactureState extends State<Facture> {
  late List<Map<String, dynamic>> notes = [];
  late ScrollController _scrollController;
  // late bool _isLoading;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _getpdf().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getpdf().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  Future<void> _getpdf() async {
    try {
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

      var response = await http.get(
        Uri.parse('${Urls.baseUrl}api/note/getInvoicenotes'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        // Clear the existing parcels before adding new data
        notes.clear();

        notes.addAll(List<Map<String, dynamic>>.from(data));
      } else {
        print('Response: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      String errorMessage = 'An error occurred';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('List Factures'),
          centerTitle: true,
          backgroundColor: primary,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await _getpdf();
                setState(() {
                  isLoading = false;
                });
              },
              icon: Icon(
                Icons.refresh_rounded,
                size: 35,
              ),
            ),
          ]),
      body: isLoading
          ? Center(
              // Show loading indicator while isLoading is true
              child: CircularProgressIndicator(),
            )
          : FutureBuilder<void>(
              future: _getpdf(),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                // final bool hasMoreData =
                //     snapshot.connectionState == ConnectionState.done &&;
                print('sdfsdf');

                print(notes.length);
                print('goood');
                if (notes.length > 0) {
                  return Column(children: [
                    Expanded(
                        child: ListView.builder(
                      controller: _scrollController,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        var date = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(note['invoice_time'].toString()) * 1000);
                        return Column(children: [
                          ListTile(
                            title: Text(
                              note['invoice_ref'],
                            ),
                            subtitle: Text(note['invoice_statut'].toString() ==
                                    '2'
                                ? 'Paye - ${date.toString()}'
                                : (note['invoice_statut'].toString() == '1'
                                    ? 'Enregistre - ${date.toString()}'
                                    : (note['invoice_statut'].toString() == '0'
                                        ? 'Brouillon - ${date.toString()}'
                                        : ''))),
                            leading: FaIcon(
                              FontAwesomeIcons.fileInvoice,
                              color: Colors.black,
                            ),
                            trailing: ElevatedButton.icon(
                              onPressed: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                String token = pref.getString('usertoken') ??
                                    ""; // Replace 'token' with the actual key used to store the token in SharedPreferences
                                bool isTokenValidvar =
                                    await ApiServices.isTokenValid(token);

                                if (!isTokenValidvar) {
                                  // Redirect to login page or perform logout actions
                                  // You might want to use a navigation library (e.g., Get) for navigation
                                  print(
                                      'Token expired or invalid. Redirecting to login page.');
                                  // Example using Get library:
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.clear();
                                  Get.offAll(() =>
                                      Login()); // Replace '/login' with your login route
                                }
                                String pdfUrl =
                                    '${Urls.baseUrl}clients/pdf-invoices?inv-ref=${note['invoice_ref']}&app_token=${token}';

                                final response =
                                    await http.get(Uri.parse(pdfUrl));

                                final tempDir = await Directory
                                    .systemTemp; // Get the temporary directory
                                final file = File(path.join(tempDir.path,
                                    '${note['invoice_ref']}.pdf')); // Construct file path using path package

                                await file.writeAsBytes(response.bodyBytes);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PdfViewer(
                                      filePath: file.path,
                                      filecode: note['invoice_ref'],
                                    ),
                                  ),
                                );
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.arrowRight,
                                color: primary,
                                size: 0,
                              ),
                              label: Text('Details'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(primary),
                              ),
                            ),
                            onTap: () async {},
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ]);
                      },
                    )),
                  ]);
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.sentiment_dissatisfied,
                          size: 48.0,
                          color: Colors.red,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Pas Trouver',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  );
                }
              }),
    );
  }
}
