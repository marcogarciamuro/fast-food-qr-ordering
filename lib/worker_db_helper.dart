import 'package:fast_food_qr_ordering/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:fast_food_qr_ordering/bag_model.dart';

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    print("DATABASE DOES NOT EXIST");
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'bag16.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // Creating database table
  _onCreate(Database db, int version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    await db.execute(
        'CREATE TABLE bag(uniqueID TEXT PRIMARY KEY, itemID INTEGER, itemName TEXT, price REAL, image TEXT, options TEXT, quantity INTEGER)');
    await db.execute(
        'CREATE TABLE orders(uniqueID TEXT PRIMARY KEY, items TEXT, totalPrice REAL, itemCount INTEGER)');
  }

  // inserting data into table
  Future<Bag> addBagToDB(Bag bag) async {
    var dbClient = await database;
    await dbClient!.insert('bag', bag.toMap());
    print("INSERTING: ${bag.toMap()}");
    return bag;
  }

  // getting all items in list from database
  Future<List<Bag>> getBagList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('bag');
    return queryResult.map((result) => Bag.fromMap(result)).toList();
  }

  Future<Order> getOrder(String orderID) async {
    var dbClient = await database;
    final queryResult = await dbClient!
        .query('orders', where: "uniqueID = ?", whereArgs: [orderID]);
    return queryResult.map((result) => Order.fromMap(result)) as Order;
  }

  Future<int> updateBagItem(Bag bag) async {
    var dbClient = await database;
    return await dbClient!.update('bag', bag.toMap(),
        where: "uniqueID = ?", whereArgs: [bag.uniqueID]);
  }

  Future<int> deleteBagItem(String id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('bag', where: 'uniqueID = ?', whereArgs: [id]);
  }
}
