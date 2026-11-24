2.<p>Make login status persistent in `study_planner`: save `loggedIn` with `setBool` under the key `logged_in` whenever the Log in / Log out button is pressed,
and load it in `main()` before `runApp`. Test: log in, stop and run again (still logged in), then log out, stop and run again ('Please log in' appears).
Constraint: Do not read SharedPreferences inside `build()`.</p>

  
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _loggedIn = false;

  bool get isDarkMode => _isDarkMode;
  bool get loggedIn => _loggedIn;

  // Load saved Dark Mode
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

  // Load saved Login status
  void loadLoginStatus(bool value) {
    _loggedIn = value;
    notifyListeners();
  }

  // Save Login / Logout status
  Future<void> toggleLogin() async {
    _loggedIn = !_loggedIn;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', _loggedIn);
  }
}
