import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';
import 'plant.dart';
import 'plant_image_placeholder.dart';
import 'watering_status.dart';

/// A single plant summary card shown in the plant list.
class PlantCard extends StatelessWidget {
  const PlantCard({super.key, required this.plant, this.onTap});

  final Plant plant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
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
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.deepGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.species ?? 'Unknown species',
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (plant.needsWateringToday) ...[
                      const SizedBox(height: 8),
                      WateringStatusBadge(
                        status: WateringStatus.of(plant.nextWateringDate),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.soilBrown),
            ],
          ),
        ),
      ),
    );
  }
}

