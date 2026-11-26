
import 'package:flutter/material.dart';
import 'models/expense.dart';
import 'database/database_helper.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = 'Food';

  final List<String> categories = [
    'Food',
    'Travel',
    'Bills',
  ];

  DateTime selectedDate = DateTime.now();

  // Save expense with validation
  Future<void> saveExpense() async {
    final title = titleController.text.trim();
    final amountText = amountController.text.trim();

    if (title.isEmpty) {
      showError('Please enter expense title');
      return;
    }

    if (amountText.isEmpty) {
      showError('Please enter amount');
      return;
    }

    final double? amount = double.tryParse(amountText);

    if (amount == null || !amount.isFinite) {
      showError('Please enter a valid number');
      return;
    }

    if (amount < 0) {
      showError('Amount cannot be negative');
      return;
    }

    if (amount == 0) {
      showError('Amount must be greater than 0');
      return;
    }

    if (amount > 100000) {
      showError('Amount cannot exceed ₹100000');
      return;
    }

    final expense = Expense(
      title: title,
      amount: amount,
      category: selectedCategory,
      date: selectedDate.toIso8601String().split('T').first,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
    );

    try {
      await DatabaseHelper.instance.insertExpense(expense);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense added successfully'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      showError('Error saving expense: $e');
    }
  }

  // Show error message
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Expense Title',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Expense Date'),
              subtitle: Text(
                selectedDate.toIso8601String().split('T').first,
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                );

                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveExpense,
                child: const Text('Save Expense'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
