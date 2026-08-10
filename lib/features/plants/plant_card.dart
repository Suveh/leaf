import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';
import 'plant.dart';

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
              _PlantImagePlaceholder(imagePath: plant.imagePath),
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
                      plant.species,
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (plant.needsWateringToday) ...[
                      const SizedBox(height: 8),
                      const _WateringBadge(),
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

class _PlantImagePlaceholder extends StatelessWidget {
  const _PlantImagePlaceholder({required this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    return Container(
      width: 56,
      height: 56,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.placeholderFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: path == null
          ? const Icon(Icons.local_florist, color: AppColors.primaryGreen)
          : Image.asset(path, fit: BoxFit.cover),
    );
  }
}

class _WateringBadge extends StatelessWidget {
  const _WateringBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.wateringAmber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.water_drop, size: 14, color: AppColors.wateringAmber),
          SizedBox(width: 4),
          Text(
            'Needs watering today',
            style: TextStyle(
              color: AppColors.wateringAmber,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
