import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plant_care/plants/application/usecases/get_plants.dart';
import 'package:plant_care/plants/application/usecases/add_plant.dart';
import 'package:plant_care/plants/application/usecases/delete_plant.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';

part 'plants_state.dart';

class PlantsCubit extends Cubit<PlantsState> {
  final GetPlants getPlants;
  final AddPlant addPlant;
  final DeletePlant deletePlant;
  final String userId;
  final String token;

  PlantsCubit({
    required this.getPlants,
    required this.addPlant,
    required this.deletePlant,
    required this.userId,
    required this.token,
  }) : super(PlantsInitial());

  Future<void> fetchPlants() async {
    emit(PlantsLoading());
    try {
      final plants = await getPlants(userId: userId, token: token);
      emit(PlantsLoaded(plants: plants));
    } catch (e) {
      emit(PlantsError(message: e.toString()));
    }
  }

  Future<void> createPlant(Map<String, dynamic> plantData) async {
    emit(PlantsLoading());
    try {
      await addPlant(userId: userId, token: token, plantData: plantData);
      // After adding, fetch plants again to update the list
      final plants = await getPlants(userId: userId, token: token);
      emit(PlantsLoaded(plants: plants));
    } catch (e) {
      emit(PlantsError(message: e.toString()));
    }
  }

  Future<void> removePlant(String plantId) async {
    emit(PlantsLoading());
    try {
      await deletePlant(plantId: plantId, token: token);
      // After deleting, fetch plants again to update the list
      final plants = await getPlants(userId: userId, token: token);
      emit(PlantsLoaded(plants: plants));
    } catch (e) {
      emit(PlantsError(message: e.toString()));
    }
  }
}
