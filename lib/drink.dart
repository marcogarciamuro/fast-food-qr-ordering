import 'dart:convert';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:flutter/foundation.dart';

class Drink extends Item {
  int selectionIndex;
  int icePreferenceIndex;
  int sizeIndex;
  late String selection;
  late String icePreference;
  late String size;

  Drink(this.selectionIndex, {this.sizeIndex = 1, this.icePreferenceIndex = 1})
      : super(8, '', 1.99, 'pictures/cup3.png', '') {
    // set size string from index
    switch (sizeIndex) {
      case 0:
        size = "Small";
        break;
      case 2:
        size = "Large";
        break;
      default:
        size = "Medium";
    }

    // set icePreference string from index
    switch (icePreferenceIndex) {
      case 0:
        icePreference = "No Ice";
        break;
      case 2:
        icePreference = "Extra Ice";
        break;
      default:
        icePreference = "Regular Ice";
    }

    // set soda selection string from index
    switch (selectionIndex) {
      case 0:
        selection = "Coke";
        break;
      case 1:
        selection = "Diet Coke";
        break;
      case 2:
        selection = "7-Up";
        break;
      case 3:
        selection = "Dr Pepper";
        break;
      case 4:
        selection = "Root Beer";
        break;
      case 5:
        selection = "Pink Lemonade";
        break;
      case 6:
        selection = "Light Lemonade";
        break;
      case 7:
        selection = "Iced Tea";
        break;
      case 8:
        selection = "Sweet Tea";
        break;
      case 9:
        selection = "Coffee";
        break;
      case 10:
        selection = "Hot Cocoa";
        break;
      case 11:
        selection = "Milk";
        break;
      default:
        selection = "Coke";
    }
    // switch(icePreference) {
    //   case
    // }
    super.name = selection;
    final optionsMap = {
      'drinkSelection': selection,
      'icePreference': icePreference,
      'size': size
    };
    super.options = json.encode(optionsMap);
  }
}
