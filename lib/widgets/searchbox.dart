// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/resultfilterSearch.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../Services/Barcode_scan.dart';
// import 'resultfilterSearch.dart';

final TextEditingController _FilteredValueController = TextEditingController();
var id;
// barcodescan scan = Get.put(barcodescan());

Future<String?> _getPrefs() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  id = pref.getString('user_id').toString();
  if (id != null) {
    id = pref.getString('user_id').toString();
    return id;
  }
}

Future<void> showScanModal(BuildContext context) async {
  TextEditingController _FilteredValueController = TextEditingController();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // ignore: prefer_const_constructors
                        Text(
                          'Chercher Les Colis ',
                          textAlign: TextAlign.center,
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            // IconButton(
                            //   onPressed: () {
                            //     // scan.scan();
                            //   },
                            //   icon: Icon(
                            //     Icons.qr_code_scanner,
                            //     size: 30,
                            //   ),
                            // ),
                            Expanded(
                              child: TextField(
                                controller: _FilteredValueController,
                                decoration: InputDecoration(
                                  labelText:
                                      "Recherche Par : Telephone , code  ...",
                                  hintText: "Cherecher ici",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0, bottom: 15),
                    child: ElevatedButton(
                      onPressed: () {
                        String _FilteredValue = _FilteredValueController.text;

                        Get.to(() => resultfiltersearch(),
                            arguments: _FilteredValue);
                      },
                      child: Text('Chercher'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
