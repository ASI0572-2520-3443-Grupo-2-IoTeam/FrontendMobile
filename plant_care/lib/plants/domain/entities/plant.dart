import 'package:plant_care/plants/domain/entities/plant_metric.dart';
import 'plant_status.dart';

class Plant {
  final int id;
  final String userId;
  final String name;
  final String type;
  final String imgUrl;
  final double humidity;
  final String lastWatered;
  final String nextWatering;
  final String status;
  final String bio;
  final String location;
  final List<PlantMetric> metrics;
  final List<dynamic> wateringLogs;
  final String createdAt;
  final String updatedAt;

  Plant({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.imgUrl,
    required this.humidity,
    required this.lastWatered,
    required this.nextWatering,
    required this.status,
    required this.bio,
    required this.location,
    required this.metrics,
    required this.wateringLogs,
    required this.createdAt,
    required this.updatedAt,
  });

  static Plant empty() {
    return Plant(
      id: 0,
      userId: '',
      name: '',
      type: '',
      imgUrl: '',
      humidity: 0.0,
      lastWatered: '',
      nextWatering: '',
      status: '',
      bio: '',
      location: '',
      metrics: [],
      wateringLogs: [],
      createdAt: '',
      updatedAt: '',
    );
  }

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      humidity: (json['humidity'] ?? 0).toDouble(),
      lastWatered: json['lastWatered'] ?? '',
      nextWatering: json['nextWatering'] ?? '',
      status: json['status'] ?? '',
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      metrics: (json['metrics'] as List<dynamic>? ?? []).map((e) => PlantMetric.fromJson(e)).toList(),
      wateringLogs: json['wateringLogs'] as List<dynamic>? ?? [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
