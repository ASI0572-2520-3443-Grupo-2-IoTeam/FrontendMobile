/// Entity representing sensor data from edge application
class SensorData {
  final String id;
  final String deviceId;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double lightLevel;
  final DateTime timestamp;

  SensorData({
    required this.id,
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.lightLevel,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SensorData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          deviceId == other.deviceId;

  @override
  int get hashCode => id.hashCode ^ deviceId.hashCode;
}
