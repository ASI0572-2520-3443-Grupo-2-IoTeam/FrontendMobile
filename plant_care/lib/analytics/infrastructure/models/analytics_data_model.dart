import 'package:plant_care/analytics/domain/entities/analytics_data.dart';
import 'package:plant_care/analytics/infrastructure/models/watering_trend_model.dart';

class AnalyticsDataModel extends AnalyticsData {
  AnalyticsDataModel({
    required super.totalPlants,
    required super.healthyPlants,
    required super.needsWateringPlants,
    required super.criticalPlants,
    required super.averageHumidity,
    required super.totalWaterings,
    required super.plantsByType,
    required super.plantsByLocation,
    required super.wateringTrends,
  });

  /// Crear AnalyticsDataModel desde JSON
  factory AnalyticsDataModel.fromJson(Map<String, dynamic> json) {
    final wateringTrendsJson = json['wateringTrends'] as List<dynamic>? ?? [];
    final wateringTrends = wateringTrendsJson.map((item) {
      return WateringTrendModel.fromJson(item as Map<String, dynamic>);
    }).toList();

    return AnalyticsDataModel(
      totalPlants: json['totalPlants'] as int,
      healthyPlants: json['healthyPlants'] as int,
      needsWateringPlants: json['needsWateringPlants'] as int,
      criticalPlants: json['criticalPlants'] as int,
      averageHumidity: (json['averageHumidity'] as num).toDouble(),
      totalWaterings: json['totalWaterings'] as int,
      plantsByType: Map<String, int>.from(json['plantsByType'] as Map),
      plantsByLocation: Map<String, int>.from(json['plantsByLocation'] as Map),
      wateringTrends: wateringTrends,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'totalPlants': totalPlants,
      'healthyPlants': healthyPlants,
      'needsWateringPlants': needsWateringPlants,
      'criticalPlants': criticalPlants,
      'averageHumidity': averageHumidity,
      'totalWaterings': totalWaterings,
      'plantsByType': plantsByType,
      'plantsByLocation': plantsByLocation,
      'wateringTrends': wateringTrends.map((trend) {
        return WateringTrendModel(date: trend.date, count: trend.count)
            .toJson();
      }).toList(),
    };
  }
}
