4.<p>Finish `study_planner` by adding a 'Log in' / 'Log out' ElevatedButton on the Settings screen that flips a `loggedIn` bool in `AppSettings`. When logged out, 
  the home screen shows 'Please log in' instead of the Fetch button. Then run this test: log in, fetch tasks, turn dark mode on, hot restart. Everything must reset 
    (logged out, light, no cached tasks); this is the gap local storage will fill. Hint: Read the flag with `context.watch<AppSettings>()` inside `build`.</p>


    
import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {

  bool _isDarkMode = false;
  bool _loggedIn = false;

  bool get isDarkMode => _isDarkMode;
  bool get loggedIn => _loggedIn;

  // Dark Mode
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Login and Logout
  void toggleLogin() {
    _loggedIn = !_loggedIn;
    notifyListeners();
  }
}
