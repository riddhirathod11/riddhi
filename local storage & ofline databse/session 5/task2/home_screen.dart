
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

  String selectedCategory = 'All';
  bool isLoading = true;

  final List<String> categories = [
    'All',
    'Food',
    'Travel',
    'Bills',
  ];

  @override
  void initState() {
    super.initState();
    loadExpenses();
  }

  // Load expenses from database
  Future<void> loadExpenses({String? category}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await DatabaseHelper.instance.getExpenses(
        category: category,
      );

      if (!mounted) return;

      setState(() {
        expenses = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading expenses: $e')),
      );
    }
  }

  // Change category
  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    loadExpenses(
      category: category == 'All' ? null : category,
    );
  }

  // Open Add Expense screen
  Future<void> openAddScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(),
      ),
    );

    if (!mounted) return;

    loadExpenses(
      category: selectedCategory == 'All'
          ? null
          : selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: categories.map((category) {
                final isSelected =
                    selectedCategory == category;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        changeCategory(category);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected
                            ? Colors.deepPurple
                            : Colors.grey.shade200,
                        foregroundColor: isSelected
                            ? Colors.white
                            : Colors.black,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Expense list
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : expenses.isEmpty
                    ? const Center(
                        child: Text(
                          'No expenses found',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: expenses.length,
                        itemBuilder: (context, index) {
                          final expense = expenses[index];

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.currency_rupee),
                              ),
                              title: Text(
                                expense.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${expense.category}\n${expense.date}',
                              ),
                              isThreeLine: true,
                              trailing: Text(
                                '₹${expense.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
