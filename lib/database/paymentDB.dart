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
}
