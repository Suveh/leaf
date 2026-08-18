import 'package:flutter/material.dart';

import 'plant.dart';

/// Default watering interval offered to a new plant when the form is
/// blank. Matches the default used elsewhere before a real value is set.
const defaultWateringIntervalDays = 7;

/// Holds local form state for the add/edit plant screen. The photo picker
/// is still a UI stub — saving submits the other fields to the backend via
/// [PlantsProvider].
class PlantFormModel extends ChangeNotifier {
  PlantFormModel({Plant? initial})
    : nameController = TextEditingController(text: initial?.name),
      speciesController = TextEditingController(text: initial?.species),
      wateringFrequencyDaysController = TextEditingController(
        text: (initial?.wateringFrequencyDays ?? defaultWateringIntervalDays)
            .toString(),
      ),
      _hasPhoto = initial?.imagePath != null;

  final TextEditingController nameController;
  final TextEditingController speciesController;
  final TextEditingController wateringFrequencyDaysController;

  bool _hasPhoto;
  bool get hasPhoto => _hasPhoto;

  void pickPhoto() {
    _hasPhoto = true;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    speciesController.dispose();
    wateringFrequencyDaysController.dispose();
    super.dispose();
  }
}
