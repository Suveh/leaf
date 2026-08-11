import 'package:flutter/material.dart';

import '../../theme/theme_data.dart';

enum WateringUrgency { overdue, dueToday, upcoming }

/// Human-readable watering urgency derived from a plant's next watering
/// date, shared by the plant card, plant detail, and reminders screens so
/// the label/color logic lives in one place.
class WateringStatus {
  const WateringStatus({required this.urgency, required this.label});

  final WateringUrgency urgency;
  final String label;

  factory WateringStatus.of(DateTime nextWateringDate) {
    final today = _dateOnly(DateTime.now());
    final due = _dateOnly(nextWateringDate);
    final dayDiff = due.difference(today).inDays;

    if (dayDiff < 0) {
      final daysOverdue = -dayDiff;
      return WateringStatus(
        urgency: WateringUrgency.overdue,
        label: daysOverdue == 1
            ? 'Overdue by 1 day'
            : 'Overdue by $daysOverdue days',
      );
    }
    if (dayDiff == 0) {
      return const WateringStatus(
        urgency: WateringUrgency.dueToday,
        label: 'Needs watering today',
      );
    }
    return WateringStatus(
      urgency: WateringUrgency.upcoming,
      label: dayDiff == 1 ? 'Watering in 1 day' : 'Watering in $dayDiff days',
    );
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Color get color {
    switch (urgency) {
      case WateringUrgency.overdue:
        return AppColors.overdueRed;
      case WateringUrgency.dueToday:
        return AppColors.wateringAmber;
      case WateringUrgency.upcoming:
        return AppColors.soilBrown;
    }
  }
}

/// Pill badge showing a plant's watering urgency label in its status color.
class WateringStatusBadge extends StatelessWidget {
  const WateringStatusBadge({super.key, required this.status});

  final WateringStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.urgency == WateringUrgency.overdue
                ? Icons.warning_amber_rounded
                : Icons.water_drop,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
