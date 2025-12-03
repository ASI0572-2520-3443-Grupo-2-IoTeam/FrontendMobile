import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_care/analytics/infrastructure/models/analytics_data_model.dart';
import 'package:plant_care/analytics/infrastructure/models/report_model.dart';
import 'package:plant_care/analytics/infrastructure/models/sensor_data_model.dart';

/// Service responsible for communicating with the Analytics API.
class AnalyticsApiService {
  /// Base URL of the backend API.
  final String baseUrl;

  AnalyticsApiService({this.baseUrl = 'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1'});

  /// Get analytics data for a specific user.
  Future<AnalyticsDataModel> getAnalyticsData(String userId, {required String token}) async {
    final url = Uri.parse('$baseUrl/analytics?userId=$userId');
    debugPrint('➡️ GET $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('No hay datos de análisis disponibles.');
      }
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return AnalyticsDataModel.fromJson(jsonMap);
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: token inválido o permisos insuficientes.');
    } else if (response.statusCode == 404) {
      throw Exception('No se encontraron datos de análisis.');
    } else {
      throw Exception('Error al obtener datos de análisis: ${response.statusCode}');
    }
  }

  /// Get a report by its unique ID.
  Future<ReportModel?> getReportById(String reportId, {required String token}) async {
    final url = Uri.parse('$baseUrl/reports/$reportId');
    debugPrint('➡️ GET $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return null;
      }
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return ReportModel.fromJson(jsonMap);
    } else if (response.statusCode == 404) {
      return null;
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: token inválido.');
    } else {
      throw Exception('Error al obtener reporte: ${response.statusCode}');
    }
  }

  /// Get all reports belonging to a specific user.
  Future<List<ReportModel>> getReportsByUserId(String userId, {required String token}) async {
    final url = Uri.parse('$baseUrl/reports?userId=$userId');
    debugPrint('➡️ GET $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => ReportModel.fromJson(json as Map<String, dynamic>))
          .where((report) => report.userId == userId)
          .toList();
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: token inválido o permisos insuficientes.');
    } else if (response.statusCode == 404) {
      throw Exception('No se encontraron reportes para este usuario.');
    } else {
      throw Exception('Error al obtener reportes: ${response.statusCode}');
    }
  }

  /// Create a new report.
  Future<ReportModel> createReport(ReportModel report, {required String token}) async {
    final url = Uri.parse('$baseUrl/reports');
    debugPrint('➡️ POST $url');
    debugPrint('📦 Body: ${report.toJson()}');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(report.toJson()),
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      return ReportModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: no tiene permisos para crear reportes.');
    } else {
      throw Exception('Error al crear reporte: ${response.statusCode}');
    }
  }

  /// Delete a report by its ID.
  Future<void> deleteReport(String reportId, {required String token}) async {
    final url = Uri.parse('$baseUrl/reports/$reportId');
    debugPrint('➡️ DELETE $url');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Status: ${response.statusCode}');

    if (response.statusCode != 204 && response.statusCode != 200) {
      if (response.statusCode == 403) {
        throw Exception('Acceso denegado: no tiene permisos para eliminar este reporte.');
      } else if (response.statusCode == 404) {
        throw Exception('Reporte no encontrado.');
      } else {
        throw Exception('Error al eliminar reporte: ${response.statusCode}');
      }
    }
  }

  // ==================== SENSOR DATA ENDPOINTS ====================

  /// Get all sensor data from edge application (history)
  Future<List<SensorDataModel>> getAllSensorData({required String token}) async {
    final url = Uri.parse('$baseUrl/analytics/data');
    debugPrint('➡️ GET $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == '[]') {
        return [];
      }
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => SensorDataModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: token inválido o permisos insuficientes.');
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Error al obtener datos del sensor: ${response.statusCode}');
    }
  }

  /// Get sensor data by device ID (history)
  Future<List<SensorDataModel>> getSensorDataByDevice(
    String deviceId, {
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/analytics/devices/$deviceId/data');
    debugPrint('➡️ GET $url');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isEmpty || response.body == '[]') {
        return [];
      }
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((json) => SensorDataModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (response.statusCode == 403) {
      throw Exception('Acceso denegado: token inválido o permisos insuficientes.');
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Error al obtener datos del dispositivo: ${response.statusCode}');
    }
  }

  /// Import sensor data (POST /analytics/imports)
  Future<void> ingestSensorData(Map<String, dynamic> data, {required String token}) async {
    final url = Uri.parse('$baseUrl/analytics/imports');
    debugPrint('➡️ POST $url');
    debugPrint('📦 Body: $data');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
      if (response.statusCode == 403) {
        throw Exception('Acceso denegado: no tiene permisos para ingerir datos.');
      } else {
        throw Exception('Error al ingerir datos del sensor: ${response.statusCode}');
      }
    }
  }
}
