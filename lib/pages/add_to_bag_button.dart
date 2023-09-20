import 'package:flutter/material.dart';

class AddToBagButton extends StatelessWidget {
  const AddToBagButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
            color: Colors.red, border: Border.all(color: Colors.grey)),
        child: Center(child: Text("Add to Bag")),
      ),
    );
  }
}
