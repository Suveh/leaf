import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';
import '../onboarding/onboarding_screen.dart';

/// Dummy profile — no real account system yet. "Log Out" just resets
/// navigation back to onboarding.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _dummyName = 'Ivy Gardener';
  static const _dummyEmail = 'ivy.gardener@example.com';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.placeholderFill,
                foregroundColor: AppColors.primaryGreen,
                child: Icon(Icons.person, size: 48),
              ),
              const SizedBox(height: 16),
              Text(
                _dummyName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                _dummyEmail,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              OutlinedButton.icon(
                onPressed: () => _logOut(context),
                icon: const Icon(Icons.logout),
                label: const Text('Log Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logOut(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (route) => false,
    );
  }
}
