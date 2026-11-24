
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
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

            ElevatedButton(
              onPressed: () {
                context.read<AppSettings>().toggleLogin();
              },
              child: Text(
                settings.loggedIn ? 'Log out' : 'Log in',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
