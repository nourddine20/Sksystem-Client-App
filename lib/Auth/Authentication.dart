import 'package:flutter/cupertino.dart';

class Authentication extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get authenticated => _isLoggedIn;

  void login(Map creds) {
    _isLoggedIn = true;

    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
