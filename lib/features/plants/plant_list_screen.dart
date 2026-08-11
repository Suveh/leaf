import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
