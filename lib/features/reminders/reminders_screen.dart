import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/theme_data.dart';
import '../plants/plant.dart';
import '../plants/plant_image_placeholder.dart';
import '../plants/plants_provider.dart';
import '../plants/watering_status.dart';

/// Every plant sorted by next watering date, soonest first, with a quick
/// action to mark a plant as watered today.
class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watering Schedule')),
      body: const _ReminderList(),
    );
  }
}

class _ReminderList extends StatelessWidget {
  const _ReminderList();

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantsProvider>(
      builder: (context, plantsProvider, _) {
        final plants = [...plantsProvider.plants]
          ..sort(
            (a, b) => a.nextWateringDate.compareTo(b.nextWateringDate),
          );

        if (plants.isEmpty) {
          return const Center(child: Text('No plants to water yet.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: plants.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _ReminderTile(plant: plants[index]),
        );
      },
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final status = WateringStatus.of(plant.nextWateringDate);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            PlantImagePlaceholder(imagePath: plant.imagePath),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.deepGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  WateringStatusBadge(status: status),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Mark as watered today',
              icon: const Icon(Icons.water_drop_outlined),
              color: AppColors.primaryGreen,
              onPressed: () {
                context.read<PlantsProvider>().markAsWateredToday(plant.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
