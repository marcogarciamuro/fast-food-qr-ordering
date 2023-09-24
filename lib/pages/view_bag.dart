import 'dart:convert';
import 'package:fast_food_qr_ordering/bag_functions.dart';
import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/fries_provider.dart';
import 'package:fast_food_qr_ordering/meal_provider.dart';
import 'package:fast_food_qr_ordering/pages/customize_drink.dart';
import 'package:fast_food_qr_ordering/pages/extras_card.dart';
import 'package:fast_food_qr_ordering/pages/customer_order_summary.dart';
import 'package:fast_food_qr_ordering/pages/view_shake.dart';
import 'package:fast_food_qr_ordering/pages/view_burger.dart';
import 'package:fast_food_qr_ordering/pages/view_fries.dart';
import 'package:fast_food_qr_ordering/pages/view_meal.dart';
import 'package:fast_food_qr_ordering/shake_provider.dart';
import 'package:fast_food_qr_ordering/burger_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';
import 'package:fast_food_qr_ordering/extras_provider.dart';

class ViewBag extends StatefulWidget {
  const ViewBag({Key? key}) : super(key: key);

  @override
  State<ViewBag> createState() => _ViewBagState();
}

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback reduceQuantity;
  final VoidCallback addQuantity;
  final VoidCallback deleteItem;
  final String text;

  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.reduceQuantity,
      required this.deleteItem,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey.shade200, width: 1)),
        child: Row(
          children: [
            IconButton(
                onPressed: text == "1" ? deleteItem : reduceQuantity,
                icon: text == "1"
                    ? const Icon(Icons.delete)
                    : const Icon(Icons.remove)),
            Text(text),
            IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
          ],
        ));
  }
}

class _ViewBagState extends State<ViewBag> {
  DBHelper? dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    context.read<BagProvider>().getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bag = Provider.of<BagProvider>(context);
    final burgerProvider = Provider.of<BurgerProvider>(context);
    final shakeProvider = Provider.of<ShakeProvider>(context);
    final drinkProvider = Provider.of<DrinkProvider>(context);
    final fryProvider = Provider.of<FryProvider>(context);
    final mealProvider = Provider.of<MealProvider>(context);
    final extrasProvider = Provider.of<ExtrasProvider>(context);

