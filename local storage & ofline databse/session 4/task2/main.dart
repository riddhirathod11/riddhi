
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'models/expense.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create Expense object
  Expense expense = Expense(
    title: 'Auto fare',
    amount: 85,
    category: 'Travel',
    date: '2026-11-02',
    note: 'Travel expense',
  );

  // Convert Expense to Map
  Map<String, dynamic> expenseMap = expense.toMap();

  // Convert Map back to Expense
  Expense convertedExpense = Expense.fromMap(expenseMap);

  debugPrint('Expense Map: $expenseMap');
  debugPrint(
    'Converted Expense: ${convertedExpense.title}, '
    '${convertedExpense.amount}, '
    '${convertedExpense.category}, '
    '${convertedExpense.date}, '
    '${convertedExpense.note}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DatabaseScreen(),
    );
  }
}

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  State<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  Database? database;
  String message = 'Opening database...';

  @override
  void initState() {
    super.initState();
    openExpenseDatabase();
  }

  Future<void> openExpenseDatabase() async {
    final folder = await getDatabasesPath();
    final path = '$folder/expense_tracker.db';

    database = await openDatabase(
      path,
      version: 2,

      // Fresh installation
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
      },

      // Existing database upgrade
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE expenses ADD COLUMN note TEXT',
          );
        }
      },
    );

    setState(() {
      message = 'Database ready\nPath: ${database!.path}';
    });
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
      ),
      body: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
