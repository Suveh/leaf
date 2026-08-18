import 'package:flutter_test/flutter_test.dart';
import 'package:leaf/features/plants/plant.dart';

void main() {
  group('Plant.fromJson', () {
    test('parses a full backend response', () {
      final plant = Plant.fromJson({
        'id': 42,
        'name': 'Monty',
        'species': 'Monstera deliciosa',
        'photoUrl': 'https://example.com/monty.jpg',
        'wateringFrequencyDays': 7,
        'lastWateredDate': '2026-08-10',
        'createdAt': '2026-08-01T12:00:00.000000000Z',
      });

      expect(plant.id, '42');
      expect(plant.name, 'Monty');
      expect(plant.species, 'Monstera deliciosa');
      expect(plant.imagePath, 'https://example.com/monty.jpg');
      expect(plant.wateringFrequencyDays, 7);
      expect(plant.lastWateredDate, DateTime(2026, 8, 10));
      expect(plant.createdAt, isNotNull);
    });

    test('handles null species, photoUrl, and lastWateredDate', () {
      final plant = Plant.fromJson({
        'id': 7,
        'name': 'Pothos',
        'species': null,
        'photoUrl': null,
        'wateringFrequencyDays': 10,
        'lastWateredDate': null,
        'createdAt': '2026-08-01T00:00:00Z',
      });

      expect(plant.species, isNull);
      expect(plant.imagePath, isNull);
      expect(plant.lastWateredDate, isNull);
    });
  });

  test('toRequestJson omits id/createdAt and formats lastWateredDate as yyyy-MM-dd', () {
    final plant = Plant(
      id: '1',
      name: 'Fern',
      species: 'Boston Fern',
      wateringFrequencyDays: 3,
      imagePath: 'photo.jpg',
      lastWateredDate: DateTime(2026, 3, 5),
      createdAt: DateTime(2026, 1, 1),
    );

    final json = plant.toRequestJson();

    expect(json, {
      'name': 'Fern',
      'species': 'Boston Fern',
      'photoUrl': 'photo.jpg',
      'wateringFrequencyDays': 3,
      'lastWateredDate': '2026-03-05',
    });
    expect(json.containsKey('id'), isFalse);
    expect(json.containsKey('createdAt'), isFalse);
  });

  group('nextWateringDate', () {
    test('is derived from lastWateredDate plus wateringFrequencyDays', () {
      final plant = Plant(
        id: '1',
        name: 'Monty',
        wateringFrequencyDays: 7,
        lastWateredDate: DateTime.now().subtract(const Duration(days: 9)),
      );

      expect(plant.isOverdue, isTrue);
      expect(plant.needsWateringToday, isTrue);
    });

    test('falls back to createdAt when never watered', () {
      final plant = Plant(
        id: '1',
        name: 'New Plant',
        wateringFrequencyDays: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      );

      final expectedNext = DateTime.now()
          .subtract(const Duration(days: 1))
          .add(const Duration(days: 5));
      expect(plant.nextWateringDate.year, expectedNext.year);
      expect(plant.nextWateringDate.month, expectedNext.month);
      expect(plant.nextWateringDate.day, expectedNext.day);
    });

    test('a plant watered today is not due again until the interval passes', () {
      final plant = Plant(
        id: '1',
        name: 'Sable',
        wateringFrequencyDays: 7,
        lastWateredDate: DateTime.now(),
      );

      expect(plant.isOverdue, isFalse);
      expect(plant.needsWateringToday, isFalse);
    });
  });
}
