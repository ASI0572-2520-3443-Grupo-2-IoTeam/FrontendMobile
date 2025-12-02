
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/repositories/plant_repository.dart';

class GetPlants {
  final PlantRepository repository;

  GetPlants(this.repository);

  
  Future<List<Plant>> call({required String userId, required String token}) {
    
    return repository.getPlants(userId, token);
  }
}
