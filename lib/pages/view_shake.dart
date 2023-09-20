import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:fast_food_qr_ordering/pages/change_quantity.dart';
import 'package:fast_food_qr_ordering/pages/drink_size_selection.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';
import 'package:fast_food_qr_ordering/pages/view_bag.dart';
import 'package:fast_food_qr_ordering/shake.dart';
import 'package:fast_food_qr_ordering/pages/shake_flavor_selection.dart';
import 'package:fast_food_qr_ordering/shake_provider.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ViewShake extends StatefulWidget {
  const ViewShake({Key? key, this.editing = false, this.shakeToEdit})
      : super(key: key);

  final bool editing;
  final Bag? shakeToEdit;

  @override
  State<ViewShake> createState() => _ViewShakeState();
}

class _ViewShakeState extends State<ViewShake> {
  @override
  Widget build(BuildContext context) {
    DBHelper dbHelper = DBHelper();
    final bag = Provider.of<BagProvider>(context);
    final shakeProvider = Provider.of<ShakeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    int shakeQuantity = shakeProvider.currentQuantity;
    bool updatingExistingShake = shakeProvider.updatingExistingShake;

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
          quantity: ValueNotifier(shakeQuantity),
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
          quantity: ValueNotifier(shakeQuantity),
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
      if (shakeProvider.changesWereMade() == false) {
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
        shakeProvider.discardAllSelections();
      }
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Shake",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("\$5.50  500 cal."),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(child: Image.asset("pictures/shakes.png", width: 250)),
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shakeProvider.flavorsAreSelected()
                          ? const Text("Selected Flavor(s)",
                              style: TextStyle(fontWeight: FontWeight.bold))
                          : Container(),
                      Text(shakeProvider.formattedSelectedFlavors())
                    ],
                  ),
                ),
                SizeSelector(
                    selectedIndex: shakeProvider.currentSizeIndex,
                    onChanged: (val) {
                      shakeProvider.currentSizeIndex = val;
                      shakeProvider.savedSizeIndex = val;
                    }),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 40,
                      child: ChangeQuantity(
                        fontSize: 20,
                        iconSize: 20,
                        quantity: shakeQuantity,
                        onDecrease: () {
                          shakeProvider.decreaseCurrentQuantity();
                        },
                        onIncrease: () {
                          shakeProvider.increaseCurrentQuantity();
                        },
                      ),
                    ),
                    const Flexible(
                        flex: 10, child: SizedBox(width: double.infinity)),
                    Flexible(
                      flex: 50,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ShakeFlavorSelection()),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          width: double.infinity,
                          height: 40,
                          child: const Center(
                            child: Text("Select Flavors",
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            GestureDetector(
              onTap: shakeProvider.flavorsAreSelected()
                  ? () {
                      Shake shake = Shake(
                          shakeProvider.savedSelectedFlavorsIndices,
                          shakeProvider.savedSizeIndex);
                      if (shakeProvider.updatingExistingShake) {
                        Bag newBagItem = Bag(
                            uniqueID: widget.shakeToEdit!.uniqueID,
                            itemID: widget.shakeToEdit!.itemID,
                            itemName: widget.shakeToEdit!.itemName,
                            image: widget.shakeToEdit!.image,
                            price: widget.shakeToEdit!.price,
                            quantity: ValueNotifier(shakeQuantity),
                            options: shake.options);
                        if (userProvider.currentUser == "Customer") {
                          dbHelper.updateCustomerBagItem(newBagItem);
                        } else if (userProvider.currentUser == "Worker") {
                          dbHelper.updateWorkerBagItem(newBagItem);
                        }
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewBag()));
                      } else {
                        if (userProvider.currentUser == "Customer") {
                          saveDataToCustomerBag(shake);
                        } else if (userProvider.currentUser == "Worker") {
                          saveDataToWorkerBag(shake);
                        }
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Menu()));
                      }
                      shakeProvider.discardAllSelections();
                    }
                  : () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                              child: SizedBox(
                            height: 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Select a Flavor",
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
                          ))),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                    color: Colors.red, border: Border.all(color: Colors.grey)),
                child: Center(
                    child: Text(
                        updatingExistingShake ? "Save Changes" : "Add To Bag")),
              ),
            )
          ],
        ),
      ),
    );
  }
}
