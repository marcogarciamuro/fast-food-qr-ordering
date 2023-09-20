import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/pages/selectable_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinkSelectionForMeal extends StatefulWidget {
  const DrinkSelectionForMeal({Key? key}) : super(key: key);

  @override
  State<DrinkSelectionForMeal> createState() => _DrinkSelectionForMealState();
}

class _DrinkSelectionForMealState extends State<DrinkSelectionForMeal> {
  static const List drinkOptions = [
    {
      "name": "Coca Cola",
      "calories": 130,
      "picturePath": "pictures/coke.png",
    },
    {
      "name": "Diet Coke",
      "calories": 0,
      "picturePath": "pictures/coke.png",
    },
    {
      "name": "7-UP",
      "calories": 130,
      "picturePath": "pictures/7up.png",
    },
    {
      "name": "Dr Pepper",
      "calories": 130,
      "picturePath": "pictures/coke.png",
    },
    {
      "name": "Barq's Root Beer",
      "calories": 150,
      "picturePath": "pictures/coke.png",
    },
    {
      "name": "Pink Lemonade",
      "calories": 150,
      "picturePath": "pictures/pink-lemonade.png",
    },
    {
      "name": "Minute Maid Zero Sugar Lemonade",
      "calories": 5,
      "picturePath": "pictures/lemonade.png",
    },
    {
      "name": "Iced Tea",
      "calories": 0,
      "picturePath": "pictures/tea.png",
    },
    {
      "name": "Sweet Tea",
      "calories": 90,
      "picturePath": "pictures/tea.png",
    },
    {
      "name": "Coffee",
      "calories": 5,
      "picturePath": "pictures/coffee.png",
    },
    {
      "name": "Hot Cocoa",
      "calories": 130,
      "picturePath": "pictures/hot-cocoa.png",
    },
    {
      "name": "Milk",
      "calories": 180,
      "picturePath": "pictures/milk.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final drinkProvider = Provider.of<DrinkProvider>(context);
    int currentIndex = drinkProvider.currentDrinkSelectionIndex;
    Future<bool> onWillPop() async {
      bool? shouldPop;
      if (drinkProvider.newDrinkWasSelected() == false) {
        print("DRINK IS NOT CUSTOMIZED");
        shouldPop = true;
      } else {
        print("DRINK IS CUSTOMIZED");
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
            });
      }
      if (shouldPop!) {
        drinkProvider.clearSelectionHistory();
      }
      return shouldPop;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 30, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Select Drink",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 25),
                      child: Divider(thickness: 1),
                    ),
                    ListView.separated(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: drinkOptions.length,
                      itemBuilder: (context, index) {
                        String title = drinkOptions[index]['name'];
                        return Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SelectableOptionTile<int>(
                              imagePath: drinkOptions[index]['picturePath'],
                              calories: drinkOptions[index]['calories'],
                              value: index,
                              groupValue: currentIndex,
                              title: title,
                              onChanged: (value) {
                                setState(() {
                                  drinkProvider.currentDrinkSelection = index;
                                });
                              }),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return const Divider(thickness: 1);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            '2,000 calories a day is used for general nutrition advice, but calorie needs vary. Drink calories based on serving size with ice.',
                            style: TextStyle(height: 1.25),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'SODIUM CONTENT OF DRINKS WILL VARY DEPENDING ON WATER SUPPLY. “Coca-Cola,” “Diet Coke,” "Barq\'s" and “Minute Maid” are registered trademarks of The Coca-Cola Company. “Dr Pepper” and “7UP” are registered trademarks of the Dr. Pepper/Snapple Group',
                            style: TextStyle(height: 1.25),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '*Available only in certain markets.',
                            style: TextStyle(height: 1.25),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () async {
                        if (await onWillPop()) {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                        child: const Center(
                            child: Text("Cancel",
                                style: TextStyle(color: Color(0xFFE02A27)))),
                      ),
                    ),
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        drinkProvider.updateSavedIndices();
                      },
                      child: Container(
                        height: 55,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color(0xFFFFCB05),
                            border: Border(
                              top: BorderSide(color: Colors.grey),
                            )),
                        child: const Center(child: Text("Save Changes")),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
