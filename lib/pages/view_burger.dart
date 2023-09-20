import 'package:fast_food_qr_ordering/burger.dart';
import 'package:fast_food_qr_ordering/pages/burger_customization.dart';
import 'package:fast_food_qr_ordering/pages/change_quantity.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';
import 'package:fast_food_qr_ordering/burger_provider.dart';
import 'package:fast_food_qr_ordering/pages/view_bag.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ViewBurger extends StatefulWidget {
  const ViewBurger({
    Key? key,
    required this.itemID,
    this.editing = false,
    this.burgerToEdit,
  }) : super(key: key);
  final bool editing;
  final Bag? burgerToEdit;
  final int itemID;

  @override
  State<ViewBurger> createState() => _ViewBurgerState();
}

class _ViewBurgerState extends State<ViewBurger> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DBHelper dbHelper = DBHelper();
    final bag = Provider.of<BagProvider>(context);
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    final burgerProvider = Provider.of<BurgerProvider>(context);
    int burgerQuantity = burgerProvider.currentQuantity;
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
            quantity: ValueNotifier(burgerQuantity)),
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
            quantity: ValueNotifier(burgerQuantity)),
      )
          .then((value) {
        bag.addToTotalPrice(item.price);
        bag.addCounter();
        print("Item added to bag");
      }).onError((error, stackTrace) {
        print(error.toString());
      });
    }

    final burgerInfo = getBurgerInfo(widget.itemID);

    Future<bool> onWillPop() async {
      burgerProvider.clearSelectionHistory();
      return true;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      burgerInfo['burgerName'],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Text("\$5.65   820 Cal."),
                  ],
                ),
              ),
              Image.asset(burgerInfo['burgerImagePath'], width: 300),
              burgerProvider.burgerIsCustomized()
                  ? Align(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Your Changes",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(burgerProvider.getFormattedCustomizations())
                      ],
                    ))
                  : Container(),
              Row(
                children: [
                  Flexible(
                      flex: 40,
                      child: ChangeQuantity(
                        fontSize: 20,
                        iconSize: 20,
                        onDecrease: () {
                          if (burgerQuantity > 1) {
                            setState(() => burgerProvider.currentQuantity--);
                          }
                        },
                        onIncrease: () {
                          if (burgerQuantity < 99) {
                            setState(() => burgerProvider.currentQuantity++);
                          }
                        },
                        quantity: burgerQuantity,
                      )),
                  const Flexible(
                      flex: 10, child: SizedBox(width: double.infinity)),
                  Flexible(
                    flex: 50,
                    child: GestureDetector(
                      onTap: () async {
                        final selectedOptions = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BurgerCustomization(),
                          ),
                        );
                        print(selectedOptions);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5)),
                        width: double.infinity,
                        height: 40,
                        child: const Center(
                          child: Text("Customize",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                  "2,000 calories a day is used for general nutrition advice, but calorie needs vary. Additional nutrition information available upon request. Calories show do not reflect customization."),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE02A27),
                    ),
                    onPressed: () {
                      Burger burger = Burger(widget.itemID,
                          burgerStyleIndex: burgerProvider.currentStyleIndex,
                          bunPreferenceIndex: burgerProvider.currentBunIndex,
                          lettucePreferenceIndex:
                              burgerProvider.currentLettuceIndex,
                          onionPreferenceIndex:
                              burgerProvider.currentOnionIndex,
                          tomatoPreferenceIndex:
                              burgerProvider.currentTomatoIndex,
                          saucePreferenceIndex:
                              burgerProvider.currentSauceIndex);
                      if (widget.editing == false) {
                        if (currentUser == "Customer") {
                          saveDataToCustomerDB(burger);
                        } else {
                          saveDataToWorkerDB(burger);
                        }
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Menu()));
                      } else {
                        Bag newBagItem = Bag(
                            uniqueID: widget.burgerToEdit!.uniqueID,
                            itemID: widget.burgerToEdit!.itemID,
                            itemName: widget.burgerToEdit!.itemName,
                            image: widget.burgerToEdit!.image,
                            price: widget.burgerToEdit!.price,
                            quantity: ValueNotifier(burgerQuantity),
                            options: widget.burgerToEdit!.options);
                        if (currentUser == "Customer") {
                          dbHelper.updateCustomerBagItem(newBagItem);
                        } else {
                          dbHelper.updateWorkerBagItem(newBagItem);
                        }
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewBag()));
                      }
                    },
                    child:
                        Text(widget.editing ? "Save Changes" : "Add to Bag")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
