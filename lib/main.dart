import 'package:flutter/material.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'theme/theme_data.dart';

void main() {
  runApp(const LeafApp());
}

class LeafApp extends StatelessWidget {
  const LeafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leaf',
      theme: AppTheme.light,
      home: const OnboardingScreen(),
    );
  }
}
