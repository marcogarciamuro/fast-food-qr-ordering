import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_food_qr_ordering/firebase_options.dart';

class OrderStorage {
  bool _initialized = false;

  Future<void> initializeDefault() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    _initialized = true;
  }

  OrderStorage() {
    initializeDefault();
  }

  Future<bool> addOrder(
      String orderID, String items, int itemCount, double totalPrice) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('orders')
        .doc(orderID)
        .set({'items': items, 'totalPrice': totalPrice, 'itemCount': itemCount})
        .then((value) => print("Order registered"))
        .catchError((error) => print("Failed to register order"));
    return true;
  }

  Future<Map?> getOrder(String orderID) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot value =
        await firestore.collection('orders').doc(orderID).get();
    Map<String, dynamic>? data = (value.data()) as Map<String, dynamic>?;
    return data;
  }

  Future<bool> deleteOrder(String orderID) async {
    if (!_initialized) {
      await initializeDefault();
    }
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore
        .collection('orders')
        .doc(orderID)
        .delete()
        .then((value) => print("Order deleted"))
        .catchError((error) => print("Error deleting order"));
    return true;
  }
}
