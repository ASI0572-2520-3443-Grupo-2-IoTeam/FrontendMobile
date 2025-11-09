import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/plants/presentation/providers/plant_provider.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';

class PlantDetailView extends StatelessWidget {
  final String plantId;
  const PlantDetailView({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlantProvider>(context, listen: false);
    final plant = provider.plants.firstWhere(
      (p) => p.id.toString() == plantId,
      orElse: () => Plant.empty(),
    );
    if (plant.id == null || plant.id.toString().isEmpty) {
      return Scaffold(
        body: Center(
            child: Text('Planta no encontrada',
                style: TextStyle(color: Colors.red))),
      );
    }
    final lastMetric = plant.metrics.isNotEmpty ? plant.metrics.last : null;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Fondo glass
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.85),
                  Colors.blueGrey.withOpacity(0.12)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: plant.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Image.network(
                        plant.imgUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          height: 120,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Icon(Icons.local_florist, size: 60),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    plant.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(plant.type, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bio:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(plant.bio, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        Divider(),
                        const SizedBox(height: 8),
                        Text('Último riego:', style: Theme.of(context).textTheme.bodyMedium),
                        Text(plant.lastWatered, style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text('Próximo riego:', style: Theme.of(context).textTheme.bodyMedium),
                        Text(plant.nextWatering, style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 16),
                        Divider(),
                        const SizedBox(height: 8),
                        Text('Métricas:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text('Temperatura', style: Theme.of(context).textTheme.bodySmall),
                                Text('${lastMetric?.temperature ?? 0}°C', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Humedad', style: Theme.of(context).textTheme.bodySmall),
                                Text('${lastMetric?.humidity ?? 0}%', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Luz', style: Theme.of(context).textTheme.bodySmall),
                                Text('${lastMetric?.light ?? 0} lx', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                            Column(
                              children: [
                                Text('H. Suelo', style: Theme.of(context).textTheme.bodySmall),
                                Text('${lastMetric?.soilHumidity ?? 0}%', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: child,
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetricTile(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.blueGrey),
      label: Text('$label: $value'),
      backgroundColor: Colors.white.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
