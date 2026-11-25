4.<p>Move your 6.3 database code into `lib/database/database_helper.dart`: a `DatabaseHelper` class with a private constructor, one shared `static final instance`, 
and `Future<Database> get database` that opens `expense_tracker.db` only once. Create `expenses` and `categories` inside `onCreate` with `version: 1`; keep the Schema
screen working. Hint: Uninstall the app from the emulator first so `onCreate` runs on a fresh file. Missed 6.3? Start with a project that opens a database and creates 
`expenses`.</p>


  
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Private constructor
  DatabaseHelper._privateConstructor();

  // One shared instance
  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  // Store database connection
  Database? _database;

  // Database getter
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    final folder = await getDatabasesPath();
    final path = '$folder/expense_tracker.db';

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create expenses table
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

        // Create categories table
        await db.execute('''
          CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
      },
    );
  }
}

