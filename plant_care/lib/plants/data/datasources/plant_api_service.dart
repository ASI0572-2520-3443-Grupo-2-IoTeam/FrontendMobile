import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_care/plants/infrastructure/models/plant_model.dart';

/// Service responsible for communicating with the Plant API.
class PlantApiService {
  /// Base URL of the backend API.
  final String baseUrl;

  final Map<String, Future<List<PlantModel>>> _inFlightByUser = {};

  static bool enablePlantsFetch = false;

  PlantApiService({this.baseUrl = 'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1'});

  /// Get a plant by its unique ID.
  Future<PlantModel?> getPlantById(String plantId) async {
    final url = Uri.parse('$baseUrl/plants/$plantId');
    debugPrint('Fetching plant by ID: $url');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('No hay plantas registradas.');
      }
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return PlantModel.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      throw Exception('No hay plantas registradas.');
    } else {
      throw Exception('Error al obtener planta: ${response.statusCode}');
    }
  }

  /// Get all plants belonging to a specific user (query parameter)
  Future<List<PlantModel>> getPlantsByUserId(String userId, {required String token}) async {
    if (!enablePlantsFetch) return [];

    final existing = _inFlightByUser[userId];
    if (existing != null) return existing;

    final future = _getPlantsByUserIdInternal(userId, token);
    _inFlightByUser[userId] = future;
    try {
      final result = await future;
      return result;
    } finally {
      _inFlightByUser.remove(userId);
    }
  }

  Future<List<PlantModel>> _getPlantsByUserIdInternal(String userId, String token) async {
    final url = Uri.parse('$baseUrl/plants/user/$userId');

    final response = await http.get(
      url,
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final plants = jsonList.map((json) {
        final map = json as Map<String, dynamic>;
        return PlantModel.fromJson(map);
      }).toList();
      return plants;
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: token inválido o permisos insuficientes.');
    } else if (response.statusCode == 404) {
      throw Exception('No se encontraron plantas para este usuario.');
    } else {
      throw Exception('Error al obtener plantas: ${response.statusCode}');
    }
  }

  /// Create a new plant.
  Future<PlantModel> addPlant(PlantModel plant) async {
    final url = Uri.parse('$baseUrl/plants');
    debugPrint('Adding plant: $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plant.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return PlantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add plant: ${response.statusCode}');
    }
  }

  /// Update an existing plant by its ID.
  Future<PlantModel> updatePlant(String plantId, PlantModel updatedPlant) async {
    final url = Uri.parse('$baseUrl/plants/$plantId');
    debugPrint('Updating plant: $url');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedPlant.toJson()),
    );

    if (response.statusCode == 200) {
      return PlantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update plant: ${response.statusCode}');
    }
  }

  /// Delete a plant by its ID.
  Future<void> deletePlant(String plantId) async {
    final url = Uri.parse('$baseUrl/plants/$plantId');
    debugPrint('Deleting plant: $url');

    final response = await http.delete(url);

    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Failed to delete plant: ${response.statusCode}');
    }
  }
}
