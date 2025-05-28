import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/Parcels.dart';
import 'package:flutter_application_1/theme/constant.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/urls.dart';
import '../widgets/Api.dart';
import '../widgets/Validation.dart';

class CreateParcel extends StatefulWidget {
  @override
  _CreateParcelState createState() => _CreateParcelState();
}

class City {
  final String id;
  final String name;

  City({required this.id, required this.name});
}

class _CreateParcelState extends State<CreateParcel> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  bool ColiRemplacerCheck = false; // Added a list of checkboxes
  String? selectedOptionPeuxOvrire = 'NON'; // Set 'NON' as the default option
  String? selectedOptionPeuxFragile = 'NON'; // Set 'NON' as the default option
  late bool _isLoading = true;

  GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  TextEditingController codeSuiviController = TextEditingController();
  TextEditingController destinataireController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  TextEditingController marchandiseController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();
  TextEditingController villeController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController prixController = TextEditingController();

  City? selectedCity; // Variable to store the selected city
  List<City> cities = []; // List to store the fetched cities

  // Function to fetch cities from the backend
  Future<void> fetchCities() async {
    try {
      if (!_isLoading) {
        return;
      }

      // Set _isLoading to true to prevent multiple simultaneous requests
      setState(() {
        _isLoading = true;
      });

      String? authToken = await ApiServices.getAuthToken();
      bool isTokenValidvar = await ApiServices.isTokenValid(authToken!);

      if (!isTokenValidvar) {
        // Redirect to login page or perform logout actions
        // You might want to use a navigation library (e.g., Get) for navigation
        print('Token expired or invalid. Redirecting to login page.');
        // Example using Get library:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();

        Get.offAll(() => Login()); // Replace '/login' with your login route
      }

      final response = await http.get(
        Uri.parse(
          '${Urls.baseUrl}api/parcel/getActiveCities',
        ),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['data'].length > 0) {
          // Check if 'cities' key exists in the response
          final List<dynamic> cityData = responseData['data'];

          setState(() {
            cities = cityData
                .map((city) => City(
                    id: city['cities_id'].toString(), name: city['cities_nom']))
                .toList();
          });
        } else {
          print('Key "cities" not found in the response');
        }
      } else {
        print('Failed to fetch cities. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred while fetching cities: $error');
    } finally {
      // Set _isLoading to false when data fetching is complete
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> refreshData() async {
    try {
      String? authToken = await ApiServices.getAuthToken();
      if (authToken != null) {
        await fetchCities();
      }
    } catch (error) {
      print('An error occurred during data refresh: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch cities when the widget is initialized

    fetchCities();
  }

  // Function to submit the form data and make the API request
  Future<void> submitForm() async {
    if (_currentStep == 2) {
      if (_formKeyStep1.currentState!.validate() &&
          _formKeyStep2.currentState!.validate()) {
        try {
          // Retrieve the user token from SharedPreferences
          String? authToken = await ApiServices.getAuthToken();

// Check if required fields are not empty

          int OptionPeuxOvrire = 0;
          int OptionPeuxFragile = 0;
          if (selectedOptionPeuxOvrire == "OUI") {
            OptionPeuxOvrire = 1;
          }

          if (selectedOptionPeuxFragile == "OUI") {
            OptionPeuxFragile = 1;
          }

          Map<String, dynamic> parcelData = {
            'parcel_receiver': destinataireController.text.toString(),
            'parcel_phone': telephoneController.text.toString(),
            'parcel_product_name': marchandiseController.text.toString(),
            'parcel_product_qty':
                int.tryParse(quantiteController.text.toString()),
            'parcel_city': int.tryParse(selectedCity!.id),
            'parcel_address': adresseController.text.toString(),
            'parcel_price': int.tryParse(prixController.text.toString()),
            'parcel_replace': ColiRemplacerCheck,
            'parcel_peux_ovrire': OptionPeuxOvrire,
            'parcel_fragile': OptionPeuxFragile,
            'parcel_note': DescriptionController.text.toString(),
          };

          final response = await http.post(
            Uri.parse('${Urls.baseUrl}api/parcel/create'),
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $authToken",
              'Content-Type': 'application/json'
            },
            body: jsonEncode(parcelData),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Parcels()),
            );
            Get.snackbar(
              'Success',
              'Le colis a été créé avec succès!',
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Handle the success case as needed
          } else if (response.statusCode == 401) {
            // Token expired, navigate to login screen
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.remove('user_id');
            prefs.remove('username');
            prefs.remove('useremail');
            prefs.remove('userstore');
            prefs.remove('usertoken');
            Get.off(() => Login(), transition: Transition.cupertinoDialog);
          } else {
            print('Response: ${response.body}');
            throw Exception('Failed to load data');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Creation d'un Coli"),
        centerTitle: true,
        backgroundColor: primary, // Replace with your desired color
      ),
      body: Container(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Container(
                  child: Column(
                    children: [
                      Expanded(
                        child: Stepper(
                          type: stepperType,
                          physics: ScrollPhysics(),
                          currentStep: _currentStep,
                          onStepTapped: (step) => tapped(step),
                          onStepContinue: () {
                            if (_currentStep == 0) {
                              if (_formKeyStep1.currentState!.validate()) {
                                _formKeyStep1.currentState!.save();
                                continued();
                              }
                            } else if (_currentStep == 1) {
                              if (_formKeyStep2.currentState!.validate()) {
                                _formKeyStep2.currentState!.save();
                                continued();
                              }
                            } else {
                              submitForm();
                            }
                          },
                          onStepCancel: cancel,
                          steps: <Step>[
                            Step(
                              title: new Text('Infos'),
                              content: Form(
                                key: _formKeyStep1,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      controller: destinataireController,
                                      decoration: InputDecoration(
                                          labelText: 'Destinataire'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer un destinataire';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.phone,
                                      controller: telephoneController,
                                      decoration: InputDecoration(
                                          labelText: 'Telephone'),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            validatePhoneNumber(value) ==
                                                false ||
                                            ApiServices
                                                    .validatePhoneisAlreadyExist(
                                                        value) ==
                                                true) {
                                          return 'Veuillez entrer telephone';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      controller: marchandiseController,
                                      decoration: InputDecoration(
                                          labelText: 'Marchandise'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer un marchandise';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 0
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: new Text('Prix & Adresses'),
                              content: Form(
                                key: _formKeyStep2,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: quantiteController,
                                      decoration: InputDecoration(
                                          labelText: 'Quantite'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer une quantité';
                                        }
                                        // Check if the value is a valid number using a regular expression
                                        final RegExp numberRegex =
                                            RegExp(r'^[0-9]+$');
                                        if (!numberRegex.hasMatch(value)) {
                                          return 'quantité doit être un nombre valide';
                                        }

                                        if (int.parse(value) < 1) {
                                          return 'quantité doit être un nombre entier positif';
                                        }
                                        return null;
                                      },
                                    ),
                                    // CityDropdown(),
                                    DropdownButtonFormField<City>(
                                      value: _isLoading ? null : selectedCity,
                                      onChanged: (City? value) {
                                        setState(() {
                                          selectedCity = value;
                                        });
                                      },
                                      items: cities.map((City city) {
                                        return DropdownMenuItem<City>(
                                          value: city,
                                          child: Text(city.name),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        labelText: 'Select a City *',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.id.isEmpty) {
                                          return 'Please select a city';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      controller: adresseController,
                                      decoration: InputDecoration(
                                          labelText: 'Adresse *'),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Veuillez entrer un adresse';
                                        }
                                        return null;
                                      },
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: prixController,
                                      decoration:
                                          InputDecoration(labelText: 'Prix *'),
                                      validator: (value) {
                                        final RegExp numberRegex =
                                            RegExp(r'^[0-9]+$');
                                        if (!numberRegex.hasMatch(value!)) {
                                          return 'Prix doit être un nombre valide';
                                        }

                                        if (int.parse(value) < 0) {
                                          return 'Prix doit être un nombre entier positif';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 1
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                            Step(
                              title: new Text("Description"),
                              content: Column(
                                children: <Widget>[
                                  TextFormField(
                                    controller: DescriptionController,
                                    decoration: InputDecoration(
                                        labelText:
                                            'Commentaire ( Autre telephone, Date de livraison ...)'),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(children: [
                                    Text("Colis a remplacer"),
                                    Checkbox(
                                      value: ColiRemplacerCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          ColiRemplacerCheck = value!;
                                        });
                                      },
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(children: [
                                    Text("Peux Ovrire Colis"),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    DropdownButton<String>(
                                      value: selectedOptionPeuxOvrire,
                                      onChanged: (String? value) {
                                        setState(() {
                                          selectedOptionPeuxOvrire = value;
                                        });
                                      },
                                      items: <String>['OUI', 'NON']
                                          .map((String option) {
                                        return DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text("Peux Fragile Colis"),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      DropdownButton<String>(
                                        value: selectedOptionPeuxFragile,
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedOptionPeuxFragile = value;
                                          });
                                        },
                                        items: <String>['OUI', 'NON']
                                            .map((String option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(option),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              isActive: _currentStep >= 0,
                              state: _currentStep >= 2
                                  ? StepState.complete
                                  : StepState.disabled,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.refresh),
      //   onPressed: refreshData,
      // ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    if (_currentStep < 2) {
      setState(() => _currentStep += 1);
    }
  }

  cancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }
}
