import 'package:uuid/uuid.dart';

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
  final PlantStatus status;
  final String bio;
  final String location;

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
  });

}

