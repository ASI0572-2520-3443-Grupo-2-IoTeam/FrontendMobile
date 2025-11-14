import 'package:plant_care/plants/infrastructure/models/plant_model.dart';
import 'package:plant_care/plants/infrastructure/repositories/plant_repository.dart';


class AddPlantUseCase {
  final PlantRepository repository;

  AddPlantUseCase(this.repository);

  Future<PlantModel> call(PlantModel plant) async {
    await repository.addPlant(plant);
    return plant;
  }
}