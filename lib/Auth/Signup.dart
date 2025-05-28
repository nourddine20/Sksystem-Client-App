// ignore_for_file: unnecessary_import, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/Auth/Login.dart';
import 'package:flutter_application_1/Auth/SignupController.dart';
import 'package:flutter_application_1/theme/constant.dart';
import 'package:flutter_application_1/widgets/progress.dart';
import 'package:get/get.dart';

import '../widgets/Api.dart';
import '../widgets/Validation.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late PFormController PFcontroller;
  SignupController SignupFunc = Get.put(SignupController());
  bool isButtonVisible = false; // Define isButtonVisible here
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PFcontroller = PFormController(3);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController cinController = TextEditingController();
  TextEditingController gmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController StoreNameController = TextEditingController();
  TextEditingController WebsiteController = TextEditingController();
  TextEditingController CityController = TextEditingController();
  TextEditingController AddressController = TextEditingController();

  TextEditingController CompanyTypeController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();

  var full_name;

  var gmail;
  var phone;

  var city;

  var password;
  var confirm_password;
  Future<bool> validatePage1Data() async {
    // Perform your validation logic here
    // Return true if the data is valid, otherwise return false

    if (nameController.text.isEmpty ||
        PasswordController.text.isEmpty ||
        ConfirmPasswordController.text.isEmpty ||
        CityController.text.isEmpty ||
        (gmailController.text.isEmpty && phoneController.text.isEmpty)) {
      showValidationErrorSnackbar("Please Fill all The Fields !");
    } else if (!validateEmail(gmailController.text)) {
      print(gmailController.text);
      showValidationErrorSnackbar("invalide email syntex !");
    } else if (!validatePhoneNumber(phoneController.text)) {
      showValidationErrorSnackbar("invalide phone number !");
    } else if (PasswordController.text != ConfirmPasswordController.text) {
      showValidationErrorSnackbar("Confirm password not matching password !");
    } else {
      try {
        bool emailExists =
            await validateEmailisAlreadyExist(gmailController.text);
        print('hello');
        print(emailExists);
        print('howare');
        bool phoneExists =
            await validatePhoneisAlreadyExist(phoneController.text);
        print(emailExists);
        if (emailExists == true) {
          showValidationErrorSnackbar("Email is Already Exist !");
        } else if (phoneExists == true) {
          print('hhh iiii ddd');
          showValidationErrorSnackbar("Phone is Already Exist !");
        } else {
          print('hhhh');
          full_name = nameController.text;

          gmail = gmailController.text;
          phone = phoneController.text;
          city = CityController.text;
          password = PasswordController.text;
          confirm_password = ConfirmPasswordController.text;
          print(gmail);
          return true;
        }
      } catch (e) {
        print('Error: $e');
      }
    }

    return false;
    // if (PFcontroller.currentPage == -1) {
    // } else if (PFcontroller.currentPage == 0) {

    //   String full_name = nameController.text;
    //   String cin = cinController.text;
    //   String gmail = gmailController.text;
    //   String phone = phoneController.text;

    //   if (full_name.isEmpty ||
    //       cin.isEmpty ||
    //       (gmail.isEmpty && phone.isEmpty)) {
    //     showValidationErrorSnackbar("Please Fill all The Fields !");
    //   } else if (!validateEmail(gmail)) {
    //     showValidationErrorSnackbar("invalide email syntex !");
    //   } else if (!validatePhoneNumber(phone)) {
    //     showValidationErrorSnackbar("invalide phone number !");
    //   } else {
    //     return true;
    //   }
    // } else if (PFcontroller.currentPage == 1) {
    //   String store_name = StoreNameController.text;
    //   String website = WebsiteController.text;
    //   String city = CityController.text;
    //   String address = AddressController.text;
    //   return true;
    // } else if (PFcontroller.currentPage == 2) {
    //   String companytype = CompanyTypeController.text;
    //   String password = PasswordController.text;
    //   String confirm_password = ConfirmPasswordController.text;
    //   return true;
    // }

    // if (full_name.isEmpty || cin.isEmpty || gmail.isEmpty || phone.isEmpty) {
    //   // Data is not valid
    //   return false;
    // }

    // SignupFunc.Signup(full_name, cin, gmail, phone, store_name, website, city,
    //     address, companytype, password, confirm_password);
  }

  void showValidationErrorSnackbar(String text_title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text_title),
        duration: Duration(seconds: 2), // Set the duration as needed
        behavior: SnackBarBehavior.floating, // Display at the top
      ),
    );
  }

  Row buildBackButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            PFcontroller.prevPage();
          },
          child: Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 50,
              width: 115,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: seconde,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  Text(
                    "Précédent", // The text you want to display
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )),
        ),
      ],
    );
  }

  Row buildSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(" j'ai déjà un compte . "),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, "/login");
          },
          child: Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double heightscreen = MediaQuery.of(context).size.height;
    double widthscreen = MediaQuery.of(context).size.width;
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;
    int _selectedIndex = 1;
    Color _selectedItemColor =
        Colors.blue; // Change this color to your desired selected color
    Color _unselectedItemColor =
        Colors.grey; // Change this color to your desired unselected color
    return Scaffold(
      body: Stack(children: [
        Container(
          width: widthscreen,
          height: heightscreen,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [primary, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 15, bottom: 15, left: 3),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // Add your action here when the button is pressed
                          // For example, you can navigate back:
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            100), // Add border radius here
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Image.asset(
                            'assets/images/appLogo.png',
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: DraggableScrollableSheet(
                  maxChildSize: 1,
                  minChildSize: 1,
                  initialChildSize: 1,
                  builder: (ctx, controller) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: SingleChildScrollView(
                        controller: controller,
                        child: GetBuilder<SignupController>(
                          builder: (signupController) {
                            return Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),

                                  // Full Name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8F9),
                                        border: Border.all(
                                          color: const Color(0xFFE8ECF4),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Nom et Prénom',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Email
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8F9),
                                        border: Border.all(
                                          color: const Color(0xFFE8ECF4),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          controller: gmailController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'E-mail',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Phone
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8F9),
                                        border: Border.all(
                                          color: const Color(0xFFE8ECF4),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          controller: phoneController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Téléphone',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // City
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8F9),
                                        border: Border.all(
                                          color: const Color(0xFFE8ECF4),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          controller: CityController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Ville',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Password
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8F9),
                                        border: Border.all(
                                          color: const Color(0xFFE8ECF4),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          controller: PasswordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Mot de passe',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Confirm Password
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF7F8F9),
                                        border: Border.all(
                                          color: const Color(0xFFE8ECF4),
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        child: TextFormField(
                                          controller: ConfirmPasswordController,
                                          obscureText: true,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Confirmez le mot de passe',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  // Sign Up Button
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(
                                            color: primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            onPressed: () async {
                                              if (await validatePage1Data()) {
                                                print('name :' +
                                                    full_name +
                                                    ' |  gmail : ' +
                                                    gmail);
                                                final result =
                                                    await registerClient(
                                                        full_name,
                                                        gmail,
                                                        phone,
                                                        city,
                                                        password,
                                                        confirm_password);

                                                final status = result['status'];
                                                final message =
                                                    result['message'];
                                                print('hee');
                                                print(result['message']);
                                                print(status);
                                                if (status == 200) {
                                                  showValidationErrorSnackbar(
                                                      message);
                                                  Get.offAll(() => Login());
                                                } else {
                                                  showValidationErrorSnackbar(
                                                      message);
                                                }
                                              }
                                              // Handle sign up logic here
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Text(
                                                "Inscription",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  // Already have an account? Login link
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Vous avez déjà un compte? ",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Connexion",
                                          style: TextStyle(
                                            color: seconde,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        // child: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     // PForm(
                        //     //   controller: PFcontroller,
                        //     //   pages: [
                        //     //     Page1(
                        //     //       nameController: nameController,
                        //     //       cinController: cinController,
                        //     //       gmailController: gmailController,
                        //     //       phoneController: phoneController,
                        //     //     ),
                        //     //     Page2(
                        //     //         magasinController: StoreNameController,
                        //     //         websiteController: WebsiteController,
                        //     //         cityController: CityController,
                        //     //         addressController: AddressController),
                        //     //     Page3(
                        //     //         companytypeController:
                        //     //             CompanyTypeController,
                        //     //         confirmPasswordController:
                        //     //             ConfirmPasswordController,
                        //     //         passwordController: PasswordController),
                        //     //   ],
                        //     //   title: [
                        //     //     PTitle(
                        //     //       title: "Infos Personnelles",
                        //     //       subTitle: "Ajouter vos infos personnelles",
                        //     //     ),
                        //     //     PTitle(
                        //     //       title: "Infos sur Les addresses",
                        //     //       subTitle: "Ajouter vos infos addresses",
                        //     //     ),
                        //     //     PTitle(
                        //     //       title: "Infos de Sécurité",
                        //     //       subTitle: "Ajouter vos infos securite",
                        //     //     ),
                        //     //   ],
                        //     // )
                        //   ],
                        // ),
                      ),
                    );
                  }),
            ),
          ],
        )
      ]),
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.arrow_back),
      //       label: 'Précédent',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.arrow_forward),
      //       label: 'Suivant',
      //     ),
      //   ],
      //   // Set the current selected index.
      //   currentIndex: _selectedIndex, // Set the current selected index.
      //   selectedItemColor: _selectedItemColor, // Color of the selected tab
      //   unselectedItemColor: _unselectedItemColor, // Color of unselected tabs

      //   onTap: (int index) async {
      //     // Update the selected index when an item is tapped.
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //     // Perform actions based on the selected index.
      //     if (index == 0) {
      //       // Handle the "Précédent" tab tap.
      //       // Add your code here.
      //       PFcontroller.prevPage();
      //     } else if (index == 1) {
      //       // Handle the "Suivant" tab tap.
      //       // Add your code here.
      //       setState(() {
      //         isButtonVisible = true; // Hide the button
      //       });
      //       if (await validatePage1Data()) {
      //         // Data is valid, navigate to the next page

      //         PFcontroller.nextPage();
      //       }
      //     }
      //   },
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Visibility(
      //   visible: !showFab,
      //   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      //     isButtonVisible == true
      //         ? buildBackButton() // Show the Back button
      //         : buildSignUpText(), // Show the Sign Up text

      //     SizedBox(
      //       width: 20,
      //     ),
      //     InkWell(
      //       onTap: () async {
      //         setState(() {
      //           isButtonVisible = true; // Hide the button
      //         });
      //         if (await validatePage1Data()) {
      //           // Data is valid, navigate to the next page

      //           PFcontroller.nextPage();
      //         }
      //       },
      //       child: Container(
      //           margin: EdgeInsets.only(bottom: 10),
      //           height: 50,
      //           width: 110,
      //           alignment: Alignment.center,
      //           decoration: BoxDecoration(
      //               color: seconde, borderRadius: BorderRadius.circular(10)),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Text(
      //                 "Suivant", // The text you want to display
      //                 style: TextStyle(
      //                   color: Color.fromARGB(255, 255, 255, 255),
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               Icon(
      //                 Icons.arrow_forward,
      //                 color: Colors.white,
      //               ),
      //             ],
      //           )),
      //     )
      //   ]),
      // ),
    );
  }
}
