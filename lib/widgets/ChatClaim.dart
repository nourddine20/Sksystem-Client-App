// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// import '../Auth/Login.dart';
// import '../theme/constant.dart';
// import '../theme/urls.dart';
// import 'Api.dart';

// class ChatMessage {
//   ChatMessage({
//     claimsMsgId,
//     required claimsMsgClaim,
//     required claimsMsgFrom,
//     required claimsMsgFromId,
//     required day,
//     required hour,
//     required minute,
//     required claimsMsgText,
//     DateTime? claimsMsgTime,
//   });
// }

// class ChatModal extends StatefulWidget {
//   final claim_id;
//   ChatModal({
//     required this.claim_id,
//   });

//   @override
//   _ChatModalState createState() => _ChatModalState();
// }

// class _ChatModalState extends State<ChatModal> {
//   TextEditingController _messageController = TextEditingController();
//   List<ChatMessage> _messages = [];

//   Future<List<ChatMessage>> fetchMessages() async {
//     try {
//       SharedPreferences pref = await SharedPreferences.getInstance();
//       String token = pref.getString('usertoken') ?? "";
//       bool isTokenValidvar = await ApiServices.isTokenValid(token);

//       if (!isTokenValidvar) {
//         print('Token expired or invalid. Redirecting to login page.');
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.clear();
//         Get.offAll(() => Login());
//       }

//       final response = await http.post(
//         Uri.parse(
//             '${Urls.baseUrl}api/claim/chat/get_messages'),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//         body: {'claims_id': widget.claim_id},
//       );

//       if (response.statusCode == 200) {
//         // Inside fetchMessages method
//         final List<dynamic> data = jsonDecode(response.body)['data'];
//         return data.map((message) {
//           return ChatMessage(
//             claimsMsgId: message['claims_msg_id'],
//             claimsMsgClaim: message['claims_msg_claim'].toString(),
//             claimsMsgFrom: message['claims_msg_from'].toString(),
//             claimsMsgText: message['claims_msg_text'].toString(),
//             claimsMsgFromId: message['claims_msg_from_id'].toString(),
//             claimsMsgTime: DateTime.fromMillisecondsSinceEpoch(
//                 int.parse(message['claims_msg_time']) * 1000),
//             day: message['day'].toString(),
//             hour: message['hour'].toString(),
//             minute: message['minute'].toString(),
//           );
//         }).toList();
//       } else {
//         throw Exception('Failed to load messages');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Call the function to fetch messages when the widget initializes
//     fetchMessages().then((messages) {
//       setState(() {
//         _messages.addAll(messages);
//       });
//     }).catchError((error) {
//       print('Error fetching messages: $error');
//       // Handle error as needed
//     });
//   }

//   Future<void> _sendMessage() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String user_id = pref.getString('usertoken') ?? "";
//     setState(() {
//       _messages.add(ChatMessage(
//         claimsMsgText: _messageController.text,
//         claimsMsgFrom: 1,
//         claimsMsgFromId: user_id,
//         claimsMsgClaim: widget.claim_id,
//         day: DateTime.now(),
//         hour: DateTime.now().hour,
//         minute: DateTime.now().minute,
//       ));
//       _messageController.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat'),
//         backgroundColor: primary,
//         actions: [
//           IconButton(
//             onPressed: () {
//               fetchMessages().then((messages) {
//                 setState(() {
//                   _messages.clear(); // Clear existing messages
//                   _messages.addAll(messages); // Add new messages

//                   print('get data');
//                   print(_messages.length);
//                   _messages.forEach((message) {
//                     print('claimsMsgId: ${message}');
//                     print('claimsMsgClaim: ${message.claimsMsgClaim}');
//                     print('claimsMsgFrom: ${message.claimsMsgFrom}');
//                     print('claimsMsgFromId: ${message.claimsMsgFromId}');
//                     print('day: ${message.day}');
//                     print('hour: ${message.hour}');
//                     print('minute: ${message.minute}');
//                     print('claimsMsgText: ${message.claimsMsgText}');
//                     print('claimsMsgTime: ${message.claimsMsgTime}');
//                     print('---');
//                   });
//                 });
//               }).catchError((error) {
//                 print('Error fetching messages: $error');
//  Handle error as needed
//               });
//             },
//             icon: Icon(
//               Icons.refresh,
//               size: 35,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.separated(
//               padding: EdgeInsets.only(right: 5),
//               itemCount: _messages.length,
//               separatorBuilder: (context, index) {
//                 print(index);
//  if (index == 0) {
// //                 return SizedBox
// //                     .shrink(); // No separator at the beginning of the list
//  }

