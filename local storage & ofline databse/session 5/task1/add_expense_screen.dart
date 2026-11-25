
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
  final categoryController = TextEditingController();
  final noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> saveExpense() async {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim());
    final category = categoryController.text.trim();

    if (title.isEmpty || amount == null || amount <= 0 ||
        category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid expense details'),
        ),
      );
      return;
    }

    final expense = Expense(
      title: title,
      amount: amount,
      category: category,
      date: selectedDate.toIso8601String().split('T').first,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
    );

    await DatabaseHelper.instance.insertExpense(expense);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
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
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
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
