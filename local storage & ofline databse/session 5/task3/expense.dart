3.<p>Finish the feature by hardening the amount field: reject empty text, `abc`, 0, negative numbers and amounts above 100000, each with its own error message. Then save
  8 expenses of your own (at least 2 each in Food, Travel and Bills; ₹20 to ₹5,000), stop and run the app again; all 8 rows and each filter must still work. Submit 
  `expense_tracker`. Hint: `double.tryParse('abc')` returns null.</p>


    
class Expense {
  int? id;
  String title;
  double amount;
  String category;
  String date;
  String? note;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  // Convert object into Map
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'note': note,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // Convert Map into object
  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
      note: map['note'] as String?,
    );
  }
}
