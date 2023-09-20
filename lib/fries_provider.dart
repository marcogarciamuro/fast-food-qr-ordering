import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FryProvider with ChangeNotifier {
  final int _defaultSaltIndex = 2;
  final int _defaultWellnessIndex = 1;
  final int _defaultStyleIndex = -1;
  final int _defaultQuantity = 1;

  int _savedSaltIndex = 2;
  int _savedWellnessIndex = 1;
  int _savedStyleIndex = -1;
  int _savedQuantity = 1;

  int _currentSaltIndex = 2;
  int _currentWellnessIndex = 1;
  int _currentStyleIndex = -1;
  int _currentQuantity = 1;

  int get currentSaltIndex => _currentSaltIndex;
  int get currentQuantity => _currentQuantity;
  int get currentWellnessIndex => _currentWellnessIndex;
  int get currentStyleIndex => _currentStyleIndex;
  int get defaultSaltIndex => _defaultSaltIndex;
  int get defaultWellnessIndex => _defaultWellnessIndex;
  int get defaultStyleIndex => _defaultStyleIndex;

  void clearSelectionHistory() {
    _currentWellnessIndex = _defaultWellnessIndex;
    _currentSaltIndex = _defaultSaltIndex;
    _currentStyleIndex = _defaultStyleIndex;
    _currentQuantity = _defaultQuantity;
    print("CLEARING FRY CUSTOMIZATION");
  }

  bool fryIsCustomized() {
    return _currentWellnessIndex != defaultWellnessIndex ||
        _currentSaltIndex != _defaultSaltIndex ||
        _currentStyleIndex != _defaultStyleIndex ||
        _currentQuantity != _defaultQuantity;
  }

  void discardCurrentSelectedOptions() {
    _currentSaltIndex = _savedSaltIndex;
    _currentWellnessIndex = _savedWellnessIndex;
    _currentStyleIndex = _savedStyleIndex;
    _currentQuantity = _savedQuantity;
    notifyListeners();
  }

  void updateSavedIndices() {
    _savedSaltIndex = _currentSaltIndex;
    _savedWellnessIndex = _currentWellnessIndex;
    _savedStyleIndex = _currentStyleIndex;
    _savedQuantity = _currentQuantity;
  }

  int getCurrentIndex(String name) {
    if (name == "Wellness") {
      return _currentWellnessIndex;
    } else if (name == "Salt") {
      return _currentSaltIndex;
    } else {
      return _currentStyleIndex;
    }
  }

  set currentQuantity(int value) {
    _currentQuantity = value;
  }

  void setCurrentIndex(String name, int value) {
    if (name == "Wellness") {
      _currentWellnessIndex = value;
    } else if (name == "Salt") {
      _currentSaltIndex = value;
    } else {
      _currentStyleIndex = value;
    }
    notifyListeners();
  }

  int getDefaultIndex(String name) {
    if (name == "Wellness") {
      return _defaultWellnessIndex;
    } else if (name == "Salt") {
      return _defaultSaltIndex;
    } else {
      return _defaultStyleIndex;
    }
  }

  bool changesWereMade() {
    return _currentStyleIndex != _savedStyleIndex ||
        _currentSaltIndex != _savedSaltIndex ||
        _currentWellnessIndex != _savedWellnessIndex;
  }

  String getFormattedCustomizations() {
    List<String> customizations = [];
    switch (_currentStyleIndex) {
      case 0:
        customizations.add("Animal Style");
        break;
      case 1:
        customizations.add("Cheese Fries");
        break;
    }
    switch (_currentSaltIndex) {
      case 0:
        customizations.add("No Salt");
        break;
      case 1:
        customizations.add("Light Salt");
        break;
      case 3:
        customizations.add("Extra Salt");
        break;
    }
    switch (_currentWellnessIndex) {
      case 0:
        customizations.add("Light");
        break;
      case 2:
        customizations.add("Well Done");
        break;
      case 3:
        customizations.add("Extra Well Done");
        break;
    }
    return customizations.join(', ');
  }

  void setPreferenceIndices(Map fryDetails) {
    print("HEREEE");
    switch (fryDetails['fryStyle']) {
      case 'Default':
        _currentStyleIndex = -1;
        break;
      case 'Animal':
        _currentStyleIndex = 0;
        break;
      case 'Cheese':
        _currentStyleIndex = 1;
        break;
    }
    switch (fryDetails['saltPreference']) {
      case 'No Salt':
        _currentSaltIndex = 0;
        break;
      case 'Extra Salt':
        _currentSaltIndex = 3;
        break;
      case 'Light Salt':
        _currentSaltIndex = 1;
        break;
      default:
        _currentSaltIndex = -1;
    }
    switch (fryDetails['wellness']) {
      case 'Light':
        _currentWellnessIndex = 0;
        break;
      case 'Well Done':
        _currentWellnessIndex = 2;
        break;
      case 'Extra Well Done':
        _currentWellnessIndex = 3;
        break;
      default:
        _currentWellnessIndex = 1;
    }
    notifyListeners();
  }
}
