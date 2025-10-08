import 'package:flutter/material.dart';
import 'package:plant_care/plants/data/datasources/plant_api_service.dart';
import 'package:plant_care/plants/data/models/plant_model.dart';

import '../../domain/entities/plant_status.dart';

class PlantProvider extends ChangeNotifier {
  final PlantApiService _apiService = PlantApiService();

  List<PlantModel> _plants = [];
  bool _isLoading = false;
  String? _message;
  bool _hasFetched = false; // ⚡ evita múltiples fetches
  String? _lastUserId; // ⚡ guarda el último userId

  List<PlantModel> get plants => _plants;
  bool get isLoading => _isLoading;
  String? get message => _message;

  /// ⚡ Fetch seguro: solo se ejecuta si hay un nuevo usuario o force=true
  Future<void> fetchPlantsByUserId({
    required String userId,
    required String token,
    bool force = false, // para forzar recarga
  }) async {
    // ⚡ Evita fetch innecesario si es el mismo usuario y no se fuerza
    if (_hasFetched && !force && _lastUserId == userId) return;

    _setLoading(true);
    _message = null;

    debugPrint('Fetching plants for user $userId with token $token');

    try {
      final fetchedPlants = await _apiService.getPlantsByUserId(userId, token: token);

      _plants = fetchedPlants
          .map((plant) => PlantModel(
                id: plant.id,
                userId: plant.userId,
                name: plant.name,
                type: plant.type,
                imgUrl: plant.imgUrl,
                humidity: plant.humidity,
                lastWatered: plant.lastWatered,
                nextWatering: plant.nextWatering,
                status: PlantStatus.fromString(plant.status.name),
                bio: plant.bio,
              ))
          .toList();

      if (_plants.isEmpty) {
        _message = "No hay plantas registradas 🌿";
      } else {
        debugPrint('✅ Plantas cargadas: ${_plants.length}');
      }

      _hasFetched = true;
      _lastUserId = userId; // ⚡ actualiza el último usuario
    } on Exception catch (e) {
      if (e.toString().contains('403')) {
        _message = "Acceso denegado: verifica tu token o permisos.";
      } else if (e.toString().contains('404')) {
        _message = "No se encontraron plantas para este usuario.";
      } else {
        _message = "Error al cargar plantas: $e";
      }
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
    _lastUserId = null; // ⚡ reinicia el último usuario
    notifyListeners();
  }
}
