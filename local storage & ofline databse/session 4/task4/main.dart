
import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'schema_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = 'Opening database...';

  @override
  void initState() {
    super.initState();
    openDatabase();
  }

  Future<void> openDatabase() async {
    await DatabaseHelper.instance.database;

    if (!mounted) return;

    setState(() {
      message = 'Database ready';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SchemaScreen(),
                  ),
                );
              },
              child: const Text('View Database Schema'),
            ),
          ],
        ),
      ),
    );
  }
}
