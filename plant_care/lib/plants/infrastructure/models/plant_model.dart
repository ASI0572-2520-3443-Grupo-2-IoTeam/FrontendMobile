import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/entities/plant_metric.dart';

import '../../domain/entities/plant_status.dart';
  
class PlantModel extends Plant {

  PlantModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.type,
    required super.imgUrl,
    required super.humidity,
    required super.lastWatered,
    required super.nextWatering,
    required super.status,
    required super.bio,
    required super.location, 
    required super.metrics,
    required super.wateringLogs,
    required super.createdAt,
    required super.updatedAt,
  });


  factory PlantModel.fromJson(Map<String, dynamic> json) {
    final metricsJson = (json['metrics'] as List<dynamic>? ?? []);
    final metrics = metricsJson.map((m) => PlantMetric.fromJson(m as Map<String, dynamic>)).toList();
    final double derivedHumidity = metrics.isNotEmpty ? metrics.last.humidity : (json['humidity'] is num ? (json['humidity'] as num).toDouble() : 0);
    return PlantModel(
      id: json['id'] as int,
      userId: json['userId'].toString(),
      name: json['name'] as String,
      type: json['type'] as String,
      imgUrl: json['imgUrl'] as String,
      humidity: derivedHumidity,
      lastWatered: json['lastWatered'] as String? ?? '',
      nextWatering: json['nextWatering'] as String? ?? '',
      status: json['status'] as String,
      bio: json['bio'] as String? ?? '',
      location: json['location'] as String? ?? '',
      metrics: metrics,
      wateringLogs: json['wateringLogs'] as List<dynamic>? ?? [],
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'type': type,
      'imgUrl': imgUrl,
      'humidity': humidity,
      'lastWatered': lastWatered,
      'nextWatering': nextWatering,
      'status': status,
      'bio': bio,
      'location': location,
      'metrics': metrics.map((m) => m.toJson()).toList(),
      'wateringLogs': wateringLogs,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
