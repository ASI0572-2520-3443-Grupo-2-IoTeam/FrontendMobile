import 'package:plant_care/plants/data/datasources/plant_api_service.dart';
import 'package:plant_care/plants/infrastructure/models/plant_model.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/infrastructure/repositories/plant_repository.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantApiService apiService;

  PlantRepositoryImpl({required this.apiService});

  //  Helper interno: convierte una entidad Plant a su modelo
  PlantModel _toModel(Plant plant) => PlantModel(
        id: plant.id,
        userId: plant.userId,
        name: plant.name,
        type: plant.type,
        imgUrl: plant.imgUrl,
        humidity: plant.humidity,
        lastWatered: plant.lastWatered,
        nextWatering: plant.nextWatering,
        status: plant.status,
        bio: plant.bio,
        location: plant.location,
      );

  //  Helper interno: convierte PlantModel a entidad Plant
  Plant _toEntity(PlantModel model) => Plant(
        id: model.id,
        userId: model.userId,
        name: model.name,
        type: model.type,
        imgUrl: model.imgUrl,
        humidity: model.humidity,
        lastWatered: model.lastWatered,
        nextWatering: model.nextWatering,
        status: model.status,
        bio: model.bio,
        location: model.location,
      );

  @override
  Future<Plant?> getPlantById(String id) async {
    final model = await apiService.getPlantById(id);
    return model != null ? _toEntity(model) : null;
  }

  @override
  Future<List<Plant>> fetchPlantsByUserId(String userId, String token) async {
    final models = await apiService.getPlantsByUserId(userId, token: token);
    return models.map(_toEntity).toList();
  }

  @override
  Future<Plant> addPlant(Plant plant) async {
    final model = _toModel(plant);
    final createdModel = await apiService.addPlant(model);
    return _toEntity(createdModel);
  }

  @override
  Future<void> updatePlant(String id, Plant plant) async {
    final model = _toModel(plant);
    await apiService.updatePlant(id, model);
  }

  @override
  Future<void> deletePlant(String id) async {
    await apiService.deletePlant(id);
  }
}
