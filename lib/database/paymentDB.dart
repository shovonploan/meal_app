// ignore_for_file: file_names

import 'package:meal/database/connection.dart';
import 'package:meal/models/models.dart';

class PaymentDB {
  static Future<void> create(Payment payment) async {
    final db = await Connection.instance.database;
    await db.insert(tablePayment, payment.toMap());
  }

  static Future<void> update(Payment payment) async {
    final db = await Connection.instance.database;
    await db.update(tablePayment, payment.toMap(),
        where: "${PaymentFields.id}=?", whereArgs: [payment.id]);
  }

  static Future<void> delete(int id) async {
    final db = await Connection.instance.database;
    await db.delete(tablePayment,
        where: "${PaymentFields.id} = ?", whereArgs: [id]);
  }

  static Future<List<Payment>> getPayments(int month) async {
    final db = await Connection.instance.database;
    DateTime now = DateTime.now();
    final maps = await db.query(tablePayment,
        columns: PaymentFields.values,
        where: "${MealFields.month}=? AND ${MealFields.year}=?",
        whereArgs: [month, now.year]);
    if (maps.isNotEmpty) {
      return maps.map((e) => Payment.fromMap(e)).toList();
    }
    return [];
  }

  static Future<int> getTotal(int month) async {
    final db = await Connection.instance.database;
    final maps = await db.query(tablePayment,
        columns: ["SUM(${MealFields.amount}) as s"],
        where: "${MealFields.month}=? AND ${MealFields.year}=?",
        whereArgs: [month, DateTime.now().year]);
    if (maps.isNotEmpty) {
      maps[0]["s"];
    }
    return 0;
  }
}
