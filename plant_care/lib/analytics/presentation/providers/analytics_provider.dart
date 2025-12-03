import 'package:flutter/material.dart';
import 'package:plant_care/analytics/infrastructure/datasources/analytics_api_service.dart';
import 'package:plant_care/analytics/infrastructure/repositories/analytics_repository_impl.dart';
import 'package:plant_care/analytics/domain/entities/analytics_data.dart';
import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/entities/sensor_data.dart';
import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/value_objetcs/plant_status.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsRepository _repository =
      AnalyticsRepositoryImpl(apiService: AnalyticsApiService());

  AnalyticsData? _analyticsData;
  List<Report> _reports = [];
  List<SensorData> _sensorDataHistory = [];
  bool _isLoading = false;
  bool _isLoadingSensorData = false;
  String? _message;
  bool _hasFetchedAnalytics = false;
  bool _hasFetchedReports = false;
  bool _hasFetchedSensorData = false;
  String? _lastUserId;

  AnalyticsData? get analyticsData => _analyticsData;
  List<Report> get reports => _reports;
  List<SensorData> get sensorDataHistory => _sensorDataHistory;
  bool get isLoading => _isLoading;
  bool get isLoadingSensorData => _isLoadingSensorData;
  String? get message => _message;

  // ==============================================================
  // 📊 Calcular datos de análisis localmente desde las plantas del usuario
  // ==============================================================
  void calculateAnalyticsFromPlants(List<Plant> plants) {
    if (plants.isEmpty) {
      _analyticsData = null;
      notifyListeners();
      return;
    }

    final totalPlants = plants.length;
    int healthyPlants = 0;
    int needsWateringPlants = 0;
    int criticalPlants = 0;
    
    // Acumuladores para promedios de métricas
    double totalSoilHumidity = 0;
    double totalTemperature = 0;
    double totalHumidity = 0;
    double totalLight = 0;
    int plantsWithSoilHumidity = 0;
    int plantsWithTemperature = 0;
    int plantsWithHumidity = 0;
    int plantsWithLight = 0;

    final Map<String, int> plantsByType = {};
    final Map<String, int> plantsByLocation = {};

    for (var plant in plants) {
      switch (plant.status) {
        case PlantStatus.HEALTHY:
          healthyPlants++;
          break;
        case PlantStatus.WARNING:
          needsWateringPlants++;
          break;
        case PlantStatus.DANGER:
        case PlantStatus.CRITICAL:
          criticalPlants++;
          break;
        case PlantStatus.UNKNOWN:
          healthyPlants++;
          break;
      }

      final latestMetric = plant.latestMetric;
      if (latestMetric != null) {
        if (latestMetric.soilHumidity > 0) {
          totalSoilHumidity += latestMetric.soilHumidity;
          plantsWithSoilHumidity++;
        }
        if (latestMetric.temperature > 0) {
          totalTemperature += latestMetric.temperature;
          plantsWithTemperature++;
        }
        if (latestMetric.humidity > 0) {
          totalHumidity += latestMetric.humidity;
          plantsWithHumidity++;
        }
        if (latestMetric.light > 0) {
          totalLight += latestMetric.light;
          plantsWithLight++;
        }
      }

      final type = plant.type;
      plantsByType[type] = (plantsByType[type] ?? 0) + 1;

      final location = plant.location;
      plantsByLocation[location] = (plantsByLocation[location] ?? 0) + 1;
    }

    final averageSoilHumidity = plantsWithSoilHumidity > 0 
        ? totalSoilHumidity / plantsWithSoilHumidity 
        : 0.0;
    
    final averageTemperature = plantsWithTemperature > 0
        ? totalTemperature / plantsWithTemperature
        : 0.0;
    
    final averageHumidity = plantsWithHumidity > 0
        ? totalHumidity / plantsWithHumidity
        : 0.0;
    
    final averageLight = plantsWithLight > 0
        ? totalLight / plantsWithLight
        : 0.0;

    _analyticsData = AnalyticsData(
      totalPlants: totalPlants,
      healthyPlants: healthyPlants,
      needsWateringPlants: needsWateringPlants,
      criticalPlants: criticalPlants,
      averageHumidity: averageSoilHumidity,
      averageTemperature: averageTemperature,
      averageAirHumidity: averageHumidity,
      averageLight: averageLight,
      totalWaterings: 0,
      plantsByType: plantsByType,
      plantsByLocation: plantsByLocation,
      wateringTrends: [],
    );
    
    _hasFetchedAnalytics = true;
    notifyListeners();
  }

  // ==============================================================
  // 📊 Cargar datos de análisis del usuario (DEPRECADO - usa calculateAnalyticsFromPlants)
  // ==============================================================
  Future<void> fetchAnalyticsData({
    required String userId,
    required String token,
    bool force = false,
  }) async {
    if (_hasFetchedAnalytics && !force && _lastUserId == userId) return;

    _setLoading(true);
    _message = null;

    try {
      final data = await _repository.getAnalyticsData(userId, token);
      _analyticsData = data;
      _hasFetchedAnalytics = true;
      _lastUserId = userId;
      _message = null;
    } catch (e) {
      if (e.toString().contains('403') || e.toString().contains('Acceso denegado')) {
        debugPrint('⚠️ Analytics endpoint no disponible (403) - usar cálculo local');
        _message = null;
      } else {
        _message = "Error al cargar datos de análisis: $e";
        debugPrint(_message);
      }
      _analyticsData = null;
      _hasFetchedAnalytics = true;
    } finally {
      _setLoading(false);
    }
  }

  // ==============================================================
  // 📋 Cargar reportes del usuario
  // ==============================================================
  Future<void> fetchReports({
    required String userId,
    required String token,
    bool force = false,
  }) async {
    if (_hasFetchedReports && !force && _lastUserId == userId) return;

    _setLoading(true);
    _message = null;

    try {
      final fetchedReports = await _repository.fetchReportsByUserId(userId, token);
      _reports = fetchedReports;

      if (_reports.isEmpty) {
        _message = "No hay reportes disponibles 📊";
      }

      _hasFetchedReports = true;
      _lastUserId = userId;
    } catch (e) {
      _message = "Error al cargar reportes: $e";
      debugPrint(_message);
    } finally {
      _setLoading(false);
    }
  }

  // ==============================================================
  // ➕ Crear un nuevo reporte
  // ==============================================================
  Future<void> createReport(Report newReport, String token) async {
    _setLoading(true);
    try {
      final createdReport = await _repository.createReport(newReport, token);
      _reports.add(createdReport);
      _message = "Reporte creado exitosamente 📊";
      notifyListeners();
    } catch (e) {
      _message = "Error al crear reporte: $e";
      debugPrint(_message);
    } finally {
      _setLoading(false);
    }
  }

  // ==============================================================
  // ❌ Eliminar un reporte
  // ==============================================================
  Future<void> deleteReport(String reportId, String token) async {
    _setLoading(true);
    try {
      await _repository.deleteReport(reportId, token);
      _reports.removeWhere((r) => r.id.toString() == reportId);
      _message = "Reporte eliminado 🗑️";
      notifyListeners();
    } catch (e) {
      _message = "Error al eliminar reporte: $e";
      debugPrint(_message);
    } finally {
      _setLoading(false);
    }
  }

  // ==============================================================
  // 🔄 Refrescar todos los datos
  // ==============================================================
  Future<void> refreshAll({
    required String userId,
    required String token,
  }) async {
    await Future.wait([
      fetchAnalyticsData(userId: userId, token: token, force: true),
      fetchReports(userId: userId, token: token, force: true),
      fetchSensorData(token: token, force: true),
    ]);
  }

  // ==============================================================
  // 📡 Cargar historial de datos del sensor desde edge application
  // ==============================================================
  Future<void> fetchSensorData({
    required String token,
    String? deviceId,
    bool force = false,
  }) async {
    if (_hasFetchedSensorData && !force) return;

    _isLoadingSensorData = true;
    notifyListeners();

    try {
      final data = deviceId != null
          ? await _repository.getSensorDataByDevice(deviceId, token)
          : await _repository.getAllSensorData(token);
      
      _sensorDataHistory = data;
      _hasFetchedSensorData = true;
      
      if (_sensorDataHistory.isEmpty) {
        _message = "No hay datos del sensor disponibles 📡";
      }
    } catch (e) {
      _message = "Error al cargar datos del sensor: $e";
      debugPrint(_message);
      _sensorDataHistory = [];
    } finally {
      _isLoadingSensorData = false;
      notifyListeners();
    }
  }

  // ==============================================================
  // 🔄 Utilidades internas
  // ==============================================================
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearData() {
    _analyticsData = null;
    _reports = [];
    _sensorDataHistory = [];
    _message = null;
    _hasFetchedAnalytics = false;
    _hasFetchedReports = false;
    _hasFetchedSensorData = false;
    _lastUserId = null;
    notifyListeners();
  }
}
