import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/fries_provider.dart';
import 'package:fast_food_qr_ordering/pages/individual_drink_selection.dart';
import 'package:fast_food_qr_ordering/pages/view_shake.dart';
import 'package:fast_food_qr_ordering/pages/view_bag.dart';
import 'package:fast_food_qr_ordering/pages/view_burger.dart';
import 'package:fast_food_qr_ordering/pages/view_fries.dart';
import 'package:fast_food_qr_ordering/burger_provider.dart';
import 'package:fast_food_qr_ordering/shake_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fast_food_qr_ordering/bag_provider.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:badges/badges.dart' as badge_package;
import 'package:fast_food_qr_ordering/pages/view_meal.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  static const _meals = [
    {
      "name": "Double Double, French Fries, and Medium Drink",
      "id": 1,
      "reference_name": "\$7.84",
      "cost": 7.84,
      "picture": "pictures/double-double-meal.png",
      "type": "meal",
    },
    {
      "name": "Cheeseburger, French Fries, and Medium Drink",
      "id": 2,
      "reference_name": "COMBO #2",
      "cost": 6.61,
      "picture": "pictures/cheeseburger-meal.png",
      "type": "meal",
    },
    {
      "name": "Hamburger, French Fries, and Medium Drink",
      "id": 3,
      "cost": 6.26,
      "picture": "pictures/hamburger-meal.png",
      "type": "meal",
    },
  ];
  static const _burgers = [
    {
      "name": "Double Double",
      "id": 4,
      "cost": 6.26,
      "picture": "pictures/double-double.png",
      "type": "burger",
    },
    {
      "name": "Cheeseburger",
      "id": 5,
      "cost": 6.26,
      "picture": "pictures/cheeseburger.png",
      "type": "burger",
    },
    {
      "name": "Hamburger",
      "id": 6,
      "cost": 6.26,
      "picture": "pictures/hamburger.png",
      "type": "burger",
    },
  ];
  static const _sides = [
    {
      "name": "French Fries",
      "id": 7,
      "cost": 1.87,
      "picture": "pictures/fries.png",
      "type": "fries",
    },
    {
      "name": "Beverage",
      "id": 8,
      "cost": 1.97,
      "picture": "pictures/beverages.png",
      "type": "drink",
    },
    {
      "name": "Shake",
      "id": 9,
      "cost": 2.52,
      "picture": "pictures/shakes.png",
      "type": "shake",
    },
  ];

  @override
  void dispose() {
    super.dispose();
  }

  DBHelper? dbHelper = DBHelper();

  Column itemCluster(List items) {
    String clusterTitle;
    if (items[0]["type"] == "meal") {
      clusterTitle = "Meals";
    } else if (items[0]['type'] == "burger") {
      clusterTitle = "Burgers";
    } else {
      clusterTitle = "Sides";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
          child: Text(
            clusterTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Card(
          elevation: 0.0,
          child: ListView.separated(
              itemCount: items.length,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 0.0,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      if (items[index]['type'] == 'burger') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewBurger(
                                      itemID: items[index]['id'],
                                    )));
                      } else if (items[index]['type'] == "fries") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewFries(
                                      editing: false,
                                    )));
                      } else if (items[index]['type'] == 'drink') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DrinkSelection()));
                      } else if (items[index]['type'] == 'shake') {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewShake()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ViewMeal(itemID: items[index]['id']))).then(
                            (value) => context.read<BagProvider>().getData());
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: items[index]['type'] == "meal"
                              ? Stack(
                                  children: [
                                    Image.asset("${items[index]['picture']}"),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFFE02A27)),
                                      child: Text(
                                        "${items[index]['id']}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                )
                              : items[index]['type'] == "burger"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Image.asset(
                                          "${items[index]['picture']}"),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: Image.asset(
                                          "${items[index]['picture']}",
                                          width: 80)),
                          title: Text('${items[index]["name"]}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                          subtitle: Text('\$${items[index]['cost']}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, index) {
                return const Divider(thickness: 1);
              }),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    // change this depending on user accessing menu (customer/worker)
    context.read<BagProvider>().getData();
  }

  final List itemList = [_meals, _burgers, _sides];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text("Menu", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: badge_package.Badge(
              position: badge_package.BadgePosition.bottomStart(
                  bottom: 30, start: 30),
              badgeContent: Consumer<BagProvider>(
                builder: (context, value, child) {
                  int totalItemCount = 0;
                  for (var element in value.bag) {
                    totalItemCount += element.quantity!.value;
                  }
                  return Text(totalItemCount.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold));
                },
              ),
              child: IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined, size: 35.0),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewBag()));
                  }),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: itemList.length,
              itemBuilder: (BuildContext context, int index) {
                return itemCluster(itemList[index]);
              },
              separatorBuilder: (_, index) {
                return const SizedBox(height: 20);
              },
            ),
          )
        ],
      ),
    );
  }
}
