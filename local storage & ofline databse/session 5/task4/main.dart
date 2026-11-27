
import 'package:flutter/material.dart';
import 'add_expense_screen.dart';

void main() {
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
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // Open Add Expense screen
            },
            child: const Text('Add Expense'),
          ),
        ),
      ),
    );
  }
}
