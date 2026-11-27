1.<p>Continue `expense_tracker`: raise `version` to 3 and create a `favorites` table in `onCreate` and in `onUpgrade` (`if (oldVersion < 3)`) with an auto 
primary key `id`, `expense_id INTEGER NOT NULL UNIQUE`, `title`, `amount`, `category` and `saved_on`. Add a `FavoriteItem` model and `addFavorite`,
`removeFavorite(int expenseId)` and `getFavorites()` methods. Test: the Schema screen shows 3 tables. Hint: Missed 6.7? Use your latest working version 2
database.</p>

  
class FavoriteItem {
  int? id;
  int expenseId;
  String title;
  double amount;
  String category;
  String savedOn;

  FavoriteItem({
    this.id,
    required this.expenseId,
    required this.title,
    required this.amount,
    required this.category,
    required this.savedOn,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'expense_id': expenseId,
      'title': title,
      'amount': amount,
      'category': category,
      'saved_on': savedOn,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  static FavoriteItem fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'] as int?,
      expenseId: map['expense_id'] as int,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      savedOn: map['saved_on'] as String,
    );
  }
}
