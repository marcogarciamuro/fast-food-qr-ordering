import 'package:flutter/material.dart';

class ChangeQuantity extends StatelessWidget {
  const ChangeQuantity(
      {Key? key,
      required this.fontSize,
      required this.iconSize,
      required this.quantity,
      required this.onIncrease,
      required this.onDecrease})
      : super(key: key);

  final int quantity;
  final double fontSize;
  final double iconSize;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey.shade500, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => onDecrease(),
                icon: Icon(Icons.remove,
                    color: quantity == 1 ? Colors.grey : Colors.black,
                    size: iconSize)),
            Text(quantity.toString(), style: TextStyle(fontSize: fontSize)),
            IconButton(
              onPressed: () => onIncrease(),
              icon: Icon(
                Icons.add,
                color: quantity == 99 ? Colors.grey : Colors.black,
                size: iconSize,
              ),
            ),
          ],
        ));
  }
}