//  Check if the current message and the previous one are on different dates
//  final previousMessageDate = _messages[index - 1].day.toLocal();
//  final currentMessageDate = _messages[index].day.toLocal();
//  final areDifferentDates =
//      previousMessageDate.day != currentMessageDate.day;

//  Return a separator if the dates are different
//  if (areDifferentDates) {
//    return Container(
//      margin: EdgeInsets.symmetric(vertical: 8.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          Container(
//            height: 1.0,
//            width: MediaQuery.of(context).size.width * 0.7,
//            color: Colors.grey[300],
//          ),
//          Container(
//            padding: EdgeInsets.symmetric(horizontal: 8.0),
//            child: Text(
//              '${currentMessageDate.day}/${currentMessageDate.month}/${currentMessageDate.year}',
//              style: TextStyle(
//                  fontSize: 12.0, color: Colors.grey[600]),
//            ),
//          ),
//          Container(
//            height: 1.0,
//            width: MediaQuery.of(context).size.width * 0.7,
//            color: Colors.grey[300],
//          ),
//        ],
//      ),
//    );
//  } else {
//    return SizedBox.shrink();
//  }
// //               },
// //               itemBuilder: (context, index) {
//  final messageDate = _messages[index].day.toLocal();
//  final formattedDate =
//      '${messageDate.hour}:${messageDate.minute}';

//  final currentDate = DateTime.now().toLocal();
//  final formattedDate = messageDate.day == currentDate.day &&
//          messageDate.month == currentDate.month &&
//          messageDate.year == currentDate.year
//      ? 'Today, ${messageDate.hour}:${messageDate.minute}'
//      : '${messageDate.day}/${messageDate.month}/${messageDate.year}';

