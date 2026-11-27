4.<p>Open `expense_tracker` and add `insertExpense(Expense e)` to `DatabaseHelper` using `db.insert('expenses', e.toMap())`. Build `add_expense_screen.dart`: a Form with 
title, amount and category fields and a Save button that rejects empty title or category, saves with today's date and pops back. Hint: Missed 6.4? Build a minimal `Expense` 
class and `DatabaseHelper` first. Use `DateTime.now().toIso8601String().substring(0, 10)` for the date.</p>

class Expense {
  int? id;
  String title;
  double amount;
  String category;
  String date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Convert Expense object into Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };
  }
}

