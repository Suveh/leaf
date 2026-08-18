import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:leaf/features/plants/plant.dart';
import 'package:leaf/features/plants/plant_api_service.dart';

Map<String, dynamic> _plantJson({int id = 1, String name = 'Monty'}) => {
  'id': id,
  'name': name,
  'species': 'Monstera deliciosa',
  'photoUrl': null,
  'wateringFrequencyDays': 7,
  'lastWateredDate': null,
  'createdAt': '2026-08-01T00:00:00Z',
};

void main() {
  group('PlantApiService', () {
    test('getPlants parses a list response', () async {
      final client = MockClient((request) async {
        expect(request.method, 'GET');
        expect(request.url.path, '/api/plants');
        return http.Response(
          jsonEncode([_plantJson(id: 1, name: 'Monty'), _plantJson(id: 2, name: 'Sable')]),
          200,
        );
      });
      final service = PlantApiService(client: client);

      final plants = await service.getPlants();

      expect(plants, hasLength(2));
      expect(plants[0].name, 'Monty');
      expect(plants[1].name, 'Sable');
    });

    test('getPlant fetches a single plant by id', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/api/plants/5');
        return http.Response(jsonEncode(_plantJson(id: 5)), 200);
      });
      final service = PlantApiService(client: client);

      final plant = await service.getPlant('5');

      expect(plant.id, '5');
    });

    test('createPlant POSTs the request body and returns the created plant', () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/plants');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['name'], 'New Plant');
        expect(body.containsKey('id'), isFalse);
        return http.Response(jsonEncode(_plantJson(id: 9, name: 'New Plant')), 201);
      });
      final service = PlantApiService(client: client);

      final created = await service.createPlant(
        const Plant(id: '', name: 'New Plant', wateringFrequencyDays: 7),
      );

      expect(created.id, '9');
      expect(created.name, 'New Plant');
    });

    test('updatePlant PUTs to the plant-specific path', () async {
      final client = MockClient((request) async {
        expect(request.method, 'PUT');
        expect(request.url.path, '/api/plants/3');
        return http.Response(jsonEncode(_plantJson(id: 3, name: 'Renamed')), 200);
      });
      final service = PlantApiService(client: client);

      final updated = await service.updatePlant(
        const Plant(id: '3', name: 'Renamed', wateringFrequencyDays: 7),
      );

      expect(updated.name, 'Renamed');
    });

    test('deletePlant DELETEs the plant-specific path', () async {
      final client = MockClient((request) async {
        expect(request.method, 'DELETE');
        expect(request.url.path, '/api/plants/4');
        return http.Response('', 204);
      });
      final service = PlantApiService(client: client);

      await service.deletePlant('4');
    });

    test('throws PlantApiException on an unexpected status code', () async {
      final client = MockClient((request) async => http.Response('oops', 500));
      final service = PlantApiService(client: client);

      expect(() => service.getPlants(), throwsA(isA<PlantApiException>()));
    });

    test('throws PlantApiException when the request itself fails', () async {
      final client = MockClient((request) async => throw Exception('connection refused'));
      final service = PlantApiService(client: client);

      expect(() => service.getPlants(), throwsA(isA<PlantApiException>()));
    });
  });
}
