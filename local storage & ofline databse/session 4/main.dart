
import 'package:flutter/material.dart';
import 'models/expense.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create Expense object
  Expense expense = Expense(
    title: 'Auto fare',
    amount: 85,
    category: 'Travel',
    date: '2026-11-02',
  );

  // Convert Expense to Map
  Map<String, dynamic> expenseMap = expense.toMap();

  // Convert Map back to Expense
  Expense convertedExpense = Expense.fromMap(expenseMap);

  // Print both in Debug Console
  debugPrint('Expense Map: $expenseMap');

  debugPrint(
    'Converted Expense: '
    'Title: ${convertedExpense.title}, '
    'Amount: ${convertedExpense.amount}, '
    'Category: ${convertedExpense.category}, '
    'Date: ${convertedExpense.date}',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expense Tracker'),
        ),
        body: const Center(
          child: Text('Check Debug Console'),
        ),
      ),
    );
  }
}
