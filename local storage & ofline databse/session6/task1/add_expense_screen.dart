
import 'package:flutter/material.dart';
import 'models/expense.dart';
import 'database/database_helper.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    this.expense,
  });

  @override
  State<AddExpenseScreen> createState() =>
      _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedCategory = 'Food';

  final List<String> categories = [
    'Food',
    'Travel',
    'Bills',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      titleController.text = widget.expense!.title;
      amountController.text =
          widget.expense!.amount.toString();
      selectedCategory = widget.expense!.category;
      noteController.text = widget.expense!.note ?? '';
    }
  }

  // Save or update expense
  Future<void> saveExpense() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(
      amountController.text.trim(),
    );

    final expense = Expense(
      id: widget.expense?.id,
      title: titleController.text.trim(),
      amount: amount,
      category: selectedCategory,
      date: widget.expense?.date ??
          DateTime.now().toIso8601String().substring(0, 10),
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
    );

    if (widget.expense == null) {
      await DatabaseHelper.instance.insertExpense(expense);
    } else {
      await DatabaseHelper.instance.updateExpense(expense);
    }

    if (!mounted) return;

    Navigator.pop(context, true);
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
        title: Text(
          widget.expense == null
              ? 'Add Expense'
              : 'Edit Expense',
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Expense Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please enter amount';
                  }

                  final amount =
                      double.tryParse(value.trim());

                  if (amount == null ||
                      !amount.isFinite ||
                      amount <= 0) {
                    return 'Enter a valid amount';
                  }

                  if (amount > 100000) {
                    return 'Amount cannot exceed ₹100000';
                  }

                  return null;
                },
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
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'Please select category';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveExpense,
                  child: Text(
                    widget.expense == null
                        ? 'Save Expense'
                        : 'Update Expense',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
