import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _currentUser = "Customer";

  set currentUser(String user) {
    _currentUser = user;
    notifyListeners();
  }

  String get currentUser => _currentUser;
}
