import 'package:plant_care/analytics/domain/entities/watering_trend.dart';

class WateringTrendModel extends WateringTrend {
  WateringTrendModel({
    required super.date,
    required super.count,
  });

  /// Crear desde JSON
  factory WateringTrendModel.fromJson(Map<String, dynamic> json) {
    return WateringTrendModel(
      date: DateTime.parse(json['date'] as String),
      count: json['count'] as int,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'count': count,
    };
  }
}
