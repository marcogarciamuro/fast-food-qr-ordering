import 'package:flutter/material.dart';

class DrinkProvider with ChangeNotifier {
  final int _defaultDrinkSelectionIndex = -1;
  final int _defaultIcePreferenceIndex = 1;
  final int _defaultSizeIndex = 1;
  final int _defaultQuantity = 1;

  int _savedDrinkSelectionIndex = -1;
  int _savedIcePreferenceIndex = 1;
  int _savedSizeIndex = 1;
  int _savedQuantity = 1;

  int _currentDrinkSelectionIndex = -1;
  int _currentIcePreferenceIndex = 1;
  int _currentSizeIndex = 1;
  int _currentQuantity = 1;

  int get currentDrinkSelectionIndex => _currentDrinkSelectionIndex;
  int get currentIcePreferenceIndex => _currentIcePreferenceIndex;
  int get currentSizeIndex => _currentSizeIndex;
  int get currentQuantity => _currentQuantity;

  String get currentSize {
    switch (_currentSizeIndex) {
      case 0:
        return "Small";
      case 2:
        return "Large";
      default:
        return "Medium";
    }
  }

  set currentQuantity(int value) {
    _currentQuantity = value;
    notifyListeners();
  }

  set currentDrinkSelection(int value) {
    _currentDrinkSelectionIndex = value;
    notifyListeners();
  }

  set currentSizeIndex(int value) {
    _currentSizeIndex = value;
    notifyListeners();
  }

  set currentIcePreferenceIndex(int value) {
    _currentIcePreferenceIndex = value;
    notifyListeners();
  }

  void clearSelectionHistory() {
    _currentDrinkSelectionIndex = _defaultDrinkSelectionIndex;
    _currentSizeIndex = _defaultSizeIndex;
    _currentIcePreferenceIndex = _defaultIcePreferenceIndex;
    _currentQuantity = _defaultQuantity;

    _savedDrinkSelectionIndex = _defaultDrinkSelectionIndex;
    _savedSizeIndex = _defaultSizeIndex;
    _savedIcePreferenceIndex = _defaultIcePreferenceIndex;
    _savedQuantity = _defaultQuantity;
    notifyListeners();
    print("CLEARING SELECTION history");
  }

  void discardCurrentSelectedOptions() {
    _currentDrinkSelectionIndex = _savedDrinkSelectionIndex;
    notifyListeners();
  }

  void updateSavedIndices() {
    _savedDrinkSelectionIndex = _currentDrinkSelectionIndex;
  }

  bool drinkIsSelected() {
    return _currentDrinkSelectionIndex != -1;
  }

  bool newDrinkWasSelected() {
    return _currentDrinkSelectionIndex != _savedDrinkSelectionIndex;
  }

  void setPreferenceIndices(Map drinkDetails) {
    switch (drinkDetails['icePreference']) {
      case "No Ice":
        _currentIcePreferenceIndex = 0;
        break;
      case "Extra Ice":
        _currentIcePreferenceIndex = 2;
        break;
      default:
        _currentIcePreferenceIndex = 1;
    }

    switch (drinkDetails['size']) {
      case "Small":
        _currentSizeIndex = 0;
        break;
      case "Large":
        _currentSizeIndex = 2;
        break;
      default:
        _currentSizeIndex = 1;
    }

    switch (drinkDetails['drinkSelection']) {
      case "Coke":
        _currentDrinkSelectionIndex = 0;
        break;
      case "Diet Coke":
        _currentDrinkSelectionIndex = 1;
        break;
      case "7-Up":
        _currentDrinkSelectionIndex = 2;
        break;
      case "Dr Pepper":
        _currentDrinkSelectionIndex = 3;
        break;
      case "Root Beer":
        _currentDrinkSelectionIndex = 4;
        break;
      case "Pink Lemonade":
        _currentDrinkSelectionIndex = 5;
        break;
      case "Light Lemonade":
        _currentDrinkSelectionIndex = 6;
        break;
      case "Iced Tea":
        _currentDrinkSelectionIndex = 7;
        break;
      case "Sweet Tea":
        _currentDrinkSelectionIndex = 8;
        break;
      case "Coffee":
        _currentDrinkSelectionIndex = 9;
        break;
      case "Hot Cocoa":
        _currentDrinkSelectionIndex = 10;
        break;
      case "Milk":
        _currentDrinkSelectionIndex = 11;
        break;
      default:
        _currentDrinkSelectionIndex = 0;
        break;
    }
    notifyListeners();
  }

  String getDrinkCustomizationText() {
    List customizations = [];
    switch (_currentIcePreferenceIndex) {
      case 0:
        customizations.add("No Ice");
        break;
      case 2:
        customizations.add("Extra Ice");
        break;
    }
    return customizations.join(', ');
  }

  bool customIcePreferenceSelected() {
    return _currentIcePreferenceIndex != _defaultIcePreferenceIndex;
  }

  bool drinkIsCustomized() {
    bool iceIsCustomized =
        _currentIcePreferenceIndex != _defaultIcePreferenceIndex;
    bool quantityIsCustomized = _currentQuantity != _defaultQuantity;
    bool sizeIsCustomized = _currentSizeIndex != _defaultSizeIndex;
    return iceIsCustomized || quantityIsCustomized || sizeIsCustomized;
  }

  bool changesWereMade() {
    return _currentDrinkSelectionIndex != _defaultDrinkSelectionIndex ||
        _currentIcePreferenceIndex != _defaultIcePreferenceIndex ||
        _currentSizeIndex != _defaultSizeIndex;
  }
}
