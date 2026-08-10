import 'package:flutter/material.dart';

import '../theme/theme_data.dart';

/// Centered icon + message used by screens that don't have real content
/// yet (e.g. Profile, Settings).
class ComingSoonPlaceholder extends StatelessWidget {
  const ComingSoonPlaceholder({
    super.key,
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: AppColors.leafGreen),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.soilBrown)),
        ],
      ),
    );
  }
}
