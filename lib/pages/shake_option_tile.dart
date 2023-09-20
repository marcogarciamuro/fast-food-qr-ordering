import 'package:fast_food_qr_ordering/pages/customize_drink.dart';
import 'package:flutter/material.dart';

class ShakeOptionTile extends StatelessWidget {
  final int value;
  final List<int> groupValues;
  final String title;
  final VoidCallback onChanged;
  final String imagePath;
  final int calories;

  const ShakeOptionTile(
      {Key? key,
      required this.value,
      required this.groupValues,
      required this.onChanged,
      required this.title,
      this.calories = 0,
      this.imagePath = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final title = this.title;
    // print("CURRENT SELECTED INDICES: $groupValues");
    final isSelected = groupValues.contains(value);
    return InkWell(
      splashColor: const Color(0xFFFFCB05),
      onTap: () => onChanged(),
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image(
                    image: AssetImage(imagePath),
                    width: 40,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    calories != 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Text("$calories cal."),
                          )
                        : Container(),
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
