import 'package:flutter/foundation.dart';

import 'plant.dart';
import 'plant_api_service.dart';

/// Holds the user's plants, fetched from the backend via [PlantApiService].
/// Exposes basic loading/error state so screens can show a spinner or an
/// error-with-retry message while talking to the API.
class PlantsProvider extends ChangeNotifier {
  PlantsProvider({PlantApiService? apiService})
    : _apiService = apiService ?? PlantApiService() {
    loadPlants();
  }

  final PlantApiService _apiService;

  List<Plant> _plants = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Plant> get plants => List.unmodifiable(_plants);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get totalCount => _plants.length;

  int get needsWateringCount =>
      _plants.where((plant) => plant.needsWateringToday).length;

  /// Fetches the plant list from the backend. Safe to call again to retry
  /// after a failure.
  Future<void> loadPlants() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _plants = await _apiService.getPlants();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPlant(Plant plant) async {
    final created = await _apiService.createPlant(plant);
    _plants.add(created);
    notifyListeners();
  }

  Future<void> updatePlant(Plant plant) async {
    final updated = await _apiService.updatePlant(plant);
    final index = _plants.indexWhere((p) => p.id == updated.id);
    if (index == -1) return;
    _plants[index] = updated;
    notifyListeners();
  }

  void markAsWateredToday(String id) {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index == -1) return;
    _plants[index] = _plants[index].copyWith(lastWateredDate: DateTime.now());
    notifyListeners();
  }
}
