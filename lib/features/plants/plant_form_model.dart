import 'package:flutter/material.dart';

import 'plant.dart';

/// Holds local form state for the add/edit plant screen. No backend logic —
/// the photo picker is a UI stub and saving only updates the in-memory
/// [PlantsProvider] list.
class PlantFormModel extends ChangeNotifier {
  PlantFormModel({Plant? initial})
    : nameController = TextEditingController(text: initial?.name),
      speciesController = TextEditingController(text: initial?.species),
      _hasPhoto = initial?.imagePath != null;

  final TextEditingController nameController;
  final TextEditingController speciesController;

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
    super.dispose();
  }
}
