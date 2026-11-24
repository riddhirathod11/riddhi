
import 'package:flutter/material.dart';

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
  List<String> _cachedTasks = [];

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

        if (_cachedTasks.isNotEmpty) {
          tasks = List.from(_cachedTasks);
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
      tasks.clear();
      isOfflineCache = false;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    setState(() {
      tasks = List.from(allTasks);
      _cachedTasks = List.from(tasks);

      isLoading = false;
      isOfflineCache = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Planner'),

        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SettingsScreen(),
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

            Card(
              child: SwitchListTile(
                title: const Text('Internet available'),
                value: internetAvailable,

                onChanged: (value) {
                  setState(() {
                    internetAvailable = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: isLoading ? null : fetchTasks,
                child: const Text('Fetch my tasks'),
              ),
            ),

            const SizedBox(height: 20),

            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )

            else if (isOfflineCache)
              Expanded(
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Offline: showing last copy',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: buildTaskList(),
                    ),
                  ],
                ),
              )

            else if (!internetAvailable && tasks.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No internet and no saved data',
                    textAlign: TextAlign.center,
                  ),
                ),
              )

            else if (tasks.isNotEmpty)
              Expanded(
                child: buildTaskList(),
              )

            else
              const Expanded(
                child: Center(
                  child: Text('Press Fetch my tasks'),
                ),
              ),
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
          child: ListTile(
            leading: CircleAvatar(
              child: Text('${index + 1}'),
            ),
            title: Text(tasks[index]),
            trailing: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ),
        );
      },
    );
  }
}
