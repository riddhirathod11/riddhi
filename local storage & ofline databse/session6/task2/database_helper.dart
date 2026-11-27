2.<p>Continue `expense_tracker`: add `updateExpense(Expense e)` to `DatabaseHelper` using `db.update` with `where: 'id = ?'` and `whereArgs: [e.id]`, and let
`add_expense_screen.dart` accept an optional `Expense` so tapping a list row opens it pre-filled. Test: change 'Auto fare' from ₹85 to ₹95; the row updates at once 
and keeps its id. Hint: Missed 6.5? Build the list and Add screen first. Fill controllers in `initState` and dispose them.</p>

// Update expense
Future<int> updateExpense(Expense e) async {
  final db = await database;

  return await db.update(
    'expenses',
    e.toMap(),
    where: 'id = ?',
    whereArgs: [e.id],
  );
}
