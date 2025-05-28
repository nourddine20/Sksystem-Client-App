// ignore_for_file: unused_import

import 'dart:convert';

import 'package:flutter/material.dart';
// Importing constant.dart with an alias
import 'package:flutter_application_1/theme/constant.dart' as theme_constants;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:url_launcher/url_launcher.dart';

import '../Auth/Login.dart';
import '../theme/urls.dart';
import 'Api.dart';
import 'ChatClaim.dart';
import 'Validation.dart';

class Claim extends StatefulWidget {
  Claim({Key? key}) : super(key: key);

  @override
  _ClaimState createState() => _ClaimState();
}

class _ClaimState extends State<Claim> with SingleTickerProviderStateMixin {
  late List<Map<String, dynamic>> claims = [];
  late ScrollController _scrollController;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(
      vsync: this,
      length: 2,
    ); // Two types: General and Claims
    _tabController.addListener(_handleTabSelection);
    _getclaims().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _getclaims({String type = 'general'}) async {
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

      if (type.isNotEmpty) {
        var response = await http.post(
          Uri.parse('${Urls.baseUrl}api/claim/getclaims'),
          headers: {
            'Authorization': 'Bearer $token',
          },
          body: {'claims_type': type},
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body)['data'];

          // Clear the existing claims before adding new data
          claims.clear();
          claims.addAll(List<Map<String, dynamic>>.from(data));
        } else {
          print('Response: ${response.body}');
          throw Exception('Failed to load data');
        }
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

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getclaims(type: _getTypeFromTabIndex(_tabController.index))
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  void _handleTabSelection() {
    setState(() {
      isLoading = true;
    });
    _getclaims(type: _getTypeFromTabIndex(_tabController.index)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  String _getTypeFromTabIndex(int index) {
    return index == 0 ? 'general' : 'parcels';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('List Reclamations'),
        centerTitle: true,
        backgroundColor: theme_constants.primary,
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
              await _getclaims(
                  type: _getTypeFromTabIndex(_tabController.index));
              setState(() {
                isLoading = false;
              });
            },
            icon: Icon(
              Icons.refresh_rounded,
              size: 35,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'General',
            ),
            Tab(text: 'Colis'),
          ],
          labelColor: Colors.white, // Set the color for the selected tab text
          indicatorColor: Colors.white, // Set the color for the indicator line
        ),
      ),
      body: Column(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildClaimsList('general'),
                      _buildClaimsList('parcels'),

                      // Add more TabBarView children as needed
                    ],
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            builder: (context) => NewReclamationModal(context, null),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: theme_constants.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
    if (parcel_code != null) {
      requestData = {
        'type': 'GENERAL',
        'object': objectController.text,
        'message': messageController.text,
      };
    } else {
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

  Widget _buildClaimsList(String claim_type) {
    if (claims.length > 0) {
      return ListView.builder(
        controller: _scrollController,
        itemCount: claims.length,
        itemBuilder: (context, index) {
          final claim = claims[index];
          var date = DateTime.fromMillisecondsSinceEpoch(
              int.parse(claim['claims_time'].toString()) * 1000);
          return Column(
            children: [
              ListTile(
                title: Text(
                  (claim['parcel_id'] != null
                          ? claim['parcel_code'].toString()
                          : 'general') +
                      ' : ' +
                      claim['claims_object'],
                ),
                subtitle: Text(claim['claims_statut'].toString() == '3'
                    ? 'Reclamation traite - ${date.toString()}'
                    : (claim['claims_statut'].toString() == '2'
                        ? 'Reponse de client en attente - ${date.toString()}'
                        : (claim['claims_statut'].toString() == '1'
                            ? 'Reponse d equipe en attente - ${date.toString()}'
                            : (claim['claims_statut'].toString() == '0'
                                ? 'Reponse d equipe en attente - ${date.toString()}'
                                : '')))),
                leading: FaIcon(
                  FontAwesomeIcons.fileInvoice,
                  color: Colors.black,
                ),
                trailing: ElevatedButton.icon(
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      builder: (context) => Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20.0)),
                          color: Colors
                              .white, // Optionally, you can set a background color
                        ),
                        child: FractionallySizedBox(
                          heightFactor: 0.8, // Set to 90% of the screen height
                          child: ChatModal(
                              claim_id: claim['claims_id'],
                              claim_statut: claim['claims_statut']
                              // Replace with actual client name
                              ),
                        ),
                      ),
                    );
                  },
                  icon: FaIcon(
                    Icons.chat,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text('Chat'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(theme_constants.primary),
                  ),
                ),
                onTap: () async {},
              ),
              Divider(
                thickness: 1,
              ),
            ],
          );
        },
      );
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
  }
}
