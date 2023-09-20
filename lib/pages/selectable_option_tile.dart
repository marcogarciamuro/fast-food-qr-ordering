import 'package:fast_food_qr_ordering/pages/customize_drink.dart';
import 'package:flutter/material.dart';

const List<String> drinkOptions = [
  "Coca Cola",
  "Pink Lemonade",
  "Barq's Root Beer",
  "7-UP",
  "Diet Coke",
  "Dr Pepper",
  "Minute Maid Zero Sugar Lemonade",
  "Iced Tea",
  "Sweet Tea",
  "Coffee",
  "Hot Cocoa",
  "Milk"
];

class SelectableOptionTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String title;
  final ValueChanged<T?> onChanged;
  final String imagePath;
  final int calories;

  const SelectableOptionTile(
      {Key? key,
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
    return InkWell(
      splashColor: const Color(0xFFFFCB05),
      onTap: () => onChanged(value),
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
                    // if option is a drink option
                    drinkOptions.contains(title)
                        ?
                        // drink thumbnail
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image(
                              image: AssetImage(imagePath),
                              width: 30,
                              height: 30,
                            ),
                          )
                        : Container(),
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
                        drinkOptions.contains(title) && isSelected
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomizeDrink(
                                                  drinkIsForMeal: true)));
                                },
                                child: const Text('Customize',
                                    style: TextStyle(color: Color(0xFFE02A27))),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            isSelected
                ? const Icon(Icons.check_circle_rounded,
                    color: Color(0xFFE02A27))
                : Container(),
          ],
        ),
      ),
    );
  }
}
