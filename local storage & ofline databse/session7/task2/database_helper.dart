
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  Database? _database;

  int readCalls = 0;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(
      await getDatabasesPath(),
      'expense_tracker.db',
    );

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

  Future<int> insertExpense(Expense expense) async {
    final db = await database;

    return await db.insert(
      'expenses',
      expense.toMap(),
    );
  }

  Future<List<Expense>> getExpenses() async {
    readCalls++;

    print('Read calls: $readCalls');

    final db = await database;

    final result = await db.query(
      'expenses',
      orderBy: 'id DESC',
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await database;

    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await database;

    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
