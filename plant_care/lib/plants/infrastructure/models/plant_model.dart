import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/value_objetcs/plant_status.dart';
import 'package:plant_care/plants/infrastructure/models/plant_metric_model.dart';

class PlantModel {
  final int id;
  final String userId;
  final String name;
  final String type;
  final String imgUrl;
  final String bio;
  final String location;
  final String status; 
  final String lastWatered;
  final String nextWatering;
  final List<PlantMetricModel> metrics;


  PlantModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.type,
    required this.imgUrl,
    required this.bio,
    required this.location,
    required this.status,
    required this.lastWatered,
    required this.nextWatering,
    required this.metrics,
  });

  
  factory PlantModel.fromJson(Map<String, dynamic> json) {
    int toInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    final metricsJson = json['metrics'];
    final metricsList = (metricsJson is List)
        ? metricsJson
              .map(
                (metricJson) => PlantMetricModel.fromJson(
                  metricJson as Map<String, dynamic>,
                ),
              )
              .toList()
        : <PlantMetricModel>[];

    return PlantModel(
      id: toInt(json['id']),
      userId: (json['userId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      imgUrl: (json['imgUrl'] ?? '').toString(),
      bio: (json['bio'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      lastWatered: (json['lastWatered'] ?? json['last_watered'] ?? '')
          .toString(),
      nextWatering: (json['nextWatering'] ?? json['next_watering'] ?? '')
          .toString(),
      metrics: metricsList,
    );
  }

  Plant toEntity() {
    return Plant(
      id: id,
      userId: userId,
      name: name,
      type: type,
      imgUrl: imgUrl,
      bio: bio,
      location: location,
      status: PlantStatus.fromString(status), 
      lastWatered:
          DateTime.tryParse(lastWatered) ??
          DateTime.fromMillisecondsSinceEpoch(0), 
      nextWatering:
          DateTime.tryParse(nextWatering) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      metrics: metrics
          .map((model) => model.toEntity())
          .toList(), 
    );
  }
}
