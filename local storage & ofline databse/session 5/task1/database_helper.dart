1.<p>Add `getExpenses()` to `DatabaseHelper` using `db.query('expenses', orderBy: 'id DESC')` and `Expense.fromMap`, and build `home_screen.dart`: a ListView.builder
  showing title, category, ₹ amount and date, loaded in `initState`, with a floating action button that opens the Add screen. After you return from it, the new row
  must appear at once. Hint: `initState` cannot be `async`; call a separate `async` method and check `mounted` before `setState`.</p>

    
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

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
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

  // Insert expense
  Future<int> insertExpense(Expense expense) async {
    final db = await database;

    return await db.insert(
      'expenses',
      expense.toMap(),
    );
  }
}
