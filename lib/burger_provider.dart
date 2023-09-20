import 'package:flutter/material.dart';

class BurgerProvider with ChangeNotifier {
  final int _defaultStyleIndex = -1;
  final int _defaultBunIndex = 1;
  final int _defaultLettuceIndex = 1;
  final int _defaultOnionIndex = 1;
  final int _defaultTomatoIndex = 1;
  final int _defaultSauceIndex = 1;
  final int _defaultQuantity = 1;

  int _savedStyleIndex = -1;
  int _savedBunIndex = 1;
  int _savedLettuceIndex = 1;
  int _savedOnionIndex = 1;
  int _savedTomatoIndex = 1;
  int _savedSauceIndex = 1;
  int _savedQuantity = 1;

  int _currentStyleIndex = -1;
  int _currentBunIndex = 1;
  int _currentLettuceIndex = 1;
  int _currentOnionIndex = 1;
  int _currentTomatoIndex = 1;
  int _currentSauceIndex = 1;
  int _currentQuantity = 1;

  int get currentStyleIndex => _currentStyleIndex;
  int get currentBunIndex => _currentBunIndex;
  int get currentLettuceIndex => _currentLettuceIndex;
  int get currentOnionIndex => _currentOnionIndex;
  int get currentTomatoIndex => _currentTomatoIndex;
  int get currentSauceIndex => _currentSauceIndex;
  int get currentQuantity => _currentQuantity;

  int get defaultStyleIndex => _defaultStyleIndex;
  int get defaultBunIndex => _defaultBunIndex;
  int get defaultLettuceIndex => _defaultLettuceIndex;
  int get defaultOnionIndex => _defaultOnionIndex;
  int get defaultTomatoIndex => _defaultTomatoIndex;
  int get defaultSauceIndex => _defaultSauceIndex;
  int get defaultQuantity => _defaultQuantity;

  set currentQuantity(int value) {
    _currentQuantity = value;
    notifyListeners();
  }

  void clearSelectionHistory() {
    _currentStyleIndex = _defaultStyleIndex;
    _currentBunIndex = _defaultBunIndex;
    _currentLettuceIndex = _defaultLettuceIndex;
    _currentOnionIndex = _defaultOnionIndex;
    _currentTomatoIndex = _defaultTomatoIndex;
    _currentSauceIndex = _defaultSauceIndex;
    _currentQuantity = _defaultQuantity;
    notifyListeners();
  }

  String getFormattedCustomizations() {
    List<String> customizations = [];
    switch (_currentStyleIndex) {
      case 0:
        customizations.add("Animal Style");
        break;
      case 1:
        customizations.add("Plain");
        break;
      case 2:
        customizations.add("Protein Style");
    }

    switch (_currentBunIndex) {
      case 0:
        customizations.add("Untoased Buns");
        break;
      case 2:
        customizations.add("Extra Toasted Buns");
        break;
    }

    switch (_currentLettuceIndex) {
      case 0:
        customizations.add("No Lettuce");
        break;
      case 2:
        customizations.add("Extra Lettuce");
        break;
    }

    switch (_currentOnionIndex) {
      case 0:
        customizations.add("No Onion");
        break;
      case 2:
        customizations.add("Grilled Onion");
        break;
      case 3:
        customizations.add("Extra Onion");
    }

    switch (_currentTomatoIndex) {
      case 0:
        customizations.add("No Tomato");
        break;
      case 2:
        customizations.add("Extra Tomato");
        break;
    }

    switch (_currentSauceIndex) {
      case 0:
        customizations.add("No Sauce");
        break;
      case 2:
        customizations.add("Extra Spread");
        break;
      case 3:
        customizations.add("Ketchup");
        break;
      case 4:
        customizations.add("Mustard");
        break;
      case 5:
        customizations.add("Ketchup & Mustard");
        break;
    }
    return customizations.join(', ');
  }

  bool burgerIsCustomized() {
    return _currentStyleIndex != _defaultStyleIndex ||
        _currentBunIndex != _defaultBunIndex ||
        _currentLettuceIndex != _defaultLettuceIndex ||
        _currentOnionIndex != _defaultOnionIndex ||
        _currentTomatoIndex != _defaultTomatoIndex ||
        _currentSauceIndex != _defaultSauceIndex;
  }

  int getDefaultIndex(String name) {
    switch (name) {
      case 'Style':
        return _defaultStyleIndex;
      case 'Bun':
        return _defaultBunIndex;
      case 'Lettuce':
        return _defaultLettuceIndex;
      case 'Onion':
        return _defaultOnionIndex;
      case 'Tomato':
        return _defaultTomatoIndex;
      default:
        return _defaultSauceIndex;
    }
  }

  int getCurrentIndex(String name) {
    switch (name) {
      case 'Style':
        return _currentStyleIndex;
      case 'Bun':
        return _currentBunIndex;
      case 'Lettuce':
        return _currentLettuceIndex;
      case 'Onion':
        return _currentOnionIndex;
      case 'Tomato':
        return _currentTomatoIndex;
      default:
        return _currentSauceIndex;
    }
  }

  void setCurrentIndex(String name, int index) {
    switch (name) {
      case 'Style':
        _currentStyleIndex = index;
        break;
      case 'Bun':
        _currentBunIndex = index;
        break;
      case 'Lettuce':
        _currentLettuceIndex = index;
        break;
      case 'Onion':
        _currentOnionIndex = index;
        break;
      case 'Tomato':
        _currentTomatoIndex = index;
        break;
      default:
        _currentSauceIndex = index;
        break;
    }
    notifyListeners();
  }

  void discardCurrentSelectedOptions() {
    _currentStyleIndex = _savedStyleIndex;
    _currentBunIndex = _savedBunIndex;
    _currentLettuceIndex = _savedLettuceIndex;
    _currentOnionIndex = _savedOnionIndex;
    _currentTomatoIndex = _savedTomatoIndex;
    _currentSauceIndex = _savedSauceIndex;
    print("DISCARDING");
    notifyListeners();
  }

  void updateSavedIndices() {
    _savedStyleIndex = _currentStyleIndex;
    _savedBunIndex = _currentBunIndex;
    _savedLettuceIndex = _currentLettuceIndex;
    _savedOnionIndex = _currentOnionIndex;
    _savedTomatoIndex = _currentTomatoIndex;
    _savedSauceIndex = _currentSauceIndex;
    _savedQuantity = _currentQuantity;
  }

  bool changesWereMade() {
    return _currentStyleIndex != _savedStyleIndex ||
        _currentBunIndex != _savedBunIndex ||
        _currentLettuceIndex != _savedLettuceIndex ||
        _currentOnionIndex != _savedOnionIndex ||
        _currentTomatoIndex != _savedTomatoIndex ||
        _currentSauceIndex != _savedSauceIndex ||
        _currentQuantity != _savedQuantity;
  }

  void makeBurgerPlain() {
    _currentLettuceIndex = 0;
    _currentOnionIndex = 0;
    _currentTomatoIndex = 0;
    notifyListeners();
  }

  void undoBurgerPlain() {
    _currentLettuceIndex = _savedLettuceIndex;
    _currentOnionIndex = _savedOnionIndex;
    _currentTomatoIndex = _savedTomatoIndex;
    notifyListeners();
  }

  void setPreferenceIndices(Map burgerDetails) {
    // set burger style
    switch (burgerDetails['burgerStyle']) {
      case 'Plain':
        _currentStyleIndex = 2;
        _savedStyleIndex = 2;
        break;
      case 'Animal Style':
        _currentStyleIndex = 1;
        _savedStyleIndex = 1;
        break;
    }

    //set bun preference
    switch (burgerDetails['bunPreference']) {
      case 'Untoasted Buns':
        _currentBunIndex = 0;
        _savedBunIndex = 0;
        break;
      case 'Extra Toasted Buns':
        _currentBunIndex = 2;
        _savedBunIndex = 2;
        break;
    }

    // set tomato preference
    switch (burgerDetails['tomatoPreference']) {
      case 'No Tomato':
        _currentTomatoIndex = 0;
        _savedTomatoIndex = 0;
        break;
      case 'Extra Tomato':
        _currentTomatoIndex = 2;
        _savedTomatoIndex = 2;
    }

    // set lettuce preference
    switch (burgerDetails['lettucePreference']) {
      case 'No Lettuce':
        _currentLettuceIndex = 0;
        _savedLettuceIndex = 0;
        break;
      case 'Extra Lettuce':
        _currentLettuceIndex = 2;
        _savedLettuceIndex = 2;
        break;
    }

    // set onion preference
    switch (burgerDetails['onionPreference']) {
      case 'No Onion':
        _currentOnionIndex = 0;
        _savedOnionIndex = 0;
        break;
      case 'Grilled Onion':
        _currentOnionIndex = 2;
        _savedOnionIndex = 2;
        break;
      case 'Extra Onion':
        _currentOnionIndex = 3;
        _savedOnionIndex = 3;
        break;
    }

    // set sauce preference
    switch (burgerDetails['saucePreference']) {
      case 'None':
        _currentSauceIndex = 0;
        _savedSauceIndex = 0;
        break;
      case 'Extra Spread':
        _currentSauceIndex = 2;
        _savedSauceIndex = 2;
        break;
      case 'Ketchup':
        _currentSauceIndex = 3;
        _savedSauceIndex = 3;
        break;
      case 'Mustard':
        _currentSauceIndex = 4;
        _savedSauceIndex = 4;
        break;
      case 'Ketchup & Mustard':
        _currentSauceIndex = 5;
        _savedSauceIndex = 5;
        break;
    }
    notifyListeners();
  }
}
