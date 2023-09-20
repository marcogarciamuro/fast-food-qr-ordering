import 'package:flutter/material.dart';
import 'package:fast_food_qr_ordering/item.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key, required this.items}) : super(key: key);
  final List items;

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
    );
  }
}
