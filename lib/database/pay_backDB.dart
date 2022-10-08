// ignore_for_file: file_names

import 'package:meal/database/connection.dart';
import 'package:meal/models/models.dart';
import 'package:sqflite/sqlite_api.dart';

class PayBackDB {
  static Future<void> execute() async {
    List<PayBack> all = [];
    int id = 0;
    final year = List.generate(10, (index) => 2020 + index);
    for (int i = 0; i < year.length; ++i) {
      for (int j = 1; j <= 12; ++j) {
        all.add(PayBack(id: id++, amount: 0, month: j, year: year[i]));
      }
    }
    final db = await Connection.instance.database;
    for (int i = 0; i < all.length; i++) {
      await db.insert(tablePayBack, all[i].toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }
  }

  static Future<int> getAmount(int month) async {
    final db = await Connection.instance.database;
    final maps = await db.query(
      tablePayBack,
      columns: PayBackFields.values,
      where: "${PayBackFields.month}=? AND ${PayBackFields.year}=?",
      whereArgs: [month, DateTime.now().year],
    );
    if (maps.isEmpty) return 0;
    return maps.map((e) => PayBack.fromMap(e)).toList()[0].amount;
  }

  static Future<void> update(int id, int amount) async {
    final db = await Connection.instance.database;
    await db.update(tablePayBack, {"amount": amount},
        where: "${PayBackFields.id}=?", whereArgs: [id]);
  }

  static Future<int> getID(int month) async {
    final db = await Connection.instance.database;
    final maps = await db.query(
      tablePayBack,
      columns: PayBackFields.values,
      where: "${PayBackFields.month}=? AND ${PayBackFields.year}=?",
      whereArgs: [month, DateTime.now().year],
    );
    if (maps.isEmpty) return 0;
    return maps.map((e) => PayBack.fromMap(e)).toList()[0].id as int;
  }
}
