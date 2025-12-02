import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plant_care/plants/infrastructure/datasources/plant_remote_datasource.dart';
import 'package:plant_care/plants/infrastructure/repositories/plant_repository_impl.dart';
import 'package:plant_care/plants/application/usecases/get_plants.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/presentation/pages/plant_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';

// PlantDetailView: carga la lista de plantas desde el backend y muestra
// la vista de detalle para la planta cuyo id se pase por ruta.
class PlantDetailView extends StatelessWidget {
  final String plantId;
  const PlantDetailView({super.key, required this.plantId});

  Future<Plant?> _fetchPlant({
    required String userId,
    required String token,
  }) async {
    final client = http.Client();
    final remote = PlantRemoteDataSourceImpl(client: client);
    final repo = PlantRepositoryImpl(remoteDataSource: remote);
    final getPlants = GetPlants(repo);

    try {
      final plants = await getPlants.call(userId: userId, token: token);
      final matches = plants.where((p) => p.id.toString() == plantId);
      return matches.isEmpty ? null : matches.first;
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.currentUser?.id;
    final token = auth.token;

    if (userId == null || token == null) {
      return const Scaffold(
        body: Center(child: Text('Unauthenticated user')),
      );
    }

    return FutureBuilder<Plant?>(
      future: _fetchPlant(userId: userId, token: token),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: \\${snapshot.error}')),
          );
        }
        final plant = snapshot.data;
        if (plant == null) {
          return const Scaffold(
            body: Center(child: Text('Plant not found')),
          );
        }
        return PlantDetailPageContent(plant: plant);
      },
    );
  }
}
