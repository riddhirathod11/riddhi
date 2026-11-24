
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

            // Dark Mode Switch
            Card(
              child: SwitchListTile(
                title: const Text(
                  'Dark mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: const Text(
                  'Change app appearance',
                ),

                secondary: const Icon(
                  Icons.dark_mode,
                ),

                value: settings.isDarkMode,

                onChanged: (value) {
                  context
                      .read<AppSettings>()
                      .toggleDarkMode(value);
                },
              ),
            ),

            const SizedBox(height: 20),

            // Login / Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<AppSettings>()
                      .toggleLogin();
                },

                child: Text(
                  settings.loggedIn
                      ? 'Log out'
                      : 'Log in',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
