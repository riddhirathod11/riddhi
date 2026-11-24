3.<p>Add a Settings screen (`settings_screen.dart`) to `study_planner`, opened from an AppBar icon, with a 'Dark mode' Switch that changes the whole app at once. Keep the 
value in a `ChangeNotifier` class `AppSettings` shared with the `provider` package. Test: turn dark mode on, go back (home is dark too), then hot restart; the app must be
light again. Hint: Wrap `MaterialApp` in a `Consumer<AppSettings>` and set its `themeMode`, `theme` and `darkTheme`.</p>


import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}
