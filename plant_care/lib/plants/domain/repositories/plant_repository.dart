import 'package:plant_care/plants/domain/entities/plant.dart';

abstract class PlantRepository {
  Future<List<Plant>> getPlants(String userId, String token);
  Future<Plant> addPlant(
    String userId,
    String token,
    Map<String, dynamic> plantData,
  );
  Future<void> deletePlant(String plantId, String token);
}
