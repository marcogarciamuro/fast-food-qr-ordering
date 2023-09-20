import 'dart:convert';
import "package:fast_food_qr_ordering/burger.dart";
import 'package:fast_food_qr_ordering/drink.dart';
import "package:fast_food_qr_ordering/fries.dart";
import "package:fast_food_qr_ordering/item.dart";

class Meal extends Item {
  final Burger burger;
  final Drink drink;
  final Fries fries;

  Meal(this.burger, this.fries, this.drink) : super(0, '', 0.0, '', '') {
    switch (burger.id) {
      // CHANGE IDS OF BURGERS AND FINISH SWITCH STATEMENT HERE
      case 1:
        super.id = 1;
        super.name = "Double Double Meal";
        super.price = 9.00;
        super.image = "pictures/double-double-meal.png";
        break;
      case 2:
        super.id = 2;
        super.name = "Cheeseburger Meal";
        super.price = 7.55;
        super.image = "pictures/cheeseburger-meal.png";
        break;
      case 3:
        super.id = 3;
        super.name = "Hamburger Meal";
        super.price = 7.20;
        super.image = "pictures/hamburger-meal.png";
        break;
    }

    final optionsMap = {
      'drinkOptions': drink.options,
      'fryOptions': fries.options,
      'burgerOptions': burger.options,
    };
    options = json.encode(optionsMap);
    print("OPTIONS FOR MEAL: $options");
  }
}
