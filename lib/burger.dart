import 'package:fast_food_qr_ordering/item.dart';
import 'dart:convert';

Map getBurgerInfo(itemID) {
  final String imagePath;
  final String itemDescription;
  final String itemName;
  final String burgerImagePath;
  final String burgerName;
  final int calories;
  switch (itemID) {
    case 1:
      imagePath = "pictures/double-double-meal.png";
      itemName = "Double Double Meal";
      calories = 670;
      burgerName = "Double Double";
      burgerImagePath = "pictures/double-double.png";
      itemDescription =
          "Toasted Buns, 2 Slices American Cheese, 2 Beef Patties, Onion, Lettuce, Spread, Tomato";
      break;
    case 2:
      imagePath = "pictures/cheeseburger-meal.png";
      burgerName = "Cheeseburger";
      calories = 480;
      burgerImagePath = "pictures/cheeseburger.png";
      itemName = "Cheeseburger Meal";
      itemDescription =
          "Toasted Buns, American Cheese Slice, Beef Patty, Onion, Lettuce, Spread, Tomato";
      break;
    case 3:
      imagePath = "pictures/hamburger-meal.png";
      burgerName = "Hamburger";
      burgerImagePath = "pictures/hamburger.png";
      calories = 390;
      itemName = "Hamburger Meal";
      itemDescription =
          "Toasted Buns, Beef Patty, Onion, Lettuce, Spread, Tomato";
      break;
    case 4:
      imagePath = "pictures/double-double.png";
      calories = 390;
      burgerName = "Double Double";
      burgerImagePath = "pictures/double-double.png";
      itemName = "Double Double";
      itemDescription =
          "Fresh, hand-cut potatoes prepared in 100% sunflower oil";
      break;
    case 5:
      burgerImagePath = "pictures/cheeseburger.png";
      calories = 390;
      imagePath = "pictures/cheeseburger.png";
      itemName = "Cheeseburger";
      burgerName = "Cheeseburger";
      itemDescription =
          "Fresh, hand-cut potatoes prepared in 100% sunflower oil";
      break;
    case 6:
      burgerImagePath = "pictures/hamburger.png";
      burgerName = "Hamburger";
      calories = 390;
      imagePath = "pictures/hamburger.png";
      itemName = "Hamburger";
      itemDescription =
          "Fresh, hand-cut potatoes prepared in 100% sunflower oil";
      break;
    default:
      burgerName = "";
      calories = 0;
      burgerImagePath = "";
      itemDescription = "";
      itemName = "";
      imagePath = "";
  }
  return {
    "burgerName": burgerName,
    "calories": calories,
    "burgerImagePath": burgerImagePath,
    "itemDescription": itemDescription,
    "itemName": itemName
  };
}

class Burger extends Item {
  late String burgerStyle;
  late String bunPreference;
  late int cheeseCount;
  late String lettucePreference;
  late String tomatoPreference;
  late String onionPreference;
  late String saucePreference;
  int burgerStyleIndex;
  int bunPreferenceIndex;
  int cheeseCountIndex;
  int lettucePreferenceIndex;
  int tomatoPreferenceIndex;
  int onionPreferenceIndex;
  int saucePreferenceIndex;

  Burger(id,
      {this.burgerStyleIndex = 1,
      this.bunPreferenceIndex = 1,
      this.cheeseCountIndex = 1,
      this.lettucePreferenceIndex = 2,
      this.tomatoPreferenceIndex = 1,
      this.onionPreferenceIndex = 2,
      this.saucePreferenceIndex = 2})
      : super(id, '', 0.0, '', '') {
    switch (id) {
      case 2:
        super.name = "Cheeseburger Meal";
        cheeseCount = 1;
        image = "pictures/cheeseburger-meal.png";
        price = 6.61;
        break;
      case 3:
        super.name = "Hamburger Meal";
        cheeseCount = 0;
        image = "pictures/hamburger-meal.png";
        price = 6.26;
        break;
      case 4:
        super.name = "Double Double";
        cheeseCount = 2;
        image = "pictures/double-double.png";
        price = 5.00;
        break;
      case 5:
        super.name = "Cheeseburger";
        cheeseCount = 1;
        image = "pictures/cheeseburger.png";
        price = 4.00;
        break;
      case 6:
        super.name = "Hamburger";
        cheeseCount = 0;
        image = "pictures/hamburger.png";
        price = 3.00;
        break;
      default:
        name = "Double Double Meal";
        cheeseCount = 2;
        image = "pictures/double-double-meal.png";
        price = 7.84;
    }
    switch (burgerStyleIndex) {
      case 0:
        burgerStyle = "Animal Style";
        break;
      case 1:
        burgerStyle = "Plain";
        break;
      case 2:
        burgerStyle = "Protein Style";
        break;
      default:
        burgerStyle = "Default";
    }
    switch (bunPreferenceIndex) {
      case 0:
        bunPreference = "Untoasted Buns";
        break;
      case 2:
        bunPreference = "Extra Toasted Buns";
        break;
      default:
        bunPreference = "Default";
    }
    switch (lettucePreferenceIndex) {
      case 0:
        lettucePreference = "No Lettuce";
        break;
      case 2:
        lettucePreference = "Extra Lettuce";
        break;
      default:
        lettucePreference = "Default";
    }
    switch (tomatoPreferenceIndex) {
      case 0:
        tomatoPreference = "No Tomato";
        break;
      case 2:
        tomatoPreference = "Extra Tomato";
        break;
      default:
        tomatoPreference = "Default";
    }
    switch (onionPreferenceIndex) {
      case 0:
        onionPreference = "No Onion";
        break;
      case 2:
        onionPreference = "Grilled Onion";
        break;
      case 3:
        onionPreference = "Extra Onion";
        break;
      default:
        onionPreference = "Default";
    }
    switch (saucePreferenceIndex) {
      case 0:
        saucePreference = "None";
        break;
      case 2:
        saucePreference = "Extra Spread";
        break;
      case 3:
        saucePreference = "Ketchup";
        break;
      case 4:
        saucePreference = "Mustard";
        break;
      case 5:
        saucePreference = "Ketchup & Mustard";
        break;
      default:
        saucePreference = "Default";
    }
    final optionsMap = {
      'burgerStyle': burgerStyle,
      'bunPreference': bunPreference,
      'cheeseCount': cheeseCount,
      'lettucePreference': lettucePreference,
      'tomatoPreference': tomatoPreference,
      'onionPreference': onionPreference,
      'saucePreference': saucePreference
    };
    super.options = json.encode(optionsMap);
  }

  @override
  Map toJson() {
    return {
      'name': name,
      'burgerStyle': burgerStyle,
      'price': price,
      'image': image,
    };
  }
}
