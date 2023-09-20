import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_food_qr_ordering/db_helper.dart';
import 'package:fast_food_qr_ordering/bag_model.dart';

class BagProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Bag> bag = [];

  Future<List<Bag>> getData() async {
    bag = await dbHelper.getCustomerBagList();
    notifyListeners();
    return bag;
  }

  int getBagItemCount(List<Bag> bag) {
    int bagItemCount = 0;
    for (var bagObj in bag) {
      bagItemCount += bagObj.quantity!.value;
    }
    return bagItemCount;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('bag_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('bag_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void decrementCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }

  void addQuantity(String id) {
    final index = bag.indexWhere((element) => element.uniqueID == id);
    bag[index].quantity!.value += 1;
    _setPrefsItems();
    notifyListeners();
  }

  void deductQuantity(String id) {
    final index = bag.indexWhere((element) => element.uniqueID == id);
    int currentQuantity = bag[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity = 1;
    } else {
      bag[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(String id) {
    final index = bag.indexWhere((element) => element.uniqueID == id);
    bag.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  void addToTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void deductFromTotalPrice(double productPrice) {
    _totalPrice -= productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }
}
