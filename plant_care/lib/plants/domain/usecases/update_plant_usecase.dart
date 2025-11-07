
import 'package:plant_care/plants/infrastructure/repositories/plant_repository.dart';

import '../entities/plant.dart';

class UpdatePlantUseCase {
  final PlantRepository repository;
  UpdatePlantUseCase(this.repository);

  Future<void> call(String id, Plant plant) async {
    await repository.updatePlant(id, plant);
  }
}