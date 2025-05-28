import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/ForgotPassword.dart';
import 'package:flutter_application_1/Auth/LoginController.dart';
import 'package:flutter_application_1/Auth/Signup.dart';
import 'package:flutter_application_1/pages/TrackingParcel.dart';
import 'package:flutter_application_1/theme/constant.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var utilisateurEmail = TextEditingController();
  var utilisateurMotDePasse = TextEditingController();

  Logincontroller testDeConnexion = Get.put(Logincontroller());

  @override
  Widget build(BuildContext context) {
    double hauteurEcran = MediaQuery.of(context).size.height;
    double largeurEcran = MediaQuery.of(context).size.width;
    bool afficherBoutonFlottant = MediaQuery.of(context).viewInsets.bottom != 0;
    int _selectedIndex = 1;
    Color _couleurElementSelectionne = Colors
        .blue; // Changez cette couleur en la couleur sélectionnée souhaitée
    Color _couleurElementNonSelectionne = Colors
        .grey; // Changez cette couleur en la couleur non sélectionnée souhaitée

    return Scaffold(
      body: Stack(children: [
        Container(
          width: largeurEcran,
          height: hauteurEcran,
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
                padding: EdgeInsets.only(top: 30, bottom: 25, left: 3),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            100), // Ajoutez le rayon de la bordure ici
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
                        child: GetBuilder<Logincontroller>(
                          builder: (LoginController) {
                            return Form(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 50),

                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //     horizontal: 20,
                                  //   ),
                                  //   child: SizedBox(
                                  //     width: MediaQuery.of(context).size.width *
                                  //         0.8,
                                  //     child: Image.asset(
                                  //       'assets/images/img4.png',
                                  //       width: 250,
                                  //     ),
                                  //   ),
                                  // ),

                                  // const SizedBox(height: 10),
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
                                          controller: utilisateurEmail,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Entrez votre email',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Mot de passe
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
                                          controller: utilisateurMotDePasse,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'Entrez votre mot de passe',
                                            hintStyle: TextStyle(
                                              color: Color(0xFF8391A1),
                                            ),
                                            suffixIcon: Icon(
                                              Icons.remove_red_eye,
                                              color: Color(0xFF8391A1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Mot de passe oublié
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPassword()));
                                        },
                                        child: const Text(
                                          "Mot de passe oublié ?",
                                          style: TextStyle(
                                            color: Color(0xFF6A707C),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Bouton de Login
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
                                            onPressed: () {
                                              testDeConnexion.login(
                                                  utilisateurEmail.text,
                                                  utilisateurMotDePasse.text);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(15.0),
                                              child: Text(
                                                "Se Connecter",
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

                                  // Spacer const
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Je n'ai pas de compte ? ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SignupPage()));
                                        },
                                        child: const Text(
                                          "Inscrivez-vous ",
                                          style: TextStyle(
                                            color: seconde,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: Row(
                                      children: const [
                                        Expanded(
                                          child: Divider(
                                            color: Color(0xFFE8ECF4),
                                            thickness: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Already have an account? Login link
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Suivez l'état de votre colis en cliquant sur",
                                        style: TextStyle(
                                          fontSize:
                                              16, // Adjust the font size to your preference
                                          color: seconde,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                          height:
                                              10), // Reduced the vertical space
                                      MaterialButton(
                                        color: seconde,
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TrackingParcel(),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              12.0), // Adjust the padding
                                          child: Text(
                                            "Suivi Colis",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  14, // Adjust the font size to your preference
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Container(
                                  //   padding: EdgeInsets.all(20),

                                  //   // You can change the color as per your design
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceEvenly,
                                  //     children: [
                                  //       IconButton(
                                  //         icon: Icon(FontAwesomeIcons.facebook,
                                  //             color: Colors.blue, size: 40.0),
                                  //         onPressed: () {
                                  //           // Handle the Facebook icon tap
                                  //         },
                                  //       ),
                                  //       IconButton(
                                  //         icon: Icon(FontAwesomeIcons.instagram,
                                  //             color: Colors.pink, size: 40.0),
                                  //         onPressed: () {
                                  //           // Handle the Facebook icon tap
                                  //         },
                                  //       ),
                                  //       IconButton(
                                  //         icon: Icon(FontAwesomeIcons.whatsapp,
                                  //             color: Colors.green, size: 40.0),
                                  //         onPressed: () {
                                  //           // Handle the Facebook icon tap
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ],
        )
      ]),
    );
  }
}
