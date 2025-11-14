import 'package:flutter/material.dart';
import 'package:plant_care/plants/data/datasources/plant_api_service.dart';
import 'package:plant_care/plants/data/repositories/plant_repository_impl.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/infrastructure/repositories/plant_repository.dart';

class PlantProvider extends ChangeNotifier {
  final PlantRepository _repository =
      PlantRepositoryImpl(apiService: PlantApiService());

  List<Plant> _plants = [];
  bool _isLoading = false;
  String? _message;
  bool _hasFetched = false;
  String? _lastUserId;
  bool _fetchBlockedOnError = false;

  List<Plant> get plants => _plants;
  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> fetchPlantsByUserId({
    required String userId,
    required String token,
    bool force = false,
  }) async {
    if ((_hasFetched || _fetchBlockedOnError) && !force && _lastUserId == userId) return; // no más intentos

    _setLoading(true);
    _message = null;

    try {
      final fetchedPlants = await _repository.fetchPlantsByUserId(userId, token);

      _plants = fetchedPlants;

      if (_plants.isEmpty) {
        _message = "No hay plantas registradas 🌿";
      }

      _hasFetched = true;
      _lastUserId = userId;
    } catch (e) {
      _message = "Error al cargar plantas: $e";
      debugPrint(_message);
      _hasFetched = true;
      _fetchBlockedOnError = true;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addPlant(Plant newPlant) async {
    _setLoading(true);
    try {
      final createdPlant = await _repository.addPlant(newPlant);
      _plants.add(createdPlant);
      _message = "Planta agregada exitosamente 🌱";
      notifyListeners();
    } catch (e) {
      _message = "Error al agregar planta: $e";
      debugPrint(_message);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePlant(String plantId) async {
    _setLoading(true);
    try {
      await _repository.deletePlant(plantId);
      _plants.removeWhere((p) => p.id.toString() == plantId);
      _message = "Planta eliminada 🪴";
      notifyListeners();
    } catch (e) {
      _message = "Error al eliminar planta: $e";
      debugPrint(_message);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearPlants() {
    _plants = [];
    _message = null;
    _hasFetched = false;
    _lastUserId = null;
    _fetchBlockedOnError = false; 
    notifyListeners();
  }
}
