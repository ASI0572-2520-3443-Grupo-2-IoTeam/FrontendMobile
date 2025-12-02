import 'package:flutter/material.dart';

// Lightweight placeholder for PlantDetailView used in dashboard/router.
// Replace with a full implementation when ready.
class PlantDetailView extends StatelessWidget {
  final String plantId;
  const PlantDetailView({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Detail (preview)')),
      body: Center(child: Text('Detail for plant id: $plantId')),
    );
  }
}