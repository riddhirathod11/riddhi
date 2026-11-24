
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool internetAvailable = true;
  bool isLoading = false;
  bool isOfflineCache = false;

  List<String> tasks = [];
  List<String> cachedTasks = [];

  final List<String> allTasks = [
    'Maths - Trigonometry - 45 min',
    'Science - Physics - 30 min',
    'English - Grammar - 40 min',
    'Flutter - Dart Programming - 60 min',
    'Computer - Database - 35 min',
    'Gujarati - Reading - 20 min',
  ];

  Future<void> fetchTasks() async {
    if (!internetAvailable) {
      setState(() {
        isLoading = false;

        if (cachedTasks.isNotEmpty) {
          tasks = List.from(cachedTasks);
          isOfflineCache = true;
        } else {
          tasks.clear();
          isOfflineCache = false;
        }
      });
      return;
    }

    setState(() {
      isLoading = true;
      isOfflineCache = false;
      tasks.clear();
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      tasks = List.from(allTasks);
      cachedTasks = List.from(allTasks);
      isLoading = false;
      isOfflineCache = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    final String studentName = settings.studentName.isEmpty
        ? 'Student'
        : settings.studentName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $studentName'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            if (!settings.loggedIn)
              const Expanded(
                child: Center(
                  child: Text(
                    'Please log in',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else ...[
              SwitchListTile(
                title: const Text('Internet available'),
                value: internetAvailable,
                onChanged: (value) {
                  setState(() {
                    internetAvailable = value;
                  });
                },
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : fetchTasks,
                  child: const Text('Fetch my tasks'),
                ),
              ),

              const SizedBox(height: 15),

              if (isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (isOfflineCache) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Offline: showing last copy',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(child: buildTaskList()),
              ]
              else if (tasks.isNotEmpty)
                Expanded(child: buildTaskList())
              else if (!internetAvailable && cachedTasks.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No internet and no saved data',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                const Expanded(
                  child: Center(
                    child: Text(
                      'Tap Fetch my tasks to load your study tasks',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildTaskList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(tasks[index]),
            trailing: const Icon(Icons.book_outlined),
          ),
        );
      },
    );
  }
}
