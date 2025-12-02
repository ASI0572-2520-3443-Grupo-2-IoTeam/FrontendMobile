
import 'package:plant_care/plants/domain/entities/plant_metric.dart';

class PlantMetricModel {
  final String deviceId;
  final double temperature;
  final double humidity;
  final double light;
  final double soilHumidity;
  final String createdAt;

  PlantMetricModel({
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.soilHumidity,
    required this.createdAt,
  });

  factory PlantMetricModel.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    return PlantMetricModel(
      deviceId: json['deviceId'] ?? json['device'] ?? '',
      temperature: toDouble(json['airTemperatureC'] ?? json['temperature']),
      humidity: toDouble(json['airHumidityPct'] ?? json['humidity']),
      light: toDouble(json['lightIntensityLux'] ?? json['light']),
      soilHumidity: toDouble(json['soilMoisturePct'] ?? json['soilHumidity']),
      createdAt: (json['timestamp'] ?? json['createdAt'] ?? '').toString(),
    );
  }

  
  PlantMetric toEntity() {
    return PlantMetric(
      deviceId: deviceId,
      temperature: temperature,
      humidity: humidity,
      light: light,
      soilHumidity: soilHumidity,
      createdAt:
          DateTime.tryParse(createdAt) ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
