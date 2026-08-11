import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_model.dart';

/// Basic settings toggles. No persistence yet — values reset each app
/// launch, and dark mode is a visual toggle only (not wired to a real
/// theme switch).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsModel(),
      child: const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  const _SettingsBody();

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Notifications'),
            subtitle: const Text('Get reminders when a plant needs care'),
            value: settings.notificationsEnabled,
            onChanged: settings.setNotificationsEnabled,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark Mode'),
            subtitle: const Text('Not available yet — display only'),
            value: settings.darkModeEnabled,
            onChanged: settings.setDarkModeEnabled,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.straighten_outlined),
            title: const Text('Use Imperial Units'),
            subtitle: Text(
              settings.useImperialUnits
                  ? 'Inches, gallons, °F'
                  : 'Centimeters, liters, °C',
            ),
            value: settings.useImperialUnits,
            onChanged: settings.setUseImperialUnits,
          ),
        ],
      ),
    );
  }
}
