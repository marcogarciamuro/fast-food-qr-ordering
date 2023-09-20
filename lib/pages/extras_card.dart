import 'package:fast_food_qr_ordering/bag_model.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:fast_food_qr_ordering/user_provider.dart';
import 'package:fast_food_qr_ordering/worker_bag_provider.dart';
import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/item.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ExtrasCard extends StatefulWidget {
  const ExtrasCard({Key? key}) : super(key: key);

  @override
  State<ExtrasCard> createState() => _ExtrasCardState();
}

int ketchupQuantity = 0;
int spreadQuantity = 0;
int peppersQuantity = 0;

List<bool> showExtras = [true, true, true];

class _ExtrasCardState extends State<ExtrasCard> {
  @override
  void initState() {
    super.initState();
    showExtras = [true, true, true];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    DBHelper dbHelper = DBHelper();
    List extras = [
      {"name": "Spread", "id": 10, "image": "pictures/spread.jpg"},
      {"name": "Ketchup", "id": 11, "image": "pictures/ketchup.jpg"},
      {"name": "Chilies", "id": 12, "image": "pictures/peppers2.png"}
    ];
    void saveData(Item item) {
      var uuid = const Uuid();
      var uniqueID = uuid.v1();
      if (userProvider.currentUser == "Customer") {
        dbHelper
            .addCustomerBagToDB(Bag(
                uniqueID: uniqueID,
                itemID: item.id,
                itemName: item.name,
                price: item.price,
                image: item.image,
                options: item.options,
                quantity: ValueNotifier(1) // change
                ))
            .then((value) {
          print("Added extra item to bag");
        }).onError((error, stackTrace) {
          print(error.toString());
        });
      } else {
        dbHelper
            .addWorkerBagToDB(Bag(
                uniqueID: uniqueID,
                itemID: item.id,
                itemName: item.name,
                price: item.price,
                image: item.image,
                options: item.options,
                quantity: ValueNotifier(1) // change
                ))
            .then((value) {
          print("Added extra item to bag");
        }).onError((error, stackTrace) {
          print(error.toString());
        });
      }
    }

    return showExtras.every((extra) => !extra)
        ? Container()
        : Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add Extras",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: extras.length,
                      itemBuilder: (context, index) {
                        return showExtras[index] == true
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Stack(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              width: 0.5,
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Image.asset(
                                            extras[index]['image'],
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: 35,
                                          child: FittedBox(
                                            child: FloatingActionButton.small(
                                                heroTag: "$index",
                                                child: const Icon(Icons.add),
                                                onPressed: () {
                                                  Item extraItem = Item(
                                                      extras[index]['id'],
                                                      extras[index]['name'],
                                                      0.0,
                                                      extras[index]['image'],
                                                      "");
                                                  saveData(extraItem);
                                                  if (userProvider
                                                          .currentUser ==
                                                      "Customer") {
                                                    context
                                                        .read<BagProvider>()
                                                        .getData();
                                                  } else {
                                                    context
                                                        .read<
                                                            WorkerBagProvider>()
                                                        .getData();
                                                  }
                                                  if (showExtras[index] ==
                                                      true) {
                                                    setState(() {
                                                      showExtras[index] = false;
                                                    });
                                                    print('set to false');
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(extras[index]['name']),
                                ],
                              )
                            : Container();
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 10);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
