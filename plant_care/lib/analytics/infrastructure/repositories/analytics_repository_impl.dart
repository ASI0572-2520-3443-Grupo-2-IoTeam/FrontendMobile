import 'package:plant_care/analytics/infrastructure/datasources/analytics_api_service.dart';
import 'package:plant_care/analytics/infrastructure/models/report_model.dart';
import 'package:plant_care/analytics/domain/entities/analytics_data.dart';
import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/entities/sensor_data.dart';
import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsApiService apiService;

  AnalyticsRepositoryImpl({required this.apiService});

  // ✅ Helper interno: convierte una entidad Report a su modelo
  ReportModel _toModel(Report report) => ReportModel(
        id: report.id,
        userId: report.userId,
        title: report.title,
        description: report.description,
        reportType: report.reportType,
        createdAt: report.createdAt,
        startDate: report.startDate,
        endDate: report.endDate,
        data: report.data,
      );

  // ✅ Helper interno: convierte ReportModel a entidad Report
  Report _toEntity(ReportModel model) => Report(
        id: model.id,
        userId: model.userId,
        title: model.title,
        description: model.description,
        reportType: model.reportType,
        createdAt: model.createdAt,
        startDate: model.startDate,
        endDate: model.endDate,
        data: model.data,
      );

  @override
  Future<AnalyticsData> getAnalyticsData(String userId, String token) async {
    final model = await apiService.getAnalyticsData(userId, token: token);
    // AnalyticsDataModel ya es un AnalyticsData (hereda de él)
    return model;
  }

  @override
  Future<Report?> getReportById(String id, String token) async {
    final model = await apiService.getReportById(id, token: token);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<List<Report>> fetchReportsByUserId(String userId, String token) async {
    final models = await apiService.getReportsByUserId(userId, token: token);
    return models.map(_toEntity).toList();
  }

  @override
  Future<Report> createReport(Report report, String token) async {
    final model = _toModel(report);
    final createdModel = await apiService.createReport(model, token: token);
    return _toEntity(createdModel);
  }

  @override
  Future<void> deleteReport(String id, String token) async {
    await apiService.deleteReport(id, token: token);
  }

  @override
  Future<List<SensorData>> getAllSensorData(String token) async {
    final models = await apiService.getAllSensorData(token: token);
    // SensorDataModel ya es un SensorData (hereda de él)
    return models;
  }

  @override
  Future<List<SensorData>> getSensorDataByDevice(String deviceId, String token) async {
    final models = await apiService.getSensorDataByDevice(deviceId, token: token);
    return models;
  }

  @override
  Future<void> ingestSensorData(Map<String, dynamic> data, String token) async {
    await apiService.ingestSensorData(data, token: token);
  }
}
