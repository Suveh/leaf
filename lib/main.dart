import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/onboarding/onboarding_screen.dart';
import 'features/plants/plants_provider.dart';
import 'theme/theme_data.dart';

void main() {
  runApp(const LeafApp());
}

class LeafApp extends StatelessWidget {
  /// [plantsProvider] lets tests inject a [PlantsProvider] backed by a fake
  /// API service instead of hitting the real backend over HTTP.
  const LeafApp({super.key, this.plantsProvider});

  final PlantsProvider? plantsProvider;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => plantsProvider ?? PlantsProvider(),
      child: MaterialApp(
        title: 'Leaf',
        theme: AppTheme.light,
        home: const OnboardingScreen(),
      ),
    );
  }
}
