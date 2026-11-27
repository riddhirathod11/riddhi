3.<p>Add a delete IconButton to each row. It calls `deleteExpense(int id)` in `DatabaseHelper` (`db.delete` with `where: 'id = ?'`), reloads the list and 
shows a SnackBar 'Deleted <title>' with an UNDO action that puts the same row back with `insertExpense`. Test: delete an expense and press UNDO; it returns with 
the same id. Hint: `ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: ..., action: SnackBarAction(label: 'UNDO', onPressed: ...)))`.</p>

  // Delete expense
Future<int> deleteExpense(int id) async {
  final db = await database;

  return await db.delete(
    'expenses',
    where: 'id = ?',
    whereArgs: [id],
  );
}
