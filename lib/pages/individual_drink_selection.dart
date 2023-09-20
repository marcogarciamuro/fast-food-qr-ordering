import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/drinks.dart';
import 'package:fast_food_qr_ordering/pages/option_tile.dart';
import 'package:fast_food_qr_ordering/pages/selectable_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinkSelection extends StatefulWidget {
  const DrinkSelection({Key? key}) : super(key: key);

  @override
  State<DrinkSelection> createState() => _DrinkSelectionState();
}

class _DrinkSelectionState extends State<DrinkSelection> {
  @override
  Widget build(BuildContext context) {
    final drinkProvider = Provider.of<DrinkProvider>(context);
    int currentIndex = drinkProvider.currentDrinkSelectionIndex;
    print("DEFAULT INDEX: ${currentIndex}");
    return Scaffold(
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
                    itemCount: drinks.length,
                    itemBuilder: (context, index) {
                      String title = drinks[index]['name'];
                      return Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: OptionTile<int>(
                            imagePath: drinks[index]['picturePath'],
                            calories: drinks[index]['calories'],
                            value: index,
                            id: index,
                            groupValue: currentIndex,
                            title: title,
                            onChanged: (value) {
                              setState(() {
                                currentIndex = index;
                                // widget.callback(index);
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
        ],
      ),
    );
  }
}
