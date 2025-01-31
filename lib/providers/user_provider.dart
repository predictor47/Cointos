import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _name;
  String? _username;
  String? _userId;

  void setUserInfo(String name, String username, String userId) {
    _name = name;
    _username = username;
    _userId = userId;
    notifyListeners();
  }

  String? get name => _name;
  String? get username => _username;
  String? get userId => _userId;
}
