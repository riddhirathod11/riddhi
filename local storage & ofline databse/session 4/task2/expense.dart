2.<p>Add versioning: change `version` to 2 and write an `onUpgrade` that adds a `note TEXT` column to `expenses` with `ALTER TABLE`, update `onCreate` so a
  fresh install also gets `note`, and add `String? note` to `Expense`. Test: run once at version 1, then at version 2; the Schema screen must now list `note`. 
  Hint: `onUpgrade` receives `(db, oldVersion, newVersion)`; use `if (oldVersion < 2)`. Constraint: Do not uninstall the app between the two runs.</p>
    
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

  // Convert Expense object into Map
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

  // Convert Map into Expense object
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
