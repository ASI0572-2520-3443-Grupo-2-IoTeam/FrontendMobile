import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:plant_care/plants/infrastructure/models/plant_model.dart';

abstract class PlantRemoteDataSource {
  Future<List<PlantModel>> getPlants(String userId, String token);
  Future<PlantModel> addPlant(
    String userId,
    String token,
    Map<String, dynamic> plantData,
  );
  Future<void> deletePlant(String plantId, String token);
}

class PlantRemoteDataSourceImpl implements PlantRemoteDataSource {
  final http.Client client;

  PlantRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PlantModel>> getPlants(String userId, String token) async {
    final uri = Uri.parse(
      'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1/users/$userId/plants',
    );

    try {
      print('PlantRemoteDataSource: GET $uri');

      final response = await client
          .get(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'accept': '*/*',
            },
          )
          .timeout(const Duration(seconds: 60));

      print('PlantRemoteDataSource: status=${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> body = json.decode(response.body);
        return body.map((json) => PlantModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to load plants: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: $e');
    } on TimeoutException catch (e) {
      throw Exception('Request timed out: $e');
    } catch (e) {
      throw Exception('Failed to load plants: $e');
    }
  }

  @override
  Future<PlantModel> addPlant(
    String userId,
    String token,
    Map<String, dynamic> plantData,
  ) async {
    final uri = Uri.parse(
      'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1/plants',
    );

    try {
      print('PlantRemoteDataSource: POST $uri');

      final response = await client
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'accept': '*/*',
            },
            body: json.encode(plantData),
          )
          .timeout(const Duration(seconds: 60));

      print('PlantRemoteDataSource: status=${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> body = json.decode(response.body);
        return PlantModel.fromJson(body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to add plant: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: $e');
    } on TimeoutException catch (e) {
      throw Exception('Request timed out: $e');
    } catch (e) {
      throw Exception('Failed to add plant: $e');
    }
  }

  @override
  Future<void> deletePlant(String plantId, String token) async {
    final uri = Uri.parse(
      'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1/plants/$plantId',
    );

    try {
      print('PlantRemoteDataSource: DELETE $uri');

      final response = await client
          .delete(
            uri,
            headers: {'Authorization': 'Bearer $token', 'accept': '*/*'},
          )
          .timeout(const Duration(seconds: 60));

      print('PlantRemoteDataSource: status=${response.statusCode}');

      if (response.statusCode == 204) {
        // Success, no content
        return;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to delete plant: ${response.statusCode}');
      }
    } on http.ClientException catch (e) {
      throw Exception('HTTP client error: $e');
    } on TimeoutException catch (e) {
      throw Exception('Request timed out: $e');
    } catch (e) {
      throw Exception('Failed to delete plant: $e');
    }
  }
}
