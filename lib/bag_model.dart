import 'package:flutter/foundation.dart';

class Bag {
  final int? itemID;
  final String? uniqueID;
  final String? itemName;
  final double? price;
  final String? image;
  final String? options;
  final ValueNotifier<int>? quantity;

  Bag(
      {required this.itemName,
      required this.itemID,
      required this.uniqueID,
      required this.price,
      required this.image,
      required this.options,
      required this.quantity});

  Bag.fromMap(Map<dynamic, dynamic> data)
      : uniqueID = data['uniqueID'],
        itemID = data['itemID'],
        itemName = data['itemName'],
        price = data['price'],
        image = data['image'],
        options = data['options'],
        quantity = ValueNotifier(data['quantity']) {
    print("TYPE: ${data['price'].runtimeType}");
  }

  Map<String, dynamic> toMap() {
    return {
      'uniqueID': uniqueID,
      'itemID': itemID,
      'itemName': itemName,
      'price': price,
      'image': image,
      'options': options,
      'quantity': quantity?.value
    };
  }
}
