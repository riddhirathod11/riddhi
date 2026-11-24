
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

        child: Card(
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

            value: settings.isDarkMode,

            onChanged: (value) {
              context
                  .read<AppSettings>()
                  .toggleDarkMode(value);
            },

            secondary: const Icon(
              Icons.dark_mode,
            ),
          ),
        ),
      ),
    );
  }
}
