import 'package:flutter/material.dart';

class ExtrasProvider with ChangeNotifier {
  List<bool> showExtras = [true, true, true];

  void hideExtra(int extraID) {
    showExtras[extraID] = false;
    notifyListeners();
  }

  void showExtra(int extraID) {
    showExtras[extraID] = true;
    notifyListeners();
  }

  void resetShowExtras() {
    showExtras = [true, true, true];
    notifyListeners();
  }
}
