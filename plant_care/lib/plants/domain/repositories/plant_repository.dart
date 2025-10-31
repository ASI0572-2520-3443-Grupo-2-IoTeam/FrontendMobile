import 'package:plant_care/plants/data/models/plant_model.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';

abstract class PlantRepository {
  /// Obtiene una planta por su ID.
  Future<Plant?> getPlantById(String id);

  /// Obtiene todas las plantas del usuario autenticado.
  Future<List<Plant>> fetchPlantsByUserId(String userId, String token);

  /// Agrega una nueva planta y retorna la creada por el backend.
  Future<Plant> addPlant(Plant plant);

  /// Actualiza una planta existente.
  Future<void> updatePlant(String id, Plant plant);

  /// Elimina una planta por su ID.
  Future<void> deletePlant(String id);
}
