import 'package:plant_care/analytics/domain/entities/sensor_data.dart';

/// Model for sensor data from edge application
class SensorDataModel extends SensorData {
  SensorDataModel({
    required super.id,
    required super.deviceId,
    required super.temperature,
    required super.humidity,
    required super.soilMoisture,
    required super.lightLevel,
    required super.timestamp,
  });

  /// Creates a SensorDataModel from JSON
  factory SensorDataModel.fromJson(Map<String, dynamic> json) {
    return SensorDataModel(
      id: json['id']?.toString() ?? '',
      deviceId: json['deviceId'] as String? ?? json['device_id'] as String? ?? '',
      temperature: (json['airTemperatureC'] as num?)?.toDouble() ?? 
                   (json['temperature'] as num?)?.toDouble() ?? 0.0,
      humidity: (json['airHumidityPct'] as num?)?.toDouble() ?? 
                (json['humidity'] as num?)?.toDouble() ?? 0.0,
      soilMoisture: (json['soilMoisturePct'] as num?)?.toDouble() ?? 
                    (json['soilMoisture'] as num?)?.toDouble() ?? 
                    (json['soil_moisture'] as num?)?.toDouble() ?? 0.0,
      lightLevel: (json['lightIntensityLux'] as num?)?.toDouble() ?? 
                  (json['lightLevel'] as num?)?.toDouble() ?? 
                  (json['light_level'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  /// Converts SensorDataModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceId': deviceId,
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'lightLevel': lightLevel,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
