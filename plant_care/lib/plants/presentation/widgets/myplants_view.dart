import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/plants/presentation/providers/plant_provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import 'package:plant_care/plants/data/datasources/plant_api_service.dart';
import 'package:go_router/go_router.dart';

class MyPlantsView extends StatefulWidget {
  const MyPlantsView({super.key});
  @override
  State<MyPlantsView> createState() => _MyPlantsViewState();
}

class _MyPlantsViewState extends State<MyPlantsView> {
  bool _fetched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_fetched) {
        final auth = context.read<AuthProvider>();
        final provider = context.read<PlantProvider>();
        final userId = auth.currentUser?.id;
        final token = auth.token;
        if (userId != null && token != null) {
          _fetched = true;
          PlantApiService.enablePlantsFetch = true;
          provider.fetchPlantsByUserId(userId: userId, token: token);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PlantProvider>();
    final plants = provider.plants;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Mis Plantas', style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        centerTitle: false,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : plants.isEmpty
              ? Center(
                  child: Text(
                    provider.message ?? 'Sin plantas',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: plants.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final p = plants[i];
                    return _PlantCard(
                      name: p.name,
                      type: p.type,
                      imageUrl: p.imgUrl,
                      status: p.status,
                      onTap: () {
                        context.push('/plant/${p.id}');
                      },
                    );
                  },
                ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final String name;
  final String type;
  final String imageUrl;
  final String status;
  final VoidCallback onTap;
  const _PlantCard({
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.status,
    required this.onTap,
  });

  Color _statusColor(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'healthy':
        return Colors.greenAccent.shade700;
      case 'warning':
        return Colors.orangeAccent.shade400;
      case 'critical':
        return Colors.redAccent.shade400;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: cs.outline.withValues(alpha: .2)),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: cs.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(Icons.local_florist, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(context).withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: _statusColor(context),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(type, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
