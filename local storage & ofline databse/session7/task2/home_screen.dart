2.<p>Wrap the database call in your home screen's load method in try-catch. On failure, show the error text and a Retry button instead of the list. Test: change
the table name in `getExpenses` to `expensez` to trigger the error, then fix it, hot reload and press Retry; the list must return. Hint: Missed 6.6? Build the list 
screen with add, edit and delete first. Use `catch (e)` and check `mounted` before `setState`.</p>

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
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final data = await DatabaseHelper.instance.getExpenses();

      double total = 0;
      for (int i = 0; i < data.length; i++) {
        total += data[i].amount;
      }

      if (!mounted) return;

      setState(() {
        expenses = data;
        totalSpent = total;
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
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
        builder: (context) => AddExpenseScreen(expense: expense),
      ),
    );

    if (!mounted) return;

    if (result == true) {
      await loadExpenses();
    }
  }

  Future<void> removeExpense(Expense expense) async {
    if (expense.id == null) return;

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
            await DatabaseHelper.instance.insertExpense(expense);

            if (!mounted) return;

            await loadExpenses();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: isLoading
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
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 50,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Something went wrong!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: loadExpenses,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
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
                      child: expenses.isEmpty
                          ? const Center(
                              child: Text('No expenses found'),
                            )
                          : ListView.builder(
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



