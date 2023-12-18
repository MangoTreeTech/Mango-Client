import 'package:flutter/material.dart';
import 'package:mango/apis/api.dart';

enum LoginStatus { login, unlogin, outOfDate }

class Account extends ChangeNotifier {
  LoginStatus loginStatus = LoginStatus.login;
  String username = "";
  String password = "";
  void login(String username, String password) {
    // API.login(username, password);
    loginStatus = LoginStatus.login;
    notifyListeners();
  }

  void register(username, password) {
    // API.register(username, password);
    loginStatus = LoginStatus.login;
    notifyListeners();
  }
}
