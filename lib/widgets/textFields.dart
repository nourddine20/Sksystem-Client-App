import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/theme/constant.dart';

class TProgress extends StatelessWidget {
  String hintText;
  Widget prefix;
  var InputController;

  TProgress({
    required this.hintText,
    required this.prefix,
    required this.InputController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: seconde),
          color: Colors.grey[300]?.withOpacity(.3),
          borderRadius: BorderRadius.circular(15)),
      height: 50,
      child: TextFormField(
        controller: InputController,
        textAlign: TextAlign.left,
        decoration: InputDecoration(
            prefixIcon: prefix,
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 12),
            border: OutlineInputBorder(borderSide: BorderSide.none)),
      ),
    );
  }
}
