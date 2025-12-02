import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_care/plants/presentation/cubit/plants_cubit.dart';
import 'package:plant_care/plants/infrastructure/datasources/plant_remote_datasource.dart';
import 'package:plant_care/plants/infrastructure/repositories/plant_repository_impl.dart';
import 'package:plant_care/plants/application/usecases/get_plants.dart';
import 'package:plant_care/plants/application/usecases/add_plant.dart';
import 'package:plant_care/plants/application/usecases/delete_plant.dart';

// Provider helper que crea y configura las dependencias necesarias
// para obtener plantas desde el backend. Devuelve un PlantsCubit listo
// para ser usado en un BlocProvider.
class PlantProvider extends ChangeNotifier {
  PlantProvider();

  // Crea un PlantsCubit con las implementaciones concretas.
  // `userId` y `token` deben proporcionarse por el AuthProvider.
  static PlantsCubit createPlantsCubit({
    required String userId,
    required String token,
  }) {
    final client = http.Client();
    final remote = PlantRemoteDataSourceImpl(client: client);
    final repo = PlantRepositoryImpl(remoteDataSource: remote);
    final getPlants = GetPlants(repo);
    final addPlant = AddPlant(repo);
    final deletePlant = DeletePlant(repo);
    return PlantsCubit(
      getPlants: getPlants,
      addPlant: addPlant,
      deletePlant: deletePlant,
      userId: userId,
      token: token,
    );
  }
}
