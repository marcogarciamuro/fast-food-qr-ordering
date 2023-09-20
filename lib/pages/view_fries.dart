import 'package:fast_food_qr_ordering/fries.dart';
import 'package:fast_food_qr_ordering/fries_provider.dart';
import 'package:fast_food_qr_ordering/pages/add_to_bag_button.dart';
import 'package:fast_food_qr_ordering/pages/fries_customization.dart';
import 'package:fast_food_qr_ordering/pages/menu.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ViewFries extends StatefulWidget {
  const ViewFries({Key? key, this.editing = false, this.fryToEdit})
      : super(key: key);

  final bool editing;
  final Bag? fryToEdit;

  @override
  State<ViewFries> createState() => _ViewFriesState();
}

class _ViewFriesState extends State<ViewFries> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DBHelper dbHelper = DBHelper();
    final currentUser = Provider.of<UserProvider>(context).currentUser;
    final bag = Provider.of<BagProvider>(context);
    final fryProvider = Provider.of<FryProvider>(context);
    final fryQuantity = fryProvider.currentQuantity;
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
          quantity: ValueNotifier(fryQuantity),
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
          quantity: ValueNotifier(fryQuantity),
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
      fryProvider.clearSelectionHistory();
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: const IconThemeData(color: Colors.black)),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "French Fries",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Text("\$5.65   820 Cal."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Image.asset("pictures/fries.png", width: 300),
                    const SizedBox(height: 50),
                    fryProvider.fryIsCustomized()
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Your Changes",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(fryProvider.getFormattedCustomizations())
                              ],
                            ))
                        : Container(),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Flexible(
                          flex: 40,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: Colors.grey.shade500, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () => setState(() {
                                          if (fryQuantity > 1) {
                                            fryProvider.currentQuantity--;
                                          }
                                        }),
                                    icon: Icon(Icons.remove,
                                        color: fryQuantity == 1
                                            ? Colors.grey
                                            : Colors.black,
                                        size: 20)),
                                Text(fryQuantity.toString(),
                                    style: const TextStyle(fontSize: 20)),
                                IconButton(
                                  onPressed: () => setState(() {
                                    if (fryQuantity < 99) {
                                      fryProvider.currentQuantity++;
                                    }
                                  }),
                                  icon: Icon(
                                    Icons.add,
                                    color: fryQuantity == 99
                                        ? Colors.grey
                                        : Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Flexible(
                            flex: 10, child: SizedBox(width: double.infinity)),
                        Flexible(
                          flex: 50,
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomizeFries()));
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
                    const SizedBox(height: 70),
                    const Text(
                        "2,000 calories a day is used for general nutrition advice, but calorie needs vary. Additional nutrition information available upon request. Calories show do not reflect customization."),
                  ],
                ),
              ),
            ),
            if (widget.editing == true)
              GestureDetector(
                  onTap: () {
                    Fries fries = Fries(
                      styleChoiceIndex: fryProvider.currentStyleIndex,
                      wellnessPreferenceIndex: fryProvider.currentWellnessIndex,
                      saltPreferenceIndex: fryProvider.currentSaltIndex,
                    );
                    Bag updatedFry = Bag(
                        uniqueID: widget.fryToEdit?.uniqueID,
                        itemID: widget.fryToEdit?.itemID,
                        itemName: widget.fryToEdit?.itemName,
                        price: widget.fryToEdit?.price,
                        image: widget.fryToEdit?.image,
                        options: fries.options,
                        quantity: ValueNotifier(fryQuantity));
                    if (currentUser == "Customer") {
                      dbHelper.updateCustomerBagItem(updatedFry);
                    } else {
                      dbHelper.updateWorkerBagItem(updatedFry);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          border: Border.all(color: Colors.grey)),
                      child: const Center(child: Text("Save Changes")))),
            if (widget.editing == false)
              AddToBagButton(onTap: () {
                final int currentStyleIndex = fryProvider.currentStyleIndex;
                final int currentWellnessIndex =
                    fryProvider.currentWellnessIndex;
                final int currentSaltIndex = fryProvider.currentSaltIndex;
                Fries fries = Fries(
                    styleChoiceIndex: currentStyleIndex,
                    wellnessPreferenceIndex: currentWellnessIndex,
                    saltPreferenceIndex: currentSaltIndex);
                if (currentUser == "Customer") {
                  saveDataToCustomerDB(fries);
                } else {
                  saveDataToWorkerDB(fries);
                }
                Navigator.pop(context);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Menu()));
              })
          ],
        ),
      ),
    );
  }
}