    void redirectToRespectiveScreen(int itemID, Bag bagItemToEdit) {
      if (itemIsMeal(itemID)) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewMeal(
                        itemID: itemID,
                        editing: true,
                        mealToEdit: bagItemToEdit)))
            .then((value) => context.read<BagProvider>().getData());
      } else if (itemIsSingleBurger(itemID)) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewBurger(
                        itemID: itemID,
                        editing: true,
                        burgerToEdit: bagItemToEdit)))
            .then((value) => context.read<BagProvider>().getData());
      } else if (itemIsFry(itemID)) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewFries(editing: true, fryToEdit: bagItemToEdit)))
            .then((value) => context.read<BagProvider>().getData());
      } else if (itemIsDrink(itemID)) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomizeDrink(
                        drinkIsForMeal: false,
                        editing: true,
                        drinkToEdit: bagItemToEdit)))
            .then((value) => context.read<BagProvider>().getData());
      } else if (itemIsShake(itemID)) {
        Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ViewShake(editing: true, shakeToEdit: bagItemToEdit)))
            .then((value) => context.read<BagProvider>().getData());
      }
    }

    void setItemCustomizationIndices(
        int itemID, String options, int itemQuantity) {
      if (itemIsMeal(itemID)) {
        final Map optionsByItem = jsonDecode(options);
        final burgerOptions = jsonDecode(optionsByItem['burgerOptions']);
        final fryOptions = jsonDecode(optionsByItem['fryOptions']);
        final drinkOptions = jsonDecode(optionsByItem['drinkOptions']);
        burgerProvider.setPreferenceIndices(burgerOptions);
        fryProvider.setPreferenceIndices(fryOptions);
        drinkProvider.setPreferenceIndices(drinkOptions);
        mealProvider.currentQuantity = itemQuantity;
        mealProvider.savedQuantity = itemQuantity;
      }

      // set single burger options
      else if (itemIsSingleBurger(itemID)) {
        final Map burgerOptions = jsonDecode(options);
        print("burger options $burgerOptions");
        burgerProvider.currentQuantity = itemQuantity;
        burgerProvider.setPreferenceIndices(burgerOptions);
      }

      // set fry options
      else if (itemIsFry(itemID)) {
        final Map fryOptions = jsonDecode(options);
        fryProvider.currentQuantity = itemQuantity;
        fryProvider.setPreferenceIndices(fryOptions);
      }

      // set drink options
      else if (itemIsDrink(itemID)) {
        final Map drinkOptions = jsonDecode(options);
        drinkProvider.setPreferenceIndices(drinkOptions);
        drinkProvider.currentQuantity = itemQuantity;
      }

      // set shake options
      else if (itemIsShake(itemID)) {
        final Map shakeOptions = jsonDecode(options);
        shakeProvider.setPreferenceIndices(shakeOptions);
        shakeProvider.currentQuantity = itemQuantity;
        shakeProvider.savedQuantity = itemQuantity;
        shakeProvider.updatingExistingShake = true;
      }
    }

    return WillPopScope(
      onWillPop: () {
        burgerProvider.clearSelectionHistory();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Bag", style: TextStyle(color: Colors.black)),
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<BagProvider>(
                builder: (BuildContext context, provider, widget) {
                  if (provider.bag.isEmpty) {
                    return const Center(
                      child: Text(
                        "Your bag is empty",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                    );
                  } else {
                    return ListView(
                      children: <Widget>[
                        ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: provider.bag.length,
                          itemBuilder: (context, index) {
                            final itemID = provider.bag[index].itemID!;
                            final itemQuantity =
                                provider.bag[index].quantity!.value;
                            final optionsJSON = provider.bag[index].options!;
                            final specialOptions =
                                getFormattedSpecialOptions(itemID, optionsJSON);
                            return GestureDetector(
                              onTap: () {
                                setItemCustomizationIndices(
                                    itemID, optionsJSON, itemQuantity);
                                redirectToRespectiveScreen(
                                    itemID, provider.bag[index]);
                              },
                              child: Card(
                                elevation: 0.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image(
                                        height: 90,
                                        width: 90,
                                        image: AssetImage(
                                            provider.bag[index].image!),
                                      ),
                                      SizedBox(
                                        width: 130,
                                        // height: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${provider.bag[index].itemName!}\n',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            specialOptions != ''
                                                ? Text(specialOptions,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .grey.shade600))
                                                : Container(),
                                            Consumer<BagProvider>(builder:
                                                (BuildContext context, value,
                                                    Widget? child) {
                                              final ValueNotifier<double?>
                                                  price = ValueNotifier(null);
                                              price.value =
                                                  value.bag[index].price! *
                                                      value.bag[index].quantity!
                                                          .value;
                                              return Text(
                                                '\$${price.value?.toStringAsFixed(2)}\n',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            })
                                          ],
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable:
                                            provider.bag[index].quantity!,
                                        builder: (context, val, child) {
                                          return PlusMinusButtons(
                                            addQuantity: () {
                                              bag.addQuantity(provider
                                                  .bag[index].uniqueID!);
                                              dbHelper!
                                                  .updateCustomerBagItem(
                                                Bag(
                                                  uniqueID: provider
                                                      .bag[index].uniqueID,
                                                  itemID: provider
                                                      .bag[index].itemID,
                                                  itemName: provider
                                                      .bag[index].itemName,
                                                  price:
                                                      provider.bag[index].price,
                                                  image:
                                                      provider.bag[index].image,
                                                  options: provider
                                                      .bag[index].options,
                                                  quantity: ValueNotifier(
                                                      provider.bag[index]
                                                          .quantity!.value),
                                                ),
                                              )
                                                  .then((value) {
                                                setState(() {
                                                  bag.addToTotalPrice(
                                                      double.parse(provider
                                                          .bag[index].price
                                                          .toString()));
                                                });
                                              });
                                            },
                                            reduceQuantity: () {
                                              bag.deductQuantity(provider
                                                  .bag[index].uniqueID!);
                                              bag.deductFromTotalPrice(
                                                  double.parse(provider
                                                      .bag[index].price
                                                      .toString()));
                                            },
                                            deleteItem: () {
                                              bool itemIsExtra = itemID == 10 ||
                                                  itemID == 11 ||
                                                  itemID == 12;
                                              if (itemIsExtra) {
                                                int extraIndex;
                                                switch (itemID) {
                                                  case 10:
                                                    extraIndex = 0;
                                                    break;
                                                  case 11:
                                                    extraIndex = 1;
                                                    break;
                                                  default:
                                                    extraIndex = 2;
                                                }
                                                extrasProvider
                                                    .showExtra(extraIndex);
                                              }
                                              dbHelper!.deleteCustomerBagItem(
                                                  provider
                                                      .bag[index].uniqueID!);
                                              provider.removeItem(provider
                                                  .bag[index].uniqueID!);
                                              provider.decrementCounter();
                                            },
                                            text: val.toString(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Menu())),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child: SizedBox(
                                width: 125,
                                child: Row(
                                  children: const [
                                    Icon(Icons.add),
                                    Text("Add More Items"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const ExtrasCard()
                      ],
                    );
                  }
                },
              ),
            ),
            Consumer<BagProvider>(builder: (context, provider, widget) {
              return const CustomerOrderSummary();
            })
          ],
        ),
      ),
    );
  }
}
