import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Validations extends StatefulWidget {
  const Validations({super.key});

  @override
  State<Validations> createState() => _ValidationsState();
}

bool validateEmail(String email) {
  // Regular expression pattern for a flexible email format under colinoexpress.ma
  RegExp regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return regex.hasMatch(email);
}

bool validatePhoneNumber(String phoneNumber) {
  String pattern = r'^(05|06|07)[0-9]{8}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(phoneNumber);
}

class _ValidationsState extends State<Validations> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
