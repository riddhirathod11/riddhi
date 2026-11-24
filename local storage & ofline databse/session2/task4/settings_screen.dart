
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController nameController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    final settings = context.read<AppSettings>();
    nameController.text = settings.studentName;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> saveName() async {
    final saved = await context
        .read<AppSettings>()
        .saveStudentName(nameController.text);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          saved ? 'Name saved successfully' : 'Please enter your name',
        ),
      ),
    );
  }

  Future<void> resetAllPreferences() async {
    await context.read<AppSettings>().resetPreferences();

    if (!mounted) return;

    nameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All preferences reset successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: settings.isDarkMode,
              onChanged: (value) {
                context
                    .read<AppSettings>()
                    .toggleDarkMode(value);
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: saveName,
              child: const Text('Save'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                context.read<AppSettings>().toggleLogin();
              },
              child: Text(
                settings.loggedIn ? 'Log out' : 'Log in',
              ),
            ),

            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: resetAllPreferences,
              child: const Text('Reset preferences'),
            ),
          ],
        ),
      ),
    );
  }
}
