import 'dart:convert';

bool itemIsMeal(int itemID) => itemID == 1 || itemID == 2 || itemID == 3;
bool itemIsSingleBurger(int itemID) =>
    itemID == 4 || itemID == 5 || itemID == 6;
bool itemIsFry(int itemID) => itemID == 7;
bool itemIsDrink(int itemID) => itemID == 8;
bool itemIsShake(int itemID) => itemID == 9;

String createFrySpeialOptionsText(Map fryOptions) {
  String fryStyle = fryOptions['fryStyle'];
  List frySpecialOptions = [];
  switch (fryStyle) {
    case 'Animal':
      frySpecialOptions.add('Animal Fries');
      break;
    case 'Cheese':
      frySpecialOptions.add('Cheese Fries');
      break;
    default:
      frySpecialOptions.add('French Fries');
  }

  String fryWellness = fryOptions['wellness'];
  switch (fryWellness) {
    case 'Light':
      frySpecialOptions.add('Light');
      break;
    case 'Well Done':
      frySpecialOptions.add('Well Done');
      break;
    case 'Extra Well Done':
      frySpecialOptions.add('Extra Well Done');
      break;
  }

  String saltPreference = fryOptions['saltPreference'];
  switch (saltPreference) {
    case 'No Salt':
      frySpecialOptions.add("No Salt");
      break;
    case 'Extra Salt':
      frySpecialOptions.add("Extra Salt");
      break;
  }
  return frySpecialOptions.join(', ');
}

String getFormattedSpecialOptions(int itemID, String options) {
  List specialOptions = [];
  if (itemIsMeal(itemID)) {
    final optionsByItemMap = jsonDecode(options);
    final burgerOptions = jsonDecode(optionsByItemMap['burgerOptions']);
    final drinkOptions = jsonDecode(optionsByItemMap['drinkOptions']);
    final fryOptions = jsonDecode(optionsByItemMap['fryOptions']);

    // add drink to cart item subtitle
    String drinkSelection = drinkOptions['drinkSelection'];
    String drinkSize = drinkOptions['size'];
    String icePreference = drinkOptions['icePreference'];

    specialOptions.add("$drinkSize $drinkSelection");
    if (icePreference != "Regular Ice") {
      specialOptions.add(icePreference);
    }
    specialOptions.add(createFrySpeialOptionsText(fryOptions));

    // get burger options for meal
    burgerOptions.forEach((option, optionSelection) {
      if (optionSelection != "Default" && option != "cheeseCount") {
        specialOptions.add(optionSelection);
      }
    });
  } else if (itemIsSingleBurger(itemID)) {
    final optionsMap = jsonDecode(options);
    optionsMap.forEach((option, optionSelection) {
      if (optionSelection != "Default" && option != "cheeseCount") {
        specialOptions.add(optionSelection);
      }
    });
  }
  // get fry options
  else if (itemIsFry(itemID)) {
    final fryOptions = jsonDecode(options);
    specialOptions.add(createFrySpeialOptionsText(fryOptions));
  }
  // get drink options
  else if (itemIsDrink(itemID)) {
    final drinkOptions = jsonDecode(options);
    final icePreference = drinkOptions['icePreference'];
    final size = drinkOptions['size'];
    specialOptions.add(size);
    if (icePreference != "Regular Ice") {
      specialOptions.add(icePreference);
    }
  }
  // get shake options
  else if (itemIsShake(itemID)) {
    final shakeOptions = jsonDecode(options);
    shakeOptions['flavors'].forEach((flavor) => specialOptions.add(flavor));
  }

  return specialOptions.join(', ');
}
