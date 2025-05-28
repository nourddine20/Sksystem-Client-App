import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'PdfViewer.dart';

class Deliverynote extends StatefulWidget {
  Deliverynote({Key? key}) : super(key: key);

  @override
  _DeliverynoteState createState() => _DeliverynoteState();
}

class _DeliverynoteState extends State<Deliverynote> {
  late List<Map<String, dynamic>> notes = [];
  late ScrollController _scrollController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadPdfData();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPdfData();
    }
  }

  Future<void> _loadPdfData() async {
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
        Uri.parse('${Urls.baseUrl}api/note/getDeliverynotes'),
        headers: {
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];

        setState(() {
          notes.clear();
          notes.addAll(List<Map<String, dynamic>>.from(data));
          isLoading = false;
        });
      } else {
        print('Response: ${response.body}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      String errorMessage = 'An error occurred';

      if (e.toString().contains("Failed host lookup")) {
        errorMessage = 'Please check your connection.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bons De Livraison'),
        centerTitle: true,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await _loadPdfData();
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 35,
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : notes.isNotEmpty
              ? ListView.builder(
                  controller: _scrollController,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    var date = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(note['delivery_note_time'].toString()) *
                            1000);
                    return Column(
                      children: [
                        ListTile(
                          title: Text(note['delivery_note_ref']),
                          subtitle: Text(
                              note['delivery_note_delivered'].toString() == '1'
                                  ? 'Recu - ${date.toString()}'
                                  : 'Nouveau - ${date.toString()}'),
                          leading: Icon(Icons.description, color: Colors.black),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  String token =
                                      pref.getString('usertoken') ?? "";
                                  bool isTokenValidvar =
                                      await ApiServices.isTokenValid(token);

                                  if (!isTokenValidvar) {
                                    print(
                                        'Token expired or invalid. Redirecting to login page.');
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.clear();
                                    Get.offAll(() => Login());
                                  }
                                  String pdfUrl =
                                      '${Urls.baseUrl}clients/pdf-delivery-note?dn-ref=${note['delivery_note_ref']}&app_token=${token}';

                                  final response =
                                      await http.get(Uri.parse(pdfUrl));

                                  final tempDir = await Directory.systemTemp;
                                  final file = File(path.join(tempDir.path,
                                      '${note['delivery_note_ref']}.pdf'));

                                  await file.writeAsBytes(response.bodyBytes);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PdfViewer(
                                        filePath: file.path,
                                        filecode: note['delivery_note_ref'],
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.remove_red_eye_outlined,
                                    color: Colors.blue),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  // Add your edit delivery note logic here
                                  // For example, navigate to the edit delivery note screen
                                },
                                icon: Icon(Icons.edit, color: Colors.green),
                              ),
                              SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  // Add your add new colis logic here
                                  // For example, navigate to the add new colis screen
                                },
                                icon: Icon(Icons.add_circle, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 1),
                      ],
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sentiment_dissatisfied,
                          size: 48.0, color: Colors.red),
                      SizedBox(height: 8.0),
                      Text('Pas Trouver', style: TextStyle(fontSize: 16.0)),
                    ],
                  ),
                ),
    );
  }
}
