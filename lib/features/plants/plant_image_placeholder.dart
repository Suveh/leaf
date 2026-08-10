import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';

/// Square placeholder shown in place of a plant's photo until the photo
/// picker is implemented.
class PlantImagePlaceholder extends StatelessWidget {
  const PlantImagePlaceholder({
    super.key,
    required this.imagePath,
    this.size = 56,
  });

  final String? imagePath;
  final double size;

  @override
  Widget build(BuildContext context) {
    final path = imagePath;

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.placeholderFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: path == null
          ? Icon(
              Icons.local_florist,
              color: AppColors.primaryGreen,
              size: size * 0.5,
            )
          : Image.asset(path, fit: BoxFit.cover),
    );
  }
}
