// // ignore_for_file: unused_element, unnecessary_import

// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_application_1/Auth/Login.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Welcome extends StatefulWidget {
//   const Welcome({super.key});

//   @override
//   State<Welcome> createState() => _WelcomeState();
// }

// class _WelcomeState extends State<Welcome> {
//   late bool showIntroduction = true;

//   @override
//   void initState() {
//     super.initState();
//     _checkIfShowIntroduction();
//   }

//   Future<void> _checkIfShowIntroduction() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool hasShownIntroduction =
//         prefs.getBool('has_shown_introduction') ?? false;

//     setState(() {
//       showIntroduction = !hasShownIntroduction;
//     });
//   }

//   _onIntroEnd(context) async {
//     await _saveIntroductionShown();
//     Navigator.of(context)
//         .push(MaterialPageRoute(builder: (context) => Login()));
//   }

//   Future<void> _saveIntroductionShown() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setBool('has_shown_introduction', true);
//   }

//   _buildFullScreenImage(String Img) {
//     return Container(
//         // margin: const EdgeInsets.only(bottom: 150),
//         // child: Image.asset(
//         //   "assets/images/appLogo.png",
//         //   fit: BoxFit.contain,
//         //   height: double.infinity,
//         //   width: 500,
//         //   alignment: Alignment.topCenter,
//         // ));

//         margin: const EdgeInsets.only(top: 0),
//         child: Image.asset(
//           "assets/images/" + Img,
//           fit: BoxFit.cover,
//           height: double.infinity,
//           width: 370,
//           alignment: Alignment.topCenter,
//         ));
//   }

//   _buildImage(String assetName, [double width = double.infinity]) {
//     return Image.asset('assets/images/$assetName', width: width);
//   }

//   Future savefirstOpen(firstopen) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setBool('is_firstapplied', firstopen);
//   }

//   Future<bool?> getfirstOpen() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool? firstOpen = prefs.getBool('is_firstapplied');

