import 'package:plant_care/analytics/domain/entities/analytics_data.dart';
import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/entities/sensor_data.dart';

abstract class AnalyticsRepository {
  /// Obtiene los datos de análisis del usuario.
  Future<AnalyticsData> getAnalyticsData(String userId, String token);

  /// Obtiene un reporte por su ID.
  Future<Report?> getReportById(String id, String token);

  /// Obtiene todos los reportes del usuario autenticado.
  Future<List<Report>> fetchReportsByUserId(String userId, String token);

  /// Crea un nuevo reporte y retorna el creado por el backend.
  Future<Report> createReport(Report report, String token);

  /// Elimina un reporte por su ID.
  Future<void> deleteReport(String id, String token);

  /// Obtiene todos los datos del sensor desde el edge application.
  Future<List<SensorData>> getAllSensorData(String token);

  /// Obtiene datos del sensor por ID de dispositivo.
  Future<List<SensorData>> getSensorDataByDevice(String deviceId, String token);

  /// Ingiere datos del sensor al backend.
  Future<void> ingestSensorData(Map<String, dynamic> data, String token);
}
