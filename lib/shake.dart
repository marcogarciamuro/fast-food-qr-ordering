import 'dart:convert';

import 'package:fast_food_qr_ordering/item.dart';

class Shake extends Item {
  List<int> selectedFlavorsIndices;
  late String selectedFlavorsFormatted;
  late String size;
  int sizeIndex;
  static const itemID = 9;
  static const itemName = "Shake";
  static const itemPrice = 5.99;
  static const itemOptions = "";
  static const itemImagePath = "pictures/shakes.png";

  Shake(this.selectedFlavorsIndices, this.sizeIndex)
      : super(itemID, itemName, itemPrice, itemImagePath, itemOptions) {
    List<String> selectedFlavors = [];
    if (selectedFlavorsIndices.contains(0)) {
      selectedFlavors.add("Vanilla");
    }
    if (selectedFlavorsIndices.contains(1)) {
      selectedFlavors.add("Strawberry");
    }
    if (selectedFlavorsIndices.contains(2)) {
      selectedFlavors.add("Chocolate");
    }
    selectedFlavorsFormatted = selectedFlavors.join(", ");
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
    final optionsMap = {"flavors": selectedFlavors, "size": size};
    super.name = "$size Shake";
    super.options = json.encode(optionsMap);
  }
}
