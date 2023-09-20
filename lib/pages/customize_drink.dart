import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/drink.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/drinks.dart';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:fast_food_qr_ordering/pages/add_to_bag_button.dart';
import 'package:fast_food_qr_ordering/pages/change_quantity.dart';
import 'package:fast_food_qr_ordering/pages/drink_size_selection.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';
import 'package:fast_food_qr_ordering/pages/selectable_option_tile.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CustomizeDrink extends StatefulWidget {
  const CustomizeDrink(
      {Key? key,
      required this.drinkIsForMeal,
      this.editing = false,
      this.drinkToEdit})
      : super(key: key);

  final bool drinkIsForMeal;
  final bool editing;
  final Bag? drinkToEdit;

  @override
  State<CustomizeDrink> createState() => _CustomizeDrinkState();
}

class _CustomizeDrinkState extends State<CustomizeDrink> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DBHelper dbHelper = DBHelper();
    final drinkProvider = Provider.of<DrinkProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    // used ternary operator to fix bug that threw exception when
    // drinkProvider cleared current indices, setting drinkID to -1
    // causing an illegal index for the top title
    int drinkID = drinkProvider.currentDrinkSelectionIndex != -1
        ? drinkProvider.currentDrinkSelectionIndex
        : 0;

    int drinkQuantity = drinkProvider.currentQuantity;
    final bag = Provider.of<BagProvider>(context);

    void saveDataToWorkerBag(Item item) {
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
          quantity: ValueNotifier(drinkProvider.currentQuantity),
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

    void saveDataToCustomerBag(Item item) {
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
          quantity: ValueNotifier(drinkProvider.currentQuantity),
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
      bool? shouldPop = true;
      print("CLEARING FROM ON WILL POP");
      drinkProvider.clearSelectionHistory();
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${drinkProvider.currentSize} ${drinks[drinkID]['name']}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        const Text("\$1.99  210 cal."),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  widget.drinkIsForMeal == true
                      ? Container()
                      : ChangeQuantity(
                          iconSize: 20,
                          fontSize: 20,
                          quantity: drinkQuantity,
                          onIncrease: () {
                            if (drinkQuantity < 99) {
                              drinkProvider.currentQuantity++;
                            }
                          },
                          onDecrease: () {
                            if (drinkQuantity > 1) {
                              drinkProvider.currentQuantity--;
                            }
                          },
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset("pictures/cup3.png", height: 250),
                        ),
                        const SizedBox(height: 30),
                        SizeSelector(
                          selectedIndex: drinkProvider.currentSizeIndex,
                          onChanged: (val) {
                            drinkProvider.currentSizeIndex = val;
                          },
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Ice Preference",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () {
                                  drinkProvider.currentIcePreferenceIndex = -1;
                                  setState(() {
                                    // specialRequestMade = false;
                                  });
                                },
                                child: const Text("Clear Selection",
                                    style: TextStyle(color: Colors.blue)),
                              )
                              // : Container()
                            ],
                          ),
                        ),
                        Card(
                          elevation: 0.0,
                          margin: EdgeInsets.zero,
                          child: SelectableOptionTile(
                            value: 0,
                            groupValue: drinkProvider.currentIcePreferenceIndex,
                            title: "No Ice",
                            onChanged: (value) {
                              drinkProvider.currentIcePreferenceIndex = 0;
                              setState(() {
                                // specialRequestMade = true;
                              });
                            },
                          ),
                        ),
                        Card(
                          elevation: 0.0,
                          margin: EdgeInsets.zero,
                          child: SelectableOptionTile(
                            value: 1,
                            groupValue: drinkProvider.currentIcePreferenceIndex,
                            title: "Ice",
                            onChanged: (value) {
                              drinkProvider.currentIcePreferenceIndex = 1;
                              setState(() {
                                // specialRequestMade = true;
                              });
                            },
                          ),
                        ),
                        Card(
                          elevation: 0.0,
                          margin: EdgeInsets.zero,
                          child: SelectableOptionTile(
                            value: 2,
                            groupValue: drinkProvider.currentIcePreferenceIndex,
                            title: "Extra Ice",
                            onChanged: (value) {
                              drinkProvider.currentIcePreferenceIndex = 2;
                              setState(() {
                                // specialRequestMade = true;
                              });
                            },
                          ),
                        )
                      ])
                ],
              ),
            ),

            // single drink - not editing
            if (widget.drinkIsForMeal == false && widget.editing == false)
              AddToBagButton(onTap: () {
                Drink drink = Drink(
                  drinkProvider.currentDrinkSelectionIndex,
                  sizeIndex: drinkProvider.currentSizeIndex,
                  icePreferenceIndex: drinkProvider.currentIcePreferenceIndex,
                );
                if (userProvider.currentUser == "Customer") {
                  saveDataToCustomerBag(drink);
                } else if (userProvider.currentUser == "Worker") {
                  saveDataToWorkerBag(drink);
                }
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Menu()));
                drinkProvider.clearSelectionHistory();
              }),

            // drink is for meal
            if (widget.drinkIsForMeal == true)
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context); //save drink preference;
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.grey)),
                      child: const Center(child: Text("Save Changes")))),

            // single drink - editing
            if (widget.drinkIsForMeal == false && widget.editing == true)
              GestureDetector(
                  onTap: () {
                    Drink drink = Drink(
                        drinkProvider.currentDrinkSelectionIndex,
                        sizeIndex: drinkProvider.currentSizeIndex,
                        icePreferenceIndex:
                            drinkProvider.currentIcePreferenceIndex);
                    Bag updatedDrink = Bag(
                        uniqueID: widget.drinkToEdit?.uniqueID,
                        itemID: widget.drinkToEdit?.itemID,
                        itemName: widget.drinkToEdit?.itemName,
                        price: widget.drinkToEdit?.price,
                        image: widget.drinkToEdit?.image,
                        options: drink.options,
                        quantity: ValueNotifier(drinkQuantity));
                    if (userProvider.currentUser == "Customer") {
                      dbHelper.updateCustomerBagItem(updatedDrink);
                    } else {
                      dbHelper.updateWorkerBagItem(updatedDrink);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.grey)),
                      child: const Center(child: Text("Save Changes")))),
          ],
        ),
      ),
    );
  }
}
