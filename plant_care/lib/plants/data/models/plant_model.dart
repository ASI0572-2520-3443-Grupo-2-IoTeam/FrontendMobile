import 'package:plant_care/plants/domain/entities/plant.dart';

import '../../domain/entities/plant_status.dart';
  
class PlantModel extends Plant {

  PlantModel({
    required int id,
    required String userId,
    required String name,
    required String type,
    required String imgUrl,
    required double humidity,
    required String lastWatered,
    required String nextWatering,
    required PlantStatus status,
    required String bio,
  }) : super(
          id: id,
          userId: userId,
          name: name,
          type: type,
          imgUrl: imgUrl,
          humidity: humidity,
          lastWatered: lastWatered,
          nextWatering: nextWatering,
          status: status,
          bio: bio,
        );

  /// Crear PlantModel desde JSON
  factory PlantModel.fromJson(Map<String, dynamic> json) {
  return PlantModel(
    id: json['id'] as int,
    userId: json['userId'] as String,
    name: json['name'] as String,
    type: json['type'] as String,
    imgUrl: json['imgUrl'] as String,
    humidity: (json['humidity'] as num).toDouble(),
    lastWatered: json['lastWatered'] as String,
    nextWatering: json['nextWatering'] as String,
    status: PlantStatus.fromString(json['status'] as String), // ⚡
    bio: json['bio'] as String,
  );
}

  /// Convertir a JSON
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
      'status': status.name, // ⚡ usar name de la clase domain
      'bio': bio,
    };
  }
}
