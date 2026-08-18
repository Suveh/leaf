import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_data.dart';
import 'add_edit_plant_screen.dart';
import 'plant.dart';
import 'plant_card.dart';
import 'plant_detail_screen.dart';
import 'plants_provider.dart';

/// Shows every plant the user is tracking as a list of cards.
class PlantListScreen extends StatelessWidget {
  const PlantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Plants')),
      body: const _PlantList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEditPlantScreen()),
          );
        },
        tooltip: 'Add Plant',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _PlantList extends StatelessWidget {
  const _PlantList();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantsProvider>(
      builder: (context, plantsProvider, _) {
        final plants = plantsProvider.plants;

        if (plantsProvider.isLoading && plants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (plantsProvider.errorMessage != null && plants.isEmpty) {
          return _ErrorState(
            message: plantsProvider.errorMessage!,
            onRetry: plantsProvider.loadPlants,
          );
        }

        if (plants.isEmpty) {
          return const Center(child: Text('No plants yet. Add your first!'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: plants.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final plant = plants[index];
            return PlantCard(
              plant: plant,
              onTap: () => _openDetail(context, plant),
            );
          },
        );
      },
    );
  }

  void _openDetail(BuildContext context, Plant plant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlantDetailScreen(plantId: plant.id),
      ),
    );
  }
}

/// Shown when fetching the plant list from the backend fails (e.g. it isn't
/// running), with a retry action.
class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 40,
              color: AppColors.overdueRed,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
