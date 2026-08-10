import 'package:flutter/material.dart';

import '../../shared/coming_soon_placeholder.dart';

/// Placeholder Settings tab — real settings come later.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const ComingSoonPlaceholder(
        icon: Icons.settings_outlined,
        message: 'Settings are coming soon',
      ),
    );
  }
}
