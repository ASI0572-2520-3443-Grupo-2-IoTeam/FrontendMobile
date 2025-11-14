import 'package:plant_care/plants/infrastructure/repositories/plant_repository.dart';

class DeletePlantUseCase {
  final PlantRepository repository;
  DeletePlantUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deletePlant(id);
  }
}