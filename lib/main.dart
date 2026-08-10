import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'features/plants/plants_provider.dart';
import 'theme/theme_data.dart';

void main() {
  runApp(const LeafApp());
}

class LeafApp extends StatelessWidget {
  const LeafApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlantsProvider(),
      child: MaterialApp(
        title: 'Leaf',
        theme: AppTheme.light,
        home: const OnboardingScreen(),
      ),
    );
  }
}
