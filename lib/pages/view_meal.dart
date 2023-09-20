import 'package:fast_food_qr_ordering/drinks.dart';
import 'package:fast_food_qr_ordering/meal_provider.dart';
import 'package:fast_food_qr_ordering/pages/burger_customization.dart';
import 'package:fast_food_qr_ordering/pages/customize_drink.dart';
import 'package:fast_food_qr_ordering/pages/fries_customization.dart';
import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/pages/drink_selection_for_meal.dart';
import 'package:fast_food_qr_ordering/burger_provider.dart';
import 'package:fast_food_qr_ordering/pages/view_bag.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/drink.dart';
import 'package:fast_food_qr_ordering/burger.dart';
import 'package:fast_food_qr_ordering/fries.dart';
import 'package:fast_food_qr_ordering/meal.dart';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';
import 'package:fast_food_qr_ordering/fries_provider.dart';

class ViewMeal extends StatefulWidget {
  const ViewMeal(
      {Key? key, required this.itemID, this.editing = false, this.mealToEdit})
      : super(key: key);
  final int itemID;
  final Bag? mealToEdit;
  final bool editing;

  @override
  State<ViewMeal> createState() => _ViewMealState();
}

class _ViewMealState extends State<ViewMeal> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final burgerProvider = Provider.of<BurgerProvider>(context);
    final fryProvider = Provider.of<FryProvider>(context);
    final drinkProvider = Provider.of<DrinkProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    int quantity = mealProvider.currentQuantity;
    bool burgerIsCustomized = burgerProvider.burgerIsCustomized();
    bool fryIsCustomized = fryProvider.fryIsCustomized();
    bool drinkIsSelected = drinkProvider.drinkIsSelected();
    int drinkSelectionID = drinkProvider.currentDrinkSelectionIndex;
    DBHelper dbHelper = DBHelper();
    final bag = Provider.of<BagProvider>(context);

    void saveDataToCustomerDB(Item item) {
      var uuid = const Uuid();
      var uniqueID = uuid.v1();
      dbHelper
          .addCustomerBagToDB(
        Bag(
          uniqueID: uniqueID,
          itemID: item.id,
          itemName: item.name,
          price: item.price,
          image: item.image,
          options: item.options,
          quantity: ValueNotifier(quantity),
        ),
      )
          .then((value) {
        bag.addToTotalPrice(item.price);
        bag.addCounter();
        print("Item added to bag");
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    void saveDataToWorkerDB(Item item) {
      var uuid = const Uuid();
      var uniqueID = uuid.v1();
      dbHelper
          .addWorkerBagToDB(
        Bag(
          uniqueID: uniqueID,
          itemID: item.id,
          itemName: item.name,
          price: item.price,
          image: item.image,
          options: item.options,
          quantity: ValueNotifier(quantity),
        ),
      )
          .then((value) {
        bag.addToTotalPrice(item.price);
        bag.addCounter();
        print("Item added to bag");
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    Future<bool> onWillPop() async {
      bool? shouldPop;
      if (burgerProvider.burgerIsCustomized()) {
        print("BURGER IS CUSTOMIZED");
      }
      if (fryProvider.fryIsCustomized()) {
        print("FRY IS CUSTOMIZED");
      }
      if (drinkProvider.drinkIsCustomized()) {
        print("DRINK IS CUSTOMIZED");
      }
      if (fryProvider.fryIsCustomized() == false &&
          drinkProvider.drinkIsCustomized() == false &&
          burgerProvider.burgerIsCustomized() == false) {
        shouldPop = true;
      } else {
        shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(child: Text('Are you sure?')),
              content: const Text(
                  "If you cancel now, all of your customization will be lost"),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              contentPadding: const EdgeInsets.only(left: 20, top: 10),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
      }
      if (shouldPop!) {
        fryProvider.clearSelectionHistory();
        drinkProvider.clearSelectionHistory();
        burgerProvider.clearSelectionHistory();
        mealProvider.defaultQuantityValues();
      }
      return shouldPop;
    }

    final burgerInfo = getBurgerInfo(widget.itemID);

    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black)),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Section with Title, Price, Calories, and Big Image
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          burgerInfo['itemName'],
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Text("\$5.65  820 Cal."),
                        const SizedBox(height: 20),
                        Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: Colors.grey.shade500, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () => setState(() {
                                          if (quantity > 1) {
                                            mealProvider.currentQuantity--;
                                          }
                                        }),
                                    icon: Icon(Icons.remove,
                                        color: quantity == 1
                                            ? Colors.grey
                                            : Colors.black,
                                        size: 15)),
                                Text(quantity.toString(),
                                    style: const TextStyle(fontSize: 15)),
                                IconButton(
                                  onPressed: () => setState(() {
                                    if (quantity < 99) {
                                      mealProvider.currentQuantity++;
                                    }
                                  }),
                                  icon: Icon(
                                    Icons.add,
                                    color: quantity == 99
                                        ? Colors.grey
                                        : Colors.black,
                                    size: 15,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 50,
                    child:
                        Image.asset(burgerInfo['burgerImagePath'], width: 200),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Column with items that compose the meal
            Expanded(
              child: ListView(children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 15,
                        child: Image.asset(burgerInfo['burgerImagePath'],
                            width: double.infinity),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(burgerInfo['burgerName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text("${burgerInfo['calories']} cal."),
                            burgerIsCustomized
                                ? Text(
                                    burgerProvider.getFormattedCustomizations(),
                                    style:
                                        TextStyle(color: Colors.grey.shade600))
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BurgerCustomization(),
                                  ),
                                );
                              },
                              child: const Text("Customize",
                                  style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(thickness: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Row(children: [
                    Flexible(
                      flex: 15,
                      child: Image.asset("pictures/fries.png",
                          width: double.infinity),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      flex: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("French Fries"),
                          const Text("370 cal."),
                          fryIsCustomized
                              ? Text(fryProvider.getFormattedCustomizations(),
                                  style: TextStyle(color: Colors.grey.shade600))
                              : Container(),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomizeFries()));
                            },
                            child: const Text("Customize",
                                style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline)),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                const Divider(thickness: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 15,
                        child: Image.asset("pictures/cup3.png",
                            width: double.infinity),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: drinkIsSelected
                                      ? [
                                          Text(
                                            "${drinkProvider.currentSize} ${drinks[drinkSelectionID]['name']}",
                                            maxLines: 2,
                                          ),
                                          Text(
                                              "${drinks[drinkSelectionID]['calories']} cal."),
                                          drinkProvider
                                                  .customIcePreferenceSelected()
                                              ? Text(
                                                  drinkProvider
                                                      .getDrinkCustomizationText(),
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600))
                                              : Container(),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CustomizeDrink(
                                                            drinkIsForMeal:
                                                                true,
                                                            editing:
                                                                widget.editing,
                                                            drinkToEdit:
                                                                null, // change to NULL
                                                          )));
                                            },
                                            child: const Text(
                                              "Customize",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          ),
                                        ]
                                      : [
                                          const Text("No Drink Selected"),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DrinkSelectionForMeal()),
                                                );
                                                print(
                                                    "CURRENT DRINK SELECTION ID: $drinkSelectionID");
                                                print(drinkSelectionID);
                                              },
                                              child: const Text("Choose Drink",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      decoration: TextDecoration
                                                          .underline)))
                                        ]),
                            ),
                            drinkSelectionID != -1
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DrinkSelectionForMeal()),
                                        );
                                      },
                                      child: const Text("Change",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Text(
                      "2,000 calories a day is used for general nutrition advice, but calorie needs vary. Additional nutrition information available upon request. Calories show do not reflect customization."),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE02A27),
                    ),
                    onPressed: drinkSelectionID == -1
                        ? () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                                  child: Container(
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Select a Drink",
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Close")),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                        : () {
                            int burgerID = widget.itemID;
                            Burger burger = Burger(
                              burgerID,
                              burgerStyleIndex:
                                  burgerProvider.currentStyleIndex,
                              bunPreferenceIndex:
                                  burgerProvider.currentBunIndex,
                              lettucePreferenceIndex:
                                  burgerProvider.currentLettuceIndex,
                              tomatoPreferenceIndex:
                                  burgerProvider.currentTomatoIndex,
                              onionPreferenceIndex:
                                  burgerProvider.currentOnionIndex,
                              saucePreferenceIndex:
                                  burgerProvider.currentSauceIndex,
                            );
                            Drink drink = Drink(
                              drinkSelectionID,
                              sizeIndex: drinkProvider.currentSizeIndex,
                              icePreferenceIndex:
                                  drinkProvider.currentIcePreferenceIndex,
                            );
                            Fries fries = Fries(
                              styleChoiceIndex: fryProvider.currentStyleIndex,
                              wellnessPreferenceIndex:
                                  fryProvider.currentWellnessIndex,
                              saltPreferenceIndex: fryProvider.currentSaltIndex,
                            );
                            Meal meal = Meal(burger, fries, drink);

                            if (widget.editing == false) {
                              if (userProvider.currentUser == "Customer") {
                                saveDataToCustomerDB(meal);
                              } else if (userProvider.currentUser == "Worker") {
                                saveDataToWorkerDB(meal);
                              }
                              fryProvider.clearSelectionHistory();
                              drinkProvider.clearSelectionHistory();
                              burgerProvider.clearSelectionHistory();
                              mealProvider.defaultQuantityValues();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Menu()));
                            } else {
                              Bag updatedBag = Bag(
                                  uniqueID: widget.mealToEdit?.uniqueID,
                                  itemID: widget.mealToEdit?.itemID,
                                  itemName: widget.mealToEdit?.itemName,
                                  price: widget.mealToEdit?.price, // change
                                  image: widget.mealToEdit?.image,
                                  options: meal.options, // change
                                  quantity: ValueNotifier(quantity) // change
                                  );
                              if (userProvider.currentUser == "Customer") {
                                dbHelper.updateCustomerBagItem(updatedBag);
                              } else if (userProvider.currentUser == "Worker") {
                                dbHelper.updateWorkerBagItem(updatedBag);
                              }
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ViewBag()));
                            }
                          },
                    child:
                        Text(widget.editing ? "Save Changes" : "Add To Bag")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
