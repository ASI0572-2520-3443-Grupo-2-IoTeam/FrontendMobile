import 'package:flutter/material.dart';
import 'package:plant_care/analytics/data/datasources/analytics_api_service.dart';
import 'package:plant_care/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:plant_care/analytics/domain/entities/analytics_data.dart';
import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsRepository _repository =
      AnalyticsRepositoryImpl(apiService: AnalyticsApiService());

  AnalyticsData? _analyticsData;
  List<Report> _reports = [];
  bool _isLoading = false;
  String? _message;
  bool _hasFetchedAnalytics = false;
  bool _hasFetchedReports = false;
  String? _lastUserId;

  AnalyticsData? get analyticsData => _analyticsData;
  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get message => _message;

  // ==============================================================
  // 📊 Cargar datos de análisis del usuario
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
      _message = "Error al cargar datos de análisis: $e";
      debugPrint(_message);
      _analyticsData = null;
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
    ]);
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
    _message = null;
    _hasFetchedAnalytics = false;
    _hasFetchedReports = false;
    _lastUserId = null;
    notifyListeners();
  }
}
