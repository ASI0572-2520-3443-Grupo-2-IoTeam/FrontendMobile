import 'package:plant_care/plants/infrastructure/models/plant_model.dart';
import 'package:uuid/uuid.dart';

class PlantLocalDataProvider {
  Future<List<PlantModel>>? fetchPlant() {
    return null;
  }

  Future<PlantModel>? getProduct(Uuid id) {
    return null;
  }

  Future<bool>? cacheProduct(PlantModel plant) {
    //todo: cache model
    return null;
  }

  Future<bool>? cacheProducts(List<PlantModel> plants) {
    //todo: cache model
    return null;
  }
}