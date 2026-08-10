import 'package:flutter/foundation.dart';

import 'plant.dart';

/// Holds the in-memory list of the user's plants. Seeded with dummy data —
/// there is no persistence layer yet, so additions/edits only last for the
/// current app session.
class PlantsProvider extends ChangeNotifier {
  final List<Plant> _plants = [
    const Plant(
      id: 'p1',
      name: 'Monty',
      species: 'Monstera deliciosa',
      needsWateringToday: true,
    ),
    const Plant(
      id: 'p2',
      name: 'Sable',
      species: 'Dracaena trifasciata (Snake Plant)',
    ),
    const Plant(
      id: 'p3',
      name: 'Percy',
      species: 'Epipremnum aureum (Pothos)',
    ),
    const Plant(
      id: 'p4',
      name: 'Fig Newton',
      species: 'Ficus lyrata (Fiddle Leaf Fig)',
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
}
