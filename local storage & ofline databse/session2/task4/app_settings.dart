4.<p>Finish `study_planner` by adding a 'Reset preferences' OutlinedButton that calls `remove` for `dark_mode`, `logged_in` and `student_name`, and returns the
screen at once to light, logged out and 'Hi, Student'. Test: dark on, log in, save 'Kavya Shah', stop and run (all persist); press Reset, stop and run (all defaults)
. Constraint: Do not use `clear()`.</p>

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _loggedIn = false;
  String _studentName = '';

  bool get isDarkMode => _isDarkMode;
  bool get loggedIn => _loggedIn;
  String get studentName => _studentName;

  // Load Dark Mode
  void loadDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Save Dark Mode
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  // Load Login Status
  void loadLoginStatus(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  // Save Login / Logout
  Future<void> toggleLogin() async {
    _loggedIn = !_loggedIn;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', _loggedIn);
  }

  // Load Student Name
  void loadStudentName(String value) {
    _studentName = value;
    notifyListeners();
  }

  // Save Student Name
  Future<bool> saveStudentName(String name) async {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('student_name', trimmedName);

    _studentName = trimmedName;
    notifyListeners();

    return true;
  }

  // Reset All Preferences
  Future<void> resetPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('dark_mode');
    await prefs.remove('logged_in');
    await prefs.remove('student_name');

    _isDarkMode = false;
    _loggedIn = false;
    _studentName = '';

    notifyListeners();
  }
}

