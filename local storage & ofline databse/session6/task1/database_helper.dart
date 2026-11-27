1.<p>Finish by adding a 'Total spent: ₹X' header above the list from `SELECT SUM(amount) AS total FROM expenses` via `rawQuery`, refreshed after every add, edit, 
delete and UNDO. Test: add expenses of ₹100, ₹150, ₹200, ₹300 and ₹500 (total ₹1,250), edit one by +₹50, delete the ₹200 one; the header must read the right total 
each time and ₹0 on an empty table. Hint: `SUM` returns null on an empty table.</p>

  
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final folder = await getDatabasesPath();
    final path = '$folder/expense_tracker.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL,
            note TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
      },
    );
  }

  // Insert expense
  Future<int> insertExpense(Expense e) async {
    final db = await database;

    return await db.insert(
      'expenses',
      e.toMap(),
    );
  }

  // Get all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await database;

    final List<Map<String, dynamic>> maps =
        await db.query(
      'expenses',
      orderBy: 'id DESC',
    );

    return List.generate(
      maps.length,
      (index) => Expense.fromMap(maps[index]),
    );
  }

  // Calculate total spent
  Future<double> getTotalSpent() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM expenses',
    );

    return (result.first['total'] as num? ?? 0).toDouble();
  }

  // Update expense
  Future<int> updateExpense(Expense e) async {
    final db = await database;

    return await db.update(
      'expenses',
      e.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  // Delete expense
  Future<int> deleteExpense(int id) async {
    final db = await database;

    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Restore deleted expense for Undo
  Future<int> restoreExpense(Expense e) async {
    final db = await database;

    final Map<String, dynamic> map = e.toMap();
    map.remove('id');

    return await db.insert(
      'expenses',
      map,
    );
  }
}


