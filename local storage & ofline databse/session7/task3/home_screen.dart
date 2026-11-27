3.<p>Make the home screen body show exactly one of three states, driven by a `bool _loading` flag: a CircularProgressIndicator while fetching, a centred message
'No expenses yet. Tap + to add one.' when the table is empty, or the list. Test: temporarily add `await Future.delayed(const Duration(seconds: 2))` in the load 
method to see the spinner, then delete all rows to see the message. Constraint: Do not use `FutureBuilder`.</p>

  
import 'package:flutter/material.dart';

import 'models/expense.dart';
import 'database/database_helper.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  double totalSpent = 0;

  bool _loading = true;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    setState(() {
      _loading = true;
      errorMessage = '';
    });

    try {
      // Temporary: add a 2-second delay to test the spinner.
      await Future.delayed(const Duration(seconds: 2));

      final data = await DatabaseHelper.instance.getExpenses();

      double total = 0;

      for (int i = 0; i < data.length; i++) {
        total += data[i].amount;
      }

      if (!mounted) return;

      setState(() {
        expenses = data;
        totalSpent = total;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> addExpense() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await loadExpenses();
    }
  }

  Future<void> editExpense(Expense expense) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(
          expense: expense,
        ),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await loadExpenses();
    }
  }

  Future<void> removeExpense(Expense expense) async {
    if (expense.id == null) return;

    try {
      await DatabaseHelper.instance.deleteExpense(expense.id!);

      if (!mounted) return;

      await loadExpenses();

      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted ${expense.title}'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              try {
                await DatabaseHelper.instance.insertExpense(expense);

                if (!mounted) return;

                await loadExpenses();
              } catch (e) {
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Undo failed: $e')),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),

      body: _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: loadExpenses,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : expenses.isEmpty
                  ? const Center(
                      child: Text(
                        'No expenses yet. Tap + to add one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Total spent',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '₹${totalSpent.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: expenses.length,
                            itemBuilder: (context, index) {
                              final expense = expenses[index];

                              return Card(
                                child: ListTile(
                                  onTap: () {
                                    editExpense(expense);
                                  },
                                  leading: const CircleAvatar(
                                    child: Icon(
                                      Icons.currency_rupee,
                                    ),
                                  ),
                                  title: Text(expense.title),
                                  subtitle: Text(
                                    '${expense.category}\n${expense.date}',
                                  ),
                                  isThreeLine: true,
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '₹${expense.amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          removeExpense(expense);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),

      floatingActionButton: errorMessage.isNotEmpty
          ? null
          : FloatingActionButton(
              onPressed: addExpense,
              child: const Icon(Icons.add),
            ),
    );
  }
}

