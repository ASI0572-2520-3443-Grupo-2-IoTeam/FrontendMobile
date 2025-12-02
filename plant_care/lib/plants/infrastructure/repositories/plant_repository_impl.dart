import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/repositories/plant_repository.dart';
import 'package:plant_care/plants/infrastructure/datasources/plant_remote_datasource.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantRemoteDataSource remoteDataSource;

  PlantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Plant>> getPlants(String userId, String token) async {
    try {
      final plantModels = await remoteDataSource.getPlants(userId, token);
      return plantModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching plants: $e');
    }
  }

  @override
  Future<Plant> addPlant(
    String userId,
    String token,
    Map<String, dynamic> plantData,
  ) async {
    try {
      final plantModel = await remoteDataSource.addPlant(
        userId,
        token,
        plantData,
      );
      return plantModel.toEntity();
    } catch (e) {
      throw Exception('Error adding plant: $e');
    }
  }

  @override
  Future<void> deletePlant(String plantId, String token) async {
    try {
      await remoteDataSource.deletePlant(plantId, token);
    } catch (e) {
      throw Exception('Error deleting plant: $e');
    }
  }
}
