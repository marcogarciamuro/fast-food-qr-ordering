import 'package:fast_food_qr_ordering/drink_provider.dart';
import 'package:fast_food_qr_ordering/pages/customize_drink.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OptionTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final int id;
  final String title;
  final ValueChanged<T?> onChanged;
  final String imagePath;
  final int calories;

  const OptionTile(
      {Key? key,
      required this.id,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.title,
      this.calories = 0,
      this.imagePath = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final title = this.title;
    final isSelected = value == groupValue;
    final drinkProvider = Provider.of<DrinkProvider>(context);
    return InkWell(
      splashColor: const Color(0xFFFFCB05),
      onTap: () {
        drinkProvider.currentDrinkSelection = id;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CustomizeDrink(drinkIsForMeal: false)));
      },
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Thumbnail and text column
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    // drink thumbnail
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image(
                        image: AssetImage(imagePath),
                        width: 30,
                        height: 30,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        calories != 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text("$calories cal."),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
