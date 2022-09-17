import 'package:meal/models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Connection {
  static final Connection instance = Connection._init();
  static Database? _database;
  Connection._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = dbPath.path + filePath;
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''CREATE TABLE IF NOT EXISTS $tableMeal (
      ${MealFields.id} $idType,
      ${MealFields.amount} $integerType,
      ${MealFields.day} $integerType,
      ${MealFields.month} $integerType,
      ${MealFields.year} $integerType
    )''');
    await db.execute('''CREATE TABLE IF NOT EXISTS $tablePayment (
      ${PaymentFields.id} $idType,
      ${PaymentFields.amount} $integerType,
      ${PaymentFields.day} $integerType,
      ${PaymentFields.month} $integerType,
      ${PaymentFields.year} $integerType
    )''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
