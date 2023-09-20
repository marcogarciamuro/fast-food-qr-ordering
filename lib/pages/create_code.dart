import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateCode extends StatelessWidget {
  const CreateCode({Key? key, required this.order}) : super(key: key);
  final String order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Order Complete",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            Text("Show this code at restaurant to place order",
                style: TextStyle(fontSize: 15)),
            SizedBox(height: 15),
            QrImage(data: order, size: 300),
          ],
        ),
      ),
    );
  }
}
