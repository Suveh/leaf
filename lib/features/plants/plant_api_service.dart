import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/api_config.dart';
import 'plant.dart';

/// Thrown when a [PlantApiService] call fails, wrapping the underlying
/// cause with a short, user-presentable message.
class PlantApiException implements Exception {
  const PlantApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Wraps HTTP calls to the backend's `/api/plants` resource.
class PlantApiService {
  PlantApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _jsonHeaders = {'Content-Type': 'application/json'};

  Uri _plantsUri([String path = '']) =>
      Uri.parse('${ApiConfig.baseUrl}/api/plants$path');

  Future<List<Plant>> getPlants() async {
    final response = await _get(_plantsUri());
    final data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((json) => Plant.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Plant> getPlant(String id) async {
    final response = await _get(_plantsUri('/$id'));
    return Plant.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Plant> createPlant(Plant plant) async {
    final response = await _send(
      () => _client.post(
        _plantsUri(),
        headers: _jsonHeaders,
        body: jsonEncode(plant.toRequestJson()),
      ),
      expectedStatus: 201,
    );
    return Plant.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Plant> updatePlant(Plant plant) async {
    final response = await _send(
      () => _client.put(
        _plantsUri('/${plant.id}'),
        headers: _jsonHeaders,
        body: jsonEncode(plant.toRequestJson()),
      ),
      expectedStatus: 200,
    );
    return Plant.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deletePlant(String id) async {
    await _send(
      () => _client.delete(_plantsUri('/$id')),
      expectedStatus: 204,
    );
  }

  Future<http.Response> _get(Uri uri) =>
      _send(() => _client.get(uri), expectedStatus: 200);

  Future<http.Response> _send(
    Future<http.Response> Function() request, {
    required int expectedStatus,
  }) async {
    late final http.Response response;
    try {
      response = await request();
    } catch (_) {
      throw const PlantApiException(
        "Couldn't reach the server. Check that the backend is running and try again.",
      );
    }
    if (response.statusCode != expectedStatus) {
      throw PlantApiException(
        'Something went wrong talking to the server (HTTP ${response.statusCode}).',
      );
    }
    return response;
  }
}
