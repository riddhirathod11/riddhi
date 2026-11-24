
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_settings.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance
  final prefs = await SharedPreferences.getInstance();

  // Load saved preferences
  final bool savedDarkMode =
      prefs.getBool('dark_mode') ?? false;

  final bool savedLoginStatus =
      prefs.getBool('logged_in') ?? false;

  final String savedStudentName =
      prefs.getString('student_name') ?? '';

  // Create AppSettings object
  final settings = AppSettings();

  // Load saved values
  settings.loadDarkMode(savedDarkMode);
  settings.loadLoginStatus(savedLoginStatus);
  settings.loadStudentName(savedStudentName);

  runApp(
    ChangeNotifierProvider(
      create: (context) => settings,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Study Planner',

          // Light Theme
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.light,
            ),
          ),

          // Dark Theme
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
          ),

          // Apply selected theme
          themeMode: settings.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          home: const HomeScreen(),
        );
      },
    );
  }
}
