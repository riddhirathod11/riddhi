3.<p>Finish by adding a 'Reset database' icon to the Schema screen's AppBar: it closes the open connection, calls `deleteDatabase(path)`, clears the helper's stored
  `_database`, opens a fresh database and refreshes the screen. Test: press it three times; both tables and the `note` column must reappear each time. Submit the
  `expense_tracker` folder. Hint: Read `db.path` before calling `db.close()`.</p>

    
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  Database? _database;

  // Get database connection
  Future<Database> get database async {
    if (_database != null && _database!.isOpen) {
      return _database!;
    }

    _database = await openDb();
    return _database!;
  }

  // Open database
  Future<Database> openDb() async {
    final folder = await getDatabasesPath();
    final path = '$folder/expense_tracker.db';

    return await openDatabase(
      path,
      version: 2,
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
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE expenses ADD COLUMN note TEXT',
          );
        }

        await db.execute('''
          CREATE TABLE IF NOT EXISTS categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL UNIQUE
          )
        ''');
      },
    );
  }

  // Reset database
  Future<Database> resetDatabase() async {
    // Get current database
    final db = await database;

    // Save path before closing connection
    final path = db.path;

    // Close current connection
    await db.close();

    // Clear stored database connection
    _database = null;

    // Delete old database
    await deleteDatabase(path);

    // Open fresh database
    _database = await openDb();

    return _database!;
  }
}
