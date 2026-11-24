2.<p>Add a second table `categories` (`id INTEGER PRIMARY KEY AUTOINCREMENT`, `name TEXT NOT NULL UNIQUE`) and build a `SchemaScreen` showing one Card per table 
with its name and one line per column such as `amount (REAL)`. Read table names from `sqlite_master` and columns with `PRAGMA table_info(table_name)`, both through
`db.rawQuery`. Hint: AUTOINCREMENT creates an internal table `sqlite_sequence`; leave it out with `WHERE type = 'table' AND name NOT LIKE 'sqlite_%'`.
Constraint: Do not hard-code column names in the screen.</p>

  
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'schema_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Database? database;

  String message = 'Opening database...';
  String databasePath = '';

  @override
  void initState() {
    super.initState();
    openDatabaseFile();
  }

  Future<void> openDatabaseFile() async {
    try {
      final folder = await getDatabasesPath();
      final path = '$folder/expense_tracker.db';

      final db = await openDatabase(
        path,
        version: 2,

        onCreate: (db, version) async {
          await createExpensesTable(db);
          await createCategoriesTable(db);
        },

        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await createCategoriesTable(db);
          }
        },
      );

      if (!mounted) {
        await db.close();
        return;
      }

      setState(() {
        database = db;
        databasePath = db.path;
        message = 'Database ready';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = 'Database error: $e';
      });
    }
  }

  Future<void> createExpensesTable(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<void> createCategoriesTable(DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE
      )
    ''');
  }

  @override
  void dispose() {
    database?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.storage,
                size: 70,
                color: Colors.deepPurple,
              ),

              const SizedBox(height: 20),

              Text(
                message,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              if (databasePath.isNotEmpty) ...[
                const Text(
                  'Database Path:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                SelectableText(
                  databasePath,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: database == null
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SchemaScreen(
                                  database: database!,
                                ),
                              ),
                            );
                          },
                    icon: const Icon(Icons.table_chart),
                    label: const Text('View Database Schema'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


