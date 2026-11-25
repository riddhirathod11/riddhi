1.<p>Create `lib/models/expense.dart` with a class `Expense` holding `int? id`, `title`, `double amount`, `category` and `date` (text such as 2026-11-02), a `toMap()`
  method and a static `fromMap` method. `toMap()` must leave out `id` when it is null. In `main()`, build an Expense for 'Auto fare', ₹85, 'Travel', convert it to a Map
  and back, and `print` both to the Debug Console. Hint: Cast with `(map['amount'] as num).toDouble()`.</p>

    
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
    final Map<String, dynamic> map = {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
    };

    // Add id only when it is not null
    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // Convert Map into Expense object
  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
    );
  }
}
