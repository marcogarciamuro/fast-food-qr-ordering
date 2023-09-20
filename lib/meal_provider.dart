import 'package:flutter/material.dart';

class MealProvider with ChangeNotifier {
  final int _defaultQuantity = 1;
  int _currentQuantity = 1;
  int _savedQuantity = 1;

  int get currentQuantity => _currentQuantity;

  set currentQuantity(int value) {
    _currentQuantity = value;
    notifyListeners();
  }

  set savedQuantity(int value) {
    _savedQuantity = value;
    notifyListeners();
  }

  void defaultQuantityValues() {
    _currentQuantity = _defaultQuantity;
    _savedQuantity = _defaultQuantity;
  }

  bool quantityWasUpdatedFromSaved() => _currentQuantity != _savedQuantity;
  bool quantityWasUpdatedFromDefault() => _currentQuantity != _defaultQuantity;
}
