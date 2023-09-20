import 'package:fast_food_qr_ordering/item.dart';
import 'dart:convert';

class Fries extends Item {
  final int styleChoiceIndex;
  final int wellnessPreferenceIndex;
  final int saltPreferenceIndex;
  late String style;
  late String wellness;
  late String saltPreference;

  Fries(
      {required this.styleChoiceIndex,
      required this.wellnessPreferenceIndex,
      required this.saltPreferenceIndex})
      : super(7, "French Fries", 1.87, 'pictures/fries.png', '') {
    switch (styleChoiceIndex) {
      case 0:
        style = "Animal";
        break;
      case 1:
        style = "Cheese";
        break;
      default:
        style = "Default";
    }
    switch (saltPreferenceIndex) {
      case 0:
        saltPreference = "No Salt";
        break;
      case 1:
        saltPreference = "Light Salt";
        break;
      case 3:
        saltPreference = "Extra Salt";
        break;
      default:
        saltPreference = "Default";
    }
    switch (wellnessPreferenceIndex) {
      case 0:
        wellness = "Light";
        break;
      case 2:
        wellness = "Well Done";
        break;
      case 3:
        wellness = "Extra Well Done";
        break;
      default:
        wellness = "Default";
    }
    final optionsMap = {
      'fryStyle': style,
      'saltPreference': saltPreference,
      'wellness': wellness
    };
    options = json.encode(optionsMap);
  }
}
