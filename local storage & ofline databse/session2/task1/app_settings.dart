1.<p>Add the \`shared_preferences\` package to \`study_planner\` and make the dark mode Switch survive restarts: save it with \`setBool\` under the key \`dark_mode\` and 
read it in \`main()\` before \`runApp\`, defaulting to light. Test: turn dark mode on, stop the app, run it again; it must open dark. Hint: Missed 6.1? First build a Switch
in an \`AppSettings\` ChangeNotifier. Call \`WidgetsFlutterBinding.ensureInitialized()\` first, make \`main\` \`async\`, and use \`getBool('dark_mode') ?? false\`.\</p>
  
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _loggedIn = false;

  bool get isDarkMode => _isDarkMode;
  bool get loggedIn => _loggedIn;

  // Load saved dark mode
  void loadDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  // Save dark mode
  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', value);
  }

  // Login / Logout
  void toggleLogin() {
    _loggedIn = !_loggedIn;
    notifyListeners();
  }
}
