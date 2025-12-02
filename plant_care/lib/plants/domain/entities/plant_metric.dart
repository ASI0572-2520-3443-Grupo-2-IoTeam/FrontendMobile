import 'package:equatable/equatable.dart';

class PlantMetric extends Equatable {
  final String deviceId;
  final double temperature;
  final double humidity;
  final double light;
  final double soilHumidity;
  final DateTime createdAt;

  const PlantMetric({
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.soilHumidity,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [deviceId, temperature, humidity, light, soilHumidity, createdAt];
}