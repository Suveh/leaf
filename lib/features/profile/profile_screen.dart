import 'package:flutter/material.dart';

import '../../shared/coming_soon_placeholder.dart';

/// Placeholder Profile tab — full profile management comes later.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const ComingSoonPlaceholder(
        icon: Icons.person_outline,
        message: 'Your profile is coming soon',
      ),
    );
  }
}