// //                 return Row(
//  mainAxisAlignment: _messages[index].claimsMsgFrom == 1
//      ? MainAxisAlignment.start
//      : MainAxisAlignment.end,
//  children: [
//    _messages[index].claimsMsgFrom == 1
//        ? Padding(
//            padding: const EdgeInsets.only(
//              top: 35,
//              left:
//                  8.0, // Adjust the right padding for proper spacing
//            ),
//            child: Icon(
//              Icons.person_pin,
//              size: 30.0,
//              color: Colors.green[600],
//            ),
//          )
//        : Container(),
//    Container(
//      padding: EdgeInsets.symmetric(
//          vertical: 10.0, horizontal: 10.0),
//      margin:
//          EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//      decoration: BoxDecoration(
//        color: _messages[index].claimsMsgFrom == 1
//            ? primary
//            : Color.fromARGB(255, 240, 240, 240),
//        borderRadius: BorderRadius.only(
//          topLeft: Radius.circular(15.0),
//          topRight: Radius.circular(15.0),
//          bottomLeft: _messages[index].claimsMsgFrom == 1
//              ? Radius.circular(0.0)
//              : Radius.circular(15.0),
//          bottomRight: _messages[index].claimsMsgFrom == 1
//              ? Radius.circular(15.0)
//              : Radius.circular(0.0),
//        ),
//        boxShadow: [
//          BoxShadow(
//            color: Colors.grey.withOpacity(0.5),
//            spreadRadius: 2,
//            blurRadius: 5,
//            offset: Offset(0, 3),
//          ),
//        ],
//      ),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: [
//          Text(
//            _messages[index].message,
//            style: TextStyle(
//              fontSize: 14.0,
//              color: _messages[index].claimsMsgFrom == 1
//                  ? Colors.white
//                  : seconde,
//            ),
//          ),
//          SizedBox(height: 5.0),
//          Text(
//            formattedDate,
//            style: TextStyle(
//              fontSize: 8.0,
//              color: _messages[index].claimsMsgFrom == 1
//                  ? seconde
//                  : Color.fromARGB(255, 120, 120, 120),
//            ),
//          ),
//        ],
//      ),
//    ),
//    !_messages[index].claimsMsgFrom == 1
//        ? Padding(
//            padding: const EdgeInsets.only(
//              top: 35,
//              right:
//                  8.0, // Adjust the right padding for proper spacing
//            ),
//            child: Icon(
//              Icons.support_agent_rounded,
//              size: 30.0,
//              color: Colors.green[600],
//            ),
//          )
//        : Container(),
//  ],
//                     );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white, // You can change the color as needed
//                 borderRadius: BorderRadius.circular(
//                     20.0), // Adjust the border radius as needed
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3), // changes position of shadow
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                       child: TextField(
//                         controller: _messageController,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: 'Type a message...',
//                         ),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.send),
//                     onPressed: _sendMessage,
//                     color:
//                         primary, // Assuming primary is defined and accessible here
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/Api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Auth/Login.dart';
import '../theme/constant.dart';
import '../theme/urls.dart';

class ChatMessage {
  final String? claimsMsgId;
  final String claimsMsgClaim;
  final String claimsMsgFrom;
  final String claimsMsgFromId;
  final String day;
  final String month;
  final String year;
  final String date;
  final String hour;
  final String minute;
  final String claimsMsgText;
  final DateTime? claimsMsgTime;

  ChatMessage({
    this.claimsMsgId,
    required this.claimsMsgClaim,
    required this.claimsMsgFrom,
    required this.claimsMsgFromId,
    required this.day,
    required this.hour,
    required this.minute,
    required this.claimsMsgText,
    this.claimsMsgTime,
    required this.date,
    required this.month,
    required this.year,
  });
}

class ChatModal extends StatefulWidget {
  final claim_id;
  final claim_statut;
  ChatModal({
    required this.claim_id,
    required this.claim_statut,
  });

  @override
  _ChatModalState createState() => _ChatModalState();
}

class _ChatModalState extends State<ChatModal> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _messages = [];

  Future<List<ChatMessage>> fetchMessages() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ?? "";
      bool isTokenValidvar = await ApiServices.isTokenValid(token);

      if (!isTokenValidvar) {
        print('Token expired or invalid. Redirecting to login page.');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login());
      }

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}api/claim/chat/get_messages'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {'claims_id': widget.claim_id},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((message) {
          return ChatMessage(
            claimsMsgId: message['claims_msg_id'].toString(),
            claimsMsgClaim: message['claims_msg_claim'].toString(),
            claimsMsgFrom: message['claims_msg_from'].toString(),
            claimsMsgText: message['claims_msg_text'].toString(),
            claimsMsgFromId: message['claims_msg_from_id'].toString(),
            claimsMsgTime: DateTime.fromMillisecondsSinceEpoch(
                int.parse(message['claims_msg_time']) * 1000),
            date: message['date'].toString(),
            day: message['day'].toString(),
            month: message['month'].toString(),
            year: message['year'].toString(),
            hour: message['hour'].toString(),
            minute: message['minute'].toString(),
          );
        }).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> SaveMessage(String message_text, String claim_id) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String token = pref.getString('usertoken') ?? "";
      bool isTokenValidvar = await ApiServices.isTokenValid(token);

      if (!isTokenValidvar) {
        print('Token expired or invalid. Redirecting to login page.');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Get.offAll(() => Login());
      }

      final response = await http.post(
        Uri.parse('${Urls.baseUrl}api/claim/chat/save_messages'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: {'claims_id': claim_id, 'message_text': message_text},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMessages().then((messages) {
      setState(() {
        _messages.addAll(messages);
      });
    }).catchError((error) {
      print('Error fetching messages: $error');
    });
  }

  Future<void> _sendMessage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String user_id = pref.getString('usertoken') ?? "";

    // _messages.add(ChatMessage(
    //   claimsMsgText: _messageController.text,
    //   claimsMsgFrom: '1',
    //   claimsMsgFromId: user_id,
    //   claimsMsgClaim: widget.claim_id.toString(),
    //   day: DateTime.now().toString(),
    //   hour: DateTime.now().hour.toString(),
    //   minute: DateTime.now().minute.toString(),
    // ));

    if (await SaveMessage(
        _messageController.text, widget.claim_id.toString())) {
      fetchMessages().then((messages) {
        setState(() {
          _messages.clear(); // Clear existing messages
          _messages.addAll(messages); // Add new messages
        });
      }).catchError((error) {
        print('Error fetching messages: $error');
      });
    }

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.claim_statut);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          backgroundColor: primary,
          actions: [
            IconButton(
              onPressed: () {
                fetchMessages().then((messages) {
                  setState(() {
                    _messages.clear(); // Clear existing messages
                    _messages.addAll(messages); // Add new messages
                  });
                }).catchError((error) {
                  print('Error fetching messages: $error');
                });
              },
              icon: Icon(
                Icons.refresh,
                size: 35,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(right: 5),
                itemCount: _messages.length,
                separatorBuilder: (context, index) {
                  // final currentMessageDate =
                  //     _messages[0].claimsMsgTime ?? DateTime.now();
                  // final formattedDate =
                  //     '${currentMessageDate.day}/${currentMessageDate.month}/${currentMessageDate.year}';

                  return Container();
                  // return Container(
                  //   margin: EdgeInsets.symmetric(vertical: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         height: 1.0,
                  //         width: MediaQuery.of(context).size.width * 0.7,
                  //         color: Colors.grey[300],
                  //       ),
                  //       Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 8.0),
                  //         child: Text(
                  //           formattedDate,
                  //           style: TextStyle(
                  //             fontSize: 12.0,
                  //             color: Colors.grey[600],
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 1.0,
                  //         width: MediaQuery.of(context).size.width * 0.7,
                  //         color: Colors.grey[300],
                  //       ),
                  //     ],
                  //   ),
                  // );
                },
                itemBuilder: (context, index) {
                  final currentDate = DateTime.now().toLocal();
                  final formattedDate = _messages[index].day ==
                              currentDate.day &&
                          _messages[index].month == currentDate.month &&
                          _messages[index].year == currentDate.year
                      ? 'Today, ${_messages[index].hour}:${_messages[index].minute}'
                      : '${_messages[index].day}/${_messages[index].month}/${_messages[index].year} ${_messages[index].hour}:${_messages[index].minute}';
                  return Row(
                    mainAxisAlignment: _messages[index].claimsMsgFrom != '1'
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      _messages[index].claimsMsgFrom != '1'
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 35,
                                left:
                                    8.0, // Adjust the right padding for proper spacing
                              ),
                              child: Icon(
                                Icons.support_agent_rounded,
                                size: 30.0,
                                color: Colors.green[600],
                              ),
                            )
                          : Container(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: _messages[index].claimsMsgFrom == '1'
                              ? primary
                              : Color.fromARGB(255, 240, 240, 240),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                            bottomLeft: _messages[index].claimsMsgFrom != '1'
                                ? Radius.circular(0.0)
                                : Radius.circular(15.0),
                            bottomRight: _messages[index].claimsMsgFrom != '1'
                                ? Radius.circular(15.0)
                                : Radius.circular(0.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _messages[index].claimsMsgText,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: _messages[index].claimsMsgFrom == '1'
                                    ? Colors.white
                                    : seconde,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 8.0,
                                color: _messages[index].claimsMsgFrom == '1'
                                    ? seconde
                                    : Color.fromARGB(255, 120, 120, 120),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _messages[index].claimsMsgFrom == '1'
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 35,
                                right:
                                    8.0, // Adjust the right padding for proper spacing
                              ),
                              child: Icon(
                                Icons.person_pin,
                                size: 30.0,
                                color: Colors.green[600],
                              ),
                            )
                          : Container(),
                    ],
                  );
                },
              ),
            ),
            widget.claim_statut.toString() != '3'
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // You can change the color as needed
                        borderRadius: BorderRadius.circular(
                            20.0), // Adjust the border radius as needed
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a message...',
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _sendMessage,
                            color:
                                primary, // Assuming primary is defined and accessible here
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}



  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Chat'),
  //       backgroundColor: primary,
  //       actions: [
  //         IconButton(
  //           onPressed: () {
  //             fetchMessages().then((messages) {
  //               setState(() {
  //                 _messages.clear();
  //                 _messages.addAll(messages);

  //                 print('get data');
  //                 print(_messages.length);
  //                 _messages.forEach((message) {
  //                   print('claimsMsgId: ${message.claimsMsgId}');
  //                   print('claimsMsgClaim: ${message.claimsMsgClaim}');
  //                   print('claimsMsgFrom: ${message.claimsMsgFrom}');
  //                   print('claimsMsgFromId: ${message.claimsMsgFromId}');
  //                   print('day: ${message.day}');
  //                   print('hour: ${message.hour}');
  //                   print('minute: ${message.minute}');
  //                   print('claimsMsgText: ${message.claimsMsgText}');
  //                   print('claimsMsgTime: ${message.claimsMsgTime}');
  //                   print('---');
  //                 });
  //               });
  //             }).catchError((error) {
  //               print('Error fetching messages: $error');
  //             });
  //           },
  //           icon: Icon(
  //             Icons.refresh,
  //             size: 35,
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: Column(
  //       children: [
  //         Expanded(
  //           child: ListView.separated(
  //             padding: EdgeInsets.only(right: 10),
  //             itemCount: _messages.length,
  //             separatorBuilder: (context, index) {
  //               final messageDate = _messages[index].day;
  //               return Container(
  //                 margin: EdgeInsets.symmetric(vertical: 8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Container(
  //                       height: 1.0,
  //                       width: MediaQuery.of(context).size.width * 0.7,
  //                       color: Colors.grey[300],
  //                     ),
  //                     Container(
  //                       padding: EdgeInsets.symmetric(horizontal: 8.0),
  //                       child: Text(
  //                         '${messageDate}',
  //                         style: TextStyle(
  //                             fontSize: 12.0, color: Colors.grey[600]),
  //                       ),
  //                     ),
  //                     Container(
  //                       height: 1.0,
  //                       width: MediaQuery.of(context).size.width * 0.7,
  //                       color: Colors.grey[300],
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             },
  //             itemBuilder: (context, index) {
  //               final formattedDate =
  //                   '${_messages[index].hour}:${_messages[index].minute}';

  //               // final formattedDate = messageDate.day == currentDate.day &&
  //               //         messageDate.month == currentDate.month &&
  //               //         messageDate.year == currentDate.year
  //               //     ? 'Today, ${messageDate.hour}:${messageDate.minute}'
  //               //     : '${messageDate.day}/${messageDate.month}/${messageDate.year}';

  //               return Row(
  //                 mainAxisAlignment: _messages[index].claimsMsgFrom == '1'
  //                     ? MainAxisAlignment.start
  //                     : MainAxisAlignment.end,
  //                 children: [
  //                   _messages[index].claimsMsgFrom == '1'
  //                       ? Padding(
  //                           padding: const EdgeInsets.only(
  //                             top: 35,
  //                             left:
  //                                 8.0, // Adjust the right padding for proper spacing
  //                           ),
  //                           child: Icon(
  //                             Icons.person_pin,
  //                             size: 30.0,
  //                             color: Colors.green[600],
  //                           ),
  //                         )
  //                       : Container(),
  //                   Container(
  //                     padding: EdgeInsets.symmetric(
  //                         vertical: 10.0, horizontal: 10.0),
  //                     margin:
  //                         EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
  //                     decoration: BoxDecoration(
  //                       color: _messages[index].claimsMsgFrom == '1'
  //                           ? primary
  //                           : Color.fromARGB(255, 240, 240, 240),
  //                       borderRadius: BorderRadius.only(
  //                         topLeft: Radius.circular(15.0),
  //                         topRight: Radius.circular(15.0),
  //                         bottomLeft: _messages[index].claimsMsgFrom == '1'
  //                             ? Radius.circular(0.0)
  //                             : Radius.circular(15.0),
  //                         bottomRight: _messages[index].claimsMsgFrom == '1'
  //                             ? Radius.circular(15.0)
  //                             : Radius.circular(0.0),
  //                       ),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.5),
  //                           spreadRadius: 2,
  //                           blurRadius: 5,
  //                           offset: Offset(0, 3),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           _messages[index].claimsMsgText,
  //                           style: TextStyle(
  //                             fontSize: 14.0,
  //                             color: _messages[index].claimsMsgFrom == '1'
  //                                 ? Colors.white
  //                                 : seconde,
  //                           ),
  //                         ),
  //                         SizedBox(height: 5.0),
  //                         Text(
  //                           formattedDate,
  //                           style: TextStyle(
  //                             fontSize: 8.0,
  //                             color: _messages[index].claimsMsgFrom == '1'
  //                                 ? seconde
  //                                 : Color.fromARGB(255, 120, 120, 120),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   _messages[index].claimsMsgFrom != '1'
  //                       ? Padding(
  //                           padding: const EdgeInsets.only(
  //                             top: 35,
  //                             right:
  //                                 8.0, // Adjust the right padding for proper spacing
  //                           ),
  //                           child: Icon(
  //                             Icons.support_agent_rounded,
  //                             size: 30.0,
  //                             color: Colors.green[600],
  //                           ),
  //                         )
  //                       : Container(),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20.0),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey.withOpacity(0.5),
  //                   spreadRadius: 2,
  //                   blurRadius: 5,
  //                   offset: Offset(0, 3),
  //                 ),
  //               ],
  //             ),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: TextField(
  //                       controller: _messageController,
  //                       decoration: InputDecoration(
  //                         border: InputBorder.none,
  //                         hintText: 'Type a message...',
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 IconButton(
  //                   icon: Icon(Icons.send),
  //                   onPressed: _sendMessage,
  //                   color: primary,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }