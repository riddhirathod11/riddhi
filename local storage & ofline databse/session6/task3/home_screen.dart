
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

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // Load expenses and total
  Future<void> loadExpenses() async {
    try {
      final data =
          await DatabaseHelper.instance.getExpenses();

      final total =
          await DatabaseHelper.instance.getTotalSpent();

      if (!mounted) return;

      setState(() {
        expenses = data;
        totalSpent = total;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading expenses: $e'),
        ),
      );
    }
  }

  // Add expense
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

  // Edit expense
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

  // Delete expense and Undo
  Future<void> removeExpense(Expense expense) async {
    if (expense.id == null) return;

    // Delete from database
    await DatabaseHelper.instance.deleteExpense(
      expense.id!,
    );

    if (!mounted) return;

    // Refresh list and total
    await loadExpenses();

    if (!mounted) return;

    // Show SnackBar with Undo
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Deleted ${expense.title}'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () async {
            // Restore the same expense with original ID
            await DatabaseHelper.instance.insertExpense(
              expense,
            );

            if (!mounted) return;

            // Refresh list and total
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
          : Column(
              children: [
                // Total spent header
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

                // Expense list
                Expanded(
                  child: expenses.isEmpty
                      ? const Center(
                          child: Text('No expenses found'),
                        )
                      : ListView.builder(
                          itemCount: expenses.length,
                          padding: const EdgeInsets.all(12),
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

                                    // Delete button
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

      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
