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
    return _database;
  }

  initDatabase() async {
    print("INITIALIZING DATABAASE");
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'bag17.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  // Creating database table
  _onCreate(Database db, int version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    await db.execute(
        'CREATE TABLE customer_bag(uniqueID TEXT PRIMARY KEY, itemID INTEGER, itemName TEXT, price REAL, image TEXT, options TEXT, quantity INTEGER)');
    await db.execute(
        'CREATE TABLE worker_bag(uniqueID TEXT PRIMARY KEY, itemID INTEGER, itemName TEXT, price REAL, image TEXT, options TEXT, quantity INTEGER)');
  }

  // inserting data into table
  Future<Bag> addCustomerBagToDB(Bag bag) async {
    var dbClient = await database;
    await dbClient!.insert('customer_bag', bag.toMap());
    print("INSERTING: ${bag.toMap()}");
    return bag;
  }

  Future<Bag> addWorkerBagToDB(Bag bag) async {
    var dbClient = await database;
    await dbClient!.insert('worker_bag', bag.toMap());
    print("INSERTING: ${bag.toMap()}");
    return bag;
  }

  // getting all items in list from database
  Future<List<Bag>> getCustomerBagList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('customer_bag');
    return queryResult.map((result) => Bag.fromMap(result)).toList();
  }

  Future<List<Bag>> getWorkerBagList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('worker_bag');
    return queryResult.map((result) => Bag.fromMap(result)).toList();
  }

  Future<Order> getOrder(String orderID) async {
    var dbClient = await database;
    final queryResult = await dbClient!
        .query('orders', where: "uniqueID = ?", whereArgs: [orderID]);
    return queryResult.map((result) => Order.fromMap(result)) as Order;
  }

  Future<int> updateCustomerBagItem(Bag bag) async {
    var dbClient = await database;
    return await dbClient!.update('customer_bag', bag.toMap(),
        where: "uniqueID = ?", whereArgs: [bag.uniqueID]);
  }

  Future<int> updateWorkerBagItem(Bag bag) async {
    var dbClient = await database;
    return await dbClient!.update('worker_bag', bag.toMap(),
        where: "uniqueID = ?", whereArgs: [bag.uniqueID]);
  }

  Future<int> deleteCustomerBagItem(String id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('customer_bag', where: 'uniqueID = ?', whereArgs: [id]);
  }

  Future<int> deleteAllWorkerBagItems() async {
    var dbClient = await database;
    return await dbClient!.delete('worker_bag');
  }

  Future<int> deleteWorkerBagItem(String id) async {
    var dbClient = await database;
    return await dbClient!
        .delete('worker_bag', where: 'uniqueID = ?', whereArgs: [id]);
  }
}
