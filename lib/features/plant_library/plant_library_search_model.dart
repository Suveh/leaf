import 'package:flutter/material.dart';

import 'plant_library_entry.dart';

/// Holds the search query for the plant library and derives the filtered
/// results from it. No backend — filters the static [dummyPlantLibrary]
/// list in memory.
class PlantLibrarySearchModel extends ChangeNotifier {
  PlantLibrarySearchModel() {
    queryController.addListener(_onQueryChanged);
  }

  final TextEditingController queryController = TextEditingController();

  List<PlantLibraryEntry> get results {
    final query = queryController.text.trim().toLowerCase();
    if (query.isEmpty) return dummyPlantLibrary;
    return dummyPlantLibrary
        .where((entry) => entry.name.toLowerCase().contains(query))
        .toList();
  }

  void _onQueryChanged() => notifyListeners();

  @override
  void dispose() {
    queryController.removeListener(_onQueryChanged);
    queryController.dispose();
    super.dispose();
  }
}
