// ignore_for_file: file_names

import 'package:meal/database/connection.dart';
import 'package:meal/models/models.dart';

class MealDB {
  static Future<void> create(Meal meal) async {
    final db = await Connection.instance.database;
    await db.insert(tableMeal, meal.toMap());
  }

  static Future<void> update(Meal meal) async {
    final db = await Connection.instance.database;
    await db.update(tableMeal, meal.toMap(),
        where: "${MealFields.id}=?", whereArgs: [meal.id]);
  }

  static Future<void> delete(int id) async {
    final db = await Connection.instance.database;
    await db.delete(tableMeal, where: "${MealFields.id} = ?", whereArgs: [id]);
  }

  static Future<List<Meal>> getMeals(int month) async {
    final db = await Connection.instance.database;
    DateTime now = DateTime.now();
    final maps = await db.query(tableMeal,
        columns: MealFields.values,
        where: "${MealFields.month}=? AND ${MealFields.year}=?",
        whereArgs: [month, now.year]);
    if (maps.isNotEmpty) {
      return maps.map((e) => Meal.fromMap(e)).toList();
    }
    return [];
  }
}
