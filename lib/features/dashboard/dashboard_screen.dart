import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_data.dart';
import '../plants/plants_provider.dart';

/// Home tab: a quick summary of the user's plants and a way to jump into
/// the full plant list.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onViewPlants});

  final VoidCallback onViewPlants;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SummaryCard(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onViewPlants,
                icon: const Icon(Icons.local_florist_outlined),
                label: const Text('View My Plants'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Selector<PlantsProvider, (int total, int needsWatering)>(
      selector: (_, provider) =>
          (provider.totalCount, provider.needsWateringCount),
      builder: (context, counts, _) {
        final (total, needsWatering) = counts;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.eco,
                  size: 40,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _plantsSummary(total),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppColors.deepGreen,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _wateringSummary(needsWatering),
                        style: TextStyle(
                          color: needsWatering > 0
                              ? AppColors.wateringAmber
                              : AppColors.soilBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _plantsSummary(int total) =>
      total == 1 ? '1 plant' : '$total plants';

  String _wateringSummary(int needsWatering) {
    if (needsWatering == 0) return 'All watered up today';
    return needsWatering == 1
        ? '1 needs watering today'
        : '$needsWatering need watering today';
  }
}
