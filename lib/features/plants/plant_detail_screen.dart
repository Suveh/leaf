import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../camera_log/photo_log_screen.dart';
import 'add_edit_plant_screen.dart';
import 'plant.dart';
import 'plant_image_placeholder.dart';
import 'plants_provider.dart';
import 'watering_status.dart';

Plant? _findPlant(List<Plant> plants, String id) {
  for (final plant in plants) {
    if (plant.id == id) return plant;
  }
  return null;
}

/// Read-only overview of a single plant, reached by tapping its card in the
/// plant list. Looks the plant up live from [PlantsProvider] by id so edits
/// or waterings made elsewhere are reflected immediately.
class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key, required this.plantId});

  final String plantId;

  @override
  Widget build(BuildContext context) {
    return Selector<PlantsProvider, Plant?>(
      selector: (_, provider) => _findPlant(provider.plants, plantId),
      builder: (context, plant, _) {
        if (plant == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Plant')),
            body: const Center(child: Text('This plant was removed.')),
          );
        }
        return _PlantDetailBody(plant: plant);
      },
    );
  }
}

class _PlantDetailBody extends StatelessWidget {
  const _PlantDetailBody({required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    final status = WateringStatus.of(plant.nextWateringDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
        actions: [
          IconButton(
            tooltip: 'Edit plant',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddEditPlantScreen(plant: plant),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: PlantImagePlaceholder(
                  imagePath: plant.imagePath,
                  size: 120,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                plant.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                plant.species,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Center(child: WateringStatusBadge(status: status)),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PhotoLogScreen(
                        plantId: plant.id,
                        plantName: plant.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('View Photos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
