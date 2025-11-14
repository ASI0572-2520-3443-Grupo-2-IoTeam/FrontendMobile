class PlantMetric {
  final int? id;
  final int? plantId;
  final String deviceId;
  final double temperature;
  final double humidity;
  final double light;
  final double soilHumidity;
  final String createdAt;

  const PlantMetric({
    this.id,
    this.plantId,
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.soilHumidity,
    required this.createdAt,
  });

  factory PlantMetric.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      final parsed = double.tryParse(v.toString());
      return parsed ?? 0;
    }

    return PlantMetric(
      id: json['id'] as int?,
      plantId: json['plantId'] as int?,
      deviceId: (json['deviceId'] ?? '').toString(),
      temperature: _toDouble(json['temperature']),
      humidity: _toDouble(json['humidity']),
      light: _toDouble(json['light']),
      soilHumidity: _toDouble(json['soilHumidity']),
      createdAt: (json['createdAt'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'plantId': plantId,
        'deviceId': deviceId,
        'temperature': temperature,
        'humidity': humidity,
        'light': light,
        'soilHumidity': soilHumidity,
        'createdAt': createdAt,
      };
}

