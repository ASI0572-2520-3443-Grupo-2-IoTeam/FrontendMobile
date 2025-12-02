import 'package:plant_care/plants/domain/repositories/plant_repository.dart';

class DeletePlant {
  final PlantRepository repository;

  DeletePlant(this.repository);

  Future<void> call({required String plantId, required String token}) {
    return repository.deletePlant(plantId, token);
  }
}
