import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShakeProvider with ChangeNotifier {
  final List<int> _defaultSelectedFlavorsIndices = [];
  List<int> _savedSelectedFlavorsIndices = [];
  List<int> _currentSelectedFlavorsIndices = [];

  List<int> get defaultSelectedFlavorsIndices => _defaultSelectedFlavorsIndices;
  List<int> get currentSelectedFlavorsIndices => _currentSelectedFlavorsIndices;
  List<int> get savedSelectedFlavorsIndices => _savedSelectedFlavorsIndices;

  void updateCurrentSelectedFlavorsIndices(int index) {
    if (_currentSelectedFlavorsIndices.contains(index)) {
      _currentSelectedFlavorsIndices.remove(index);
    } else {
      _currentSelectedFlavorsIndices.add(index);
    }
    notifyListeners();
  }

  void discardCurrentSelections() {
    _currentSelectedFlavorsIndices = List.from(_savedSelectedFlavorsIndices); //
    _currentSizeIndex = _savedSizeIndex;
    _currentQuantity = _savedQuantity;
    _updatingExistingShake = false;
    notifyListeners();
  }

  void discardAllSelections() {
    _currentSelectedFlavorsIndices.clear();
    _savedSelectedFlavorsIndices.clear();

    _currentSizeIndex = _defaultSizeIndex;
    _savedSizeIndex = _defaultSizeIndex;

    _currentQuantity = _defaultQuantity;
    _savedQuantity = _defaultQuantity;
    _updatingExistingShake = false;
    notifyListeners();
  }

  void discardCurrentFlavors() {
    _currentSelectedFlavorsIndices = List.from(_savedSelectedFlavorsIndices);
    print(
        "SAVED INDICES AFTER DISCARDING CURRENT: $_savedSelectedFlavorsIndices");
    print("DISCARDING CURRENT FLAVORS");
    notifyListeners();
  }

  void updateSavedIndices() {
    print("SAVING");
    _savedSelectedFlavorsIndices = List.from(_currentSelectedFlavorsIndices);
    // _savedSizeIndex = _currentSizeIndex;
    // _savedQuantity = _currentQuantity;
  }

  int get currentSizeIndex => _currentSizeIndex;
  int get savedSizeIndex => _savedSizeIndex;
  int _currentQuantity = 1;
  int _currentSizeIndex = 1;
  bool _updatingExistingShake = false;

  final int _defaultSizeIndex = 1;
  final int _defaultQuantity = 1;

  int _savedSizeIndex = 1;
  int _savedQuantity = 1;

  set updatingExistingShake(bool value) {
    _updatingExistingShake = value;
    notifyListeners();
  }

  bool get updatingExistingShake => _updatingExistingShake;

  int get defaultSizeIndex => _defaultSizeIndex;

  int get savedQuantity => _savedQuantity;
  int get defaultQuantity => _defaultQuantity;
  int get currentQuantity => _currentQuantity;

  set savedSizeIndex(int newSizeIndex) {
    _savedSizeIndex = newSizeIndex;
    notifyListeners();
  }

  set currentSizeIndex(int newSizeIndex) {
    _currentSizeIndex = newSizeIndex;
    notifyListeners();
  }

  set currentQuantity(int quantity) {
    _currentQuantity = quantity;
    notifyListeners();
  }

  set savedQuantity(int quantity) {
    _savedQuantity = quantity;
    notifyListeners();
  }

  void increaseCurrentQuantity() {
    if (_currentQuantity < 99) {
      _currentQuantity++;
    }
    notifyListeners();
  }

  void decreaseCurrentQuantity() {
    if (_currentQuantity > 1) {
      _currentQuantity--;
    }
    notifyListeners();
  }

  bool shakeIsCustomized() {
    return listEquals(
            _currentSelectedFlavorsIndices, _defaultSelectedFlavorsIndices) ||
        _currentSizeIndex != _defaultSizeIndex;
  }

  bool changesWereMade() {
    if (!listEquals(
        _currentSelectedFlavorsIndices, _savedSelectedFlavorsIndices)) {
      print("Changes were made to flavors");
    }
    if (_currentSizeIndex != _savedSizeIndex) {
      print(
          "Changes were made to size\n Saved size: $_savedSizeIndex, current size: $_currentSizeIndex");
    }
    if (_currentQuantity != _savedQuantity) {
      print(
          "Changes were made to quantity\n Saved quantity: $_savedQuantity, current quantity: $_currentQuantity");
    }
    bool res = !listEquals(
            _currentSelectedFlavorsIndices, _savedSelectedFlavorsIndices) ||
        _currentSizeIndex != _savedSizeIndex ||
        _currentQuantity != _savedQuantity;
    if (res == false) {
      print("NO CHANGES WERE MADE");
    }
    return res;
  }

  String formattedSelectedFlavors() {
    List<String> selectedFlavors = [];
    if (_currentSelectedFlavorsIndices.contains(0)) {
      selectedFlavors.add("Vanilla");
    }
    if (_currentSelectedFlavorsIndices.contains(1)) {
      selectedFlavors.add("Strawberry");
    }
    if (_currentSelectedFlavorsIndices.contains(2)) {
      selectedFlavors.add("Chocolate");
    }
    return selectedFlavors.join(', ');
  }

  bool flavorsAreSelected() {
    return _currentSelectedFlavorsIndices.isNotEmpty;
  }

  void setPreferenceIndices(Map shakeDetails) {
    if (shakeDetails['flavors'].contains('Vanilla')) {
      _currentSelectedFlavorsIndices.add(0);
      _savedSelectedFlavorsIndices.add(0);
    }
    if (shakeDetails['flavors'].contains('Strawberry')) {
      _currentSelectedFlavorsIndices.add(1);
      _savedSelectedFlavorsIndices.add(1);
    }
    if (shakeDetails['flavors'].contains('Chocolate')) {
      _currentSelectedFlavorsIndices.add(2);
      _savedSelectedFlavorsIndices.add(2);
    }
    switch (shakeDetails['size']) {
      case 'Small':
        _currentSizeIndex = 0;
        _savedSizeIndex = 0;
        break;
      case 'Large':
        _currentSizeIndex = 2;
        _savedSizeIndex = 2;
        break;
      default:
        _currentSizeIndex = 1;
        _savedSizeIndex = 1;
    }
  }
}
