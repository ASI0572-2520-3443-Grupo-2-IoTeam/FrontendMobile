import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/repositories/plant_repository.dart';

class AddPlant {
  final PlantRepository repository;

  AddPlant(this.repository);

  Future<Plant> call({
    required String userId,
    required String token,
    required Map<String, dynamic> plantData,
  }) {
    return repository.addPlant(userId, token, plantData);
  }
}
