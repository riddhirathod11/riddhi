2.<p>Add four buttons above the list: All, Food, Travel and Bills. Each reloads the list with `db.query('expenses', where: 'category = ?', whereArgs: [category])`; All loads 
every row. Give `getExpenses` an optional category parameter. Constraint: Filter inside the query, never with a Dart loop or by joining the category text into the SQL string
.</p>

  
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


