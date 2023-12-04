import 'dart:io';

import 'package:order/models/finished_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class FinishedDatabaseHelper {
  FinishedDatabaseHelper._privateContructor();
  static FinishedDatabaseHelper instance = FinishedDatabaseHelper._privateContructor();

  Database? _database;

  Future<Database> get database async => _database ??= await initDB();

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "finisheddb.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE finishedorders (id INTEGER PRIMARY KEY NOT NULL, name TEXT, count INTEGER, price REAL, paid REAL, loss REAL, completed REAL, type TEXT)");
  }

  Future<List<FinishedModel?>> getOrderList() async {
    Database db = await instance.database;
    var orders = await db.query("finishedorders");
    List<FinishedModel?> orderList = orders.isNotEmpty ? orders.map((o) => FinishedModel.fromMap(o)).toList() : [];
    return orderList;
  }

  Future<int> insertOrder(FinishedModel order) async {
    Database db = await instance.database;
    int newCount = order.count!.round();
    return await db.insert("finishedorders", order.toMap(newCount));
  }

  Future<int> updateOrder(FinishedModel order) async {
    Database db = await instance.database;
    int newCount = order.count!.round();
    return await db.update("finishedorders", order.toMap(newCount), where: "id = ?", whereArgs: [order.id]);
  }

  Future<int> deleteOrder(FinishedModel order) async {
    Database db = await instance.database;
    return await db.delete("finishedorders", where: "name = ?", whereArgs: [order.name]);
  }

  Future<int> updateCompleted(FinishedModel order, bool completed) async {
    Database db = await instance.database;
    return await db.update(
      'finishedorders',
      {'completed': completed == true ? 1 : 0},
      where: "id = ?",
      whereArgs: [order.id],
    );
  }

  Future<double> getTotalPrice() async {
    final List<FinishedModel?> orders = await getOrderList();
    double totalPrice = 0;
    for (var order in orders) {
      totalPrice += order!.price ?? 0;
    }
    return totalPrice;
  }

  Future<double> getTotalLoss() async {
    final List<FinishedModel?> orders = await getOrderList();
    double totalLoss = 0;
    for (var order in orders) {
      totalLoss += order!.loss ?? 0;
    }
    return totalLoss;
  }

  Future<double> getTotalPaid() async {
    final List<FinishedModel?> orders = await getOrderList();
    double paid = 0;
    for (var order in orders) {
      paid += order!.paid ?? 0;
    }
    return paid;
  }
}
