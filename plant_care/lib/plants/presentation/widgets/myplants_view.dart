import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import '../pages/plants_list_page.dart';
import '../providers/plant_provider.dart';

class MyPlantsView extends StatelessWidget {
  const MyPlantsView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.currentUser?.id;
    final token = auth.token;

    if (userId == null || token == null) {
    
      return const PlantsListPage();
    }

    return BlocProvider(
      create: (_) =>
          PlantProvider.createPlantsCubit(userId: userId, token: token)
            ..fetchPlants(),
      child: const PlantsListPage(),
    );
  }
}
