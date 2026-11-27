1.<p>Reduce database calls: each refresh now runs one query for the list and another for `SUM`. Remove the SUM query and calculate the total with a for loop over
  the loaded list, so a refresh makes exactly one read. Add a counter in `DatabaseHelper` that prints 'Read calls: n' on every `getExpenses` call. Test: add, 
   edit and delete one row each; the counter must rise by exactly 1 each time. Submit `expense_tracker`.</p>

      
import 'package:sqflite/sqflite.dart';
import '../models/expense.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  Database? _database;

  int readCalls = 0;

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

  // Get expenses - only one read query
  Future<List<Expense>> getExpenses() async {
    final db = await database;

    readCalls++;

    print('Read calls: $readCalls');

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

  // Update expense
  Future<int> updateExpense(Expense e) async {
    final db = await database;

    return await db.update(
      'expenses',
      e.toMap(),
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
}
