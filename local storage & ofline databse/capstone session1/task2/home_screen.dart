2.<p>Add a star IconButton to each expense row (`Icons.star` when saved, `Icons.star_border` when not) that saves or removes that expense through your favorites 
methods. Load the saved expense ids into a `Set<int>` together with the list so each star shows the right state. Test: star 3 expenses, stop and run again; the 
same 3 stars must still be filled. Constraint: Do not add an `is_favorite` column to `expenses`.</p>


import 'package:flutter/material.dart';

import 'models/expense.dart';
import 'models/favorite_item.dart';
import 'database/database_helper.dart';
import 'add_expense_screen.dart';
import 'schema_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];

  Set<int> favoriteIds = {};

  double totalSpent = 0;

  bool _loading = true;

  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // LOAD EXPENSES AND FAVORITES
  Future<void> loadExpenses() async {
    setState(() {
      _loading = true;
      errorMessage = '';
    });

    try {
      final data = await DatabaseHelper.instance.getExpenses();

      final favorites =
          await DatabaseHelper.instance.getFavorites();

      double total = 0;

      for (int i = 0; i < data.length; i++) {
        total += data[i].amount;
      }

      Set<int> savedIds = {};

      for (int i = 0; i < favorites.length; i++) {
        savedIds.add(favorites[i].expenseId);
      }

      if (!mounted) return;

      setState(() {
        expenses = data;
        favoriteIds = savedIds;
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

  // ADD OR REMOVE FAVORITE
  Future<void> toggleFavorite(Expense expense) async {
    if (expense.id == null) return;

    int expenseId = expense.id!;

    try {
      if (favoriteIds.contains(expenseId)) {
        await DatabaseHelper.instance.removeFavorite(expenseId);

        if (!mounted) return;

        setState(() {
          favoriteIds.remove(expenseId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${expense.title} removed from favorites'),
          ),
        );
      } else {
        final favorite = FavoriteItem(
          expenseId: expenseId,
          title: expense.title,
          amount: expense.amount,
          category: expense.category,
          savedOn: DateTime.now().toIso8601String(),
        );

        await DatabaseHelper.instance.addFavorite(favorite);

        if (!mounted) return;

        setState(() {
          favoriteIds.add(expenseId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${expense.title} added to favorites'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Favorite error: $e'),
        ),
      );
    }
  }

  // ADD EXPENSE
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

  // EDIT EXPENSE
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

  // DELETE EXPENSE
  Future<void> removeExpense(Expense expense) async {
    if (expense.id == null) return;

    try {
      await DatabaseHelper.instance.deleteExpense(expense.id!);

      if (!mounted) return;

      await loadExpenses();

      if (!mounted) return;

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
                  SnackBar(
                    content: Text('Undo failed: $e'),
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Delete failed: $e'),
        ),
      );
    }
  }

  // OPEN SCHEMA SCREEN
  Future<void> openSchema() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SchemaScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: openSchema,
            icon: const Icon(Icons.storage),
            tooltip: 'View Database Schema',
          ),
        ],
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

                              final bool isFavorite =
                                  expense.id != null &&
                                  favoriteIds.contains(expense.id);

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

                                      // FAVORITE STAR BUTTON
                                      IconButton(
                                        icon: Icon(
                                          isFavorite
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: isFavorite
                                              ? Colors.amber
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          toggleFavorite(expense);
                                        },
                                      ),

                                      // DELETE BUTTON
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
