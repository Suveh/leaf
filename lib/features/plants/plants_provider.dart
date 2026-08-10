import 'package:flutter/foundation.dart';

import 'plant.dart';

/// How far out watering is pushed when a plant is marked as watered today.
/// Dummy default — real per-plant watering intervals come later.
const _defaultWateringIntervalDays = 7;

/// Holds the in-memory list of the user's plants. Seeded with dummy data —
/// there is no persistence layer yet, so additions/edits only last for the
/// current app session.
class PlantsProvider extends ChangeNotifier {
  PlantsProvider() : _now = DateTime.now();

  final DateTime _now;

  late final List<Plant> _plants = [
    Plant(
      id: 'p1',
      name: 'Monty',
      species: 'Monstera deliciosa',
      nextWateringDate: _now.subtract(const Duration(days: 2)),
    ),
    Plant(
      id: 'p2',
      name: 'Sable',
      species: 'Dracaena trifasciata (Snake Plant)',
      nextWateringDate: _now.add(const Duration(days: 5)),
    ),
    Plant(
      id: 'p3',
      name: 'Percy',
      species: 'Epipremnum aureum (Pothos)',
      nextWateringDate: _now,
    ),
    Plant(
      id: 'p4',
      name: 'Fig Newton',
      species: 'Ficus lyrata (Fiddle Leaf Fig)',
      nextWateringDate: _now.add(const Duration(days: 2)),
    ),
  ];

  List<Plant> get plants => List.unmodifiable(_plants);

  int get totalCount => _plants.length;

  int get needsWateringCount =>
      _plants.where((plant) => plant.needsWateringToday).length;

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  void updatePlant(Plant plant) {
    final index = _plants.indexWhere((p) => p.id == plant.id);
    if (index == -1) return;
    _plants[index] = plant;
    notifyListeners();
  }

  void markAsWateredToday(String id) {
    final index = _plants.indexWhere((p) => p.id == id);
    if (index == -1) return;
    _plants[index] = _plants[index].copyWith(
      nextWateringDate: DateTime.now().add(
        const Duration(days: _defaultWateringIntervalDays),
      ),
    );
    notifyListeners();
  }
}
