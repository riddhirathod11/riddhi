3.<p>Add a 'Your name' TextField and a Save button to the Settings screen. Store the trimmed text with `setString` under `student_name`, and show 'Hi, <name>' in
the home AppBar, or 'Hi, Student' when nothing is saved, loaded at launch. Test with 'Kavya Shah', then with only spaces (must not be saved), then restart the app.
Hint: Fill the `TextEditingController` with the saved name in `initState` and call `dispose()` on it.</p>

  
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _loggedIn = false;
  String _studentName = '';

  bool get isDarkMode => _isDarkMode;
  bool get loggedIn => _loggedIn;
  String get studentName => _studentName;

  void loadDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  void loadLoginStatus(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  Future<void> toggleLogin() async {
    _loggedIn = !_loggedIn;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', _loggedIn);
  }

  // Load saved student name
  void loadStudentName(String value) {
    _studentName = value;
    notifyListeners();
  }

  // Save student name
  Future<bool> saveStudentName(String name) async {
    final trimmedName = name.trim();

    // Do not save empty or spaces-only text
    if (trimmedName.isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', trimmedName);

    _studentName = trimmedName;
    notifyListeners();

    return true;
  }
}