//     return firstOpen;
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     var pageDecoration = const PageDecoration(
//       titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
//       bodyTextStyle: TextStyle(fontSize: 19.0),
//       bodyPadding: EdgeInsets.all(16),
//       pageColor: Colors.white,
//       imagePadding: EdgeInsets.zero,
//     );

//     if (!showIntroduction) {
//       return Login();
//     } else {
//       return IntroductionScreen(
//         globalBackgroundColor: Colors.white,
//         // globalHeader: Align(
//         //   alignment: Alignment.topRight,
//         //   child: SafeArea(
//         //     child: Padding(
//         //       padding: const EdgeInsets.only(top: 16, right: 16),
//         //       child: _buildImage("appLogo.png", 50),
//         //     ),
//         //   ),
//         // ),
//         pages: [
//           PageViewModel(
//             title: "Nos Avantages",
//             body:
//                 "Ramassage Gratuit, Retour Gratuit, Stockage gratuit , Livraison en 24h partout auMaroc. \n A chaque client professionnel ou particulier une offre de prestation personnalisée et complète.",
//             image: _buildFullScreenImage("img2.png"),
//             decoration: pageDecoration.copyWith(
//                 titleTextStyle: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 bodyTextStyle: TextStyle(
//                   color: Color.fromARGB(255, 45, 45, 45),
//                   fontSize: 15,
//                 ),
//                 contentMargin:
//                     const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
//                 bodyFlex: 1,
//                 imageFlex: 2),
//           ),
//           PageViewModel(
//             title: "Livrez Plus, Économisez Plus !",
//             body:
//                 "Remises Avantageuses : Chaque livraison \n effectuée avec Sksystem Assure vous\n rapproche de remises exclusives. Plus vous \n livrez, plus vous économisez.\n Points Cadeaux : Accumulez des points à \n chaque livraison, échangeables contre une\n variété de cadeaux attractifs. Votre fidélité\n mérite d'être récompensée.",
//             image: _buildFullScreenImage("img4.png"),
//             decoration: pageDecoration.copyWith(
//               titleTextStyle: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//               bodyTextStyle: TextStyle(
//                 color: Color.fromARGB(255, 45, 45, 45),
//                 fontSize: 15,
//               ),

//               // bodyAlignmentSet text alignment to left
//               contentMargin: const EdgeInsets.symmetric(horizontal: 10),
//               // fullScreen: true,
//               bodyFlex: 1,
//               imageFlex: 1,
//             ),
//           ),
//           PageViewModel(
//             title: "Support 24/7",
//             body:
//                 "Que ce soit une question, une préoccupation ou \n un besoin d'assistance, notre équipe est\n disponible 24 heures sur 24, 7 jours sur 7 \n Nous sommes là pour vous, à tout moment.",
//             image: _buildFullScreenImage("img3.png"),
//             decoration: pageDecoration.copyWith(
//               titleTextStyle: TextStyle(
//                 color: Colors.black87,
//                 fontSize: 30,
//                 fontWeight: FontWeight.bold,
//               ),
//               bodyTextStyle: TextStyle(
//                 color: Color.fromARGB(255, 45, 45, 45),
//                 fontSize: 15,
//               ),

//               // bodyAlignmentSet text alignment to left
//               contentMargin: const EdgeInsets.symmetric(horizontal: 10),
//               // fullScreen: true,
//               bodyFlex: 1,
//               imageFlex: 2,
//             ),
//           ),
//           // PageViewModel(
//           //   title: "Livrez Plus, Économisez Plus !",
//           //   body:
//           //       "Remises Avantageuses : Chaque livraison effectuée avec Sksystem Assure vous rapproche de remises exclusives. Plus vous livrez, plus vous économisez.\n\n"
//           //       "Points Cadeaux : Accumulez des points à chaque livraison, échangeables contre une variété de cadeaux attractifs. Votre fidélité mérite d'être récompensée.\n\n",
//           //   image: _buildImage("img2.png"),
//           //   decoration: pageDecoration.copyWith(
//           //     titleTextStyle: TextStyle(
//           //       color: Colors.black87,
//           //       fontSize: 30,
//           //       fontWeight: FontWeight.bold,
//           //     ),
//           //     bodyTextStyle: TextStyle(
//           //       color: Color.fromARGB(255, 45, 45, 45),
//           //       fontSize: 15,
//           //     ),
//           //   ),
//           // ),
//           // PageViewModel(
//           //   title: "Support 24/7",
//           //   body:
//           //       "Que ce soit une question, une préoccupation ou un besoin d'assistance, notre équipe est disponible 24 heures sur 24, 7 jours sur 7.\nNous sommes là pour vous, à tout moment.",
//           //   image: _buildImage("img3.png"),
//           //   decoration: pageDecoration.copyWith(
//           //     titleTextStyle: TextStyle(
//           //       color: Colors.black87,
//           //       fontSize: 30,
//           //       fontWeight: FontWeight.bold,
//           //     ),
//           //     bodyTextStyle: TextStyle(
//           //       color: Color.fromARGB(255, 45, 45, 45),
//           //       fontSize: 15,
//           //     ),
//           //   ),
//           // ),
//         ],
//         onDone: () => _onIntroEnd(context),
//         onSkip: () => _onIntroEnd(context), // You can override onSkip callback
//         showSkipButton: true,

//         nextFlex: 0,
//         skip: const Text(
//           "Skip",
//           style: TextStyle(color: Colors.white),
//         ),
//         next: const Icon(
//           Icons.arrow_forward,
//           color: Colors.white,
//         ),
//         done: const Text("Done",
//             style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
//         controlsMargin: const EdgeInsets.all(16),
//         controlsPadding: const EdgeInsets.all(4),
//         dotsDecorator: const DotsDecorator(
//           size: Size(10.0, 10.0),
//           color: Colors.white,
//           activeSize: Size(22.0, 10.0),
//           activeColor: Colors.white,
//           activeShape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(25.0)),
//           ),
//         ),
//         dotsContainerDecorator: const ShapeDecoration(
//           color: Colors.black54,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8.0)),
//           ),
//         ),
//       );
//     }
//     // : WillPopScope(
//     //     onWillPop: () async => false,
//     //     child: Scaffold(
//     //       body: SizedBox(
//     //         height: size.height,
//     //         width: double.infinity,
//     //         child: Stack(
//     //           children: [
//     //             Positioned(
//     //               top: 0,
//     //               left: 0,
//     //               child: Image.asset(
//     //                 "assets/images/main_top.png",
//     //                 width: size.width * 0.3,
//     //               ),
//     //             ),
//     //             Positioned(
//     //               bottom: 0,
//     //               left: 0,
//     //               child: Image.asset(
//     //                 "assets/images/main_bottom.png",
//     //                 width: size.width * 0.2,
//     //               ),
//     //             ),
//     //             Center(
//     //               child: Image.asset(
//     //                 "assets/images/appstore.png",
//     //                 width: size.width * 0.4,
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/Auth/Login.dart';
import 'package:http/http.dart' as http;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/urls.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late bool showIntroduction = true;

  @override
  void initState() {
    super.initState();
    _checkIfShowIntroduction();
  }

  Future<void> _checkIfShowIntroduction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownIntroduction =
        prefs.getBool('has_shown_introduction') ?? false;

    setState(() {
      showIntroduction = !hasShownIntroduction;
    });
  }

  _onIntroEnd(context) async {
    await _saveIntroductionShown();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Login()));
  }

  Future<void> _saveIntroductionShown() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_introduction', true);
  }

  Future<List<Map<String, dynamic>>> _fetchWelcomeData() async {
    print('welcome');
    final response = await http.get(
        Uri.parse('${Urls.baseUrl}api/getwelcomedata'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      bodyPadding: EdgeInsets.all(16),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    if (!showIntroduction) {
      return Login();
    } else {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchWelcomeData(),
        builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Map<String, dynamic>> data = snapshot.data!;
            return IntroductionScreen(
              pages: data.map((item) {
                return PageViewModel(
                  title: item['title'],
                  body: item['body'],
                  image: _buildFullScreenImage(item['image']),
                  decoration: pageDecoration.copyWith(
                      titleTextStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      bodyTextStyle: TextStyle(
                        color: Color.fromARGB(255, 45, 45, 45),
                        fontSize: 15,
                      ),
                      contentMargin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      bodyFlex: 1,
                      imageFlex: 2),
                );
              }).toList(),
              onDone: () => _onIntroEnd(context),
              onSkip: () =>
                  _onIntroEnd(context), // You can override onSkip callback
              showSkipButton: true,
              skip: const Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
              next: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              done: const Text("Done",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.white)),
              controlsMargin: const EdgeInsets.all(16),
              controlsPadding: const EdgeInsets.all(4),
              dotsDecorator: const DotsDecorator(
                size: Size(10.0, 10.0),
                color: Colors.white,
                activeSize: Size(22.0, 10.0),
                activeColor: Colors.white,
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
              dotsContainerDecorator: const ShapeDecoration(
                color: Colors.black54,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            );
          }
        },
      );
    }
  }

  Widget _buildFullScreenImage(String img) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      child: Image.network(
        img,
        fit: BoxFit.cover,
        height: double.infinity,
        width: 370,
        alignment: Alignment.topCenter,
      ),
    );
  }
}
