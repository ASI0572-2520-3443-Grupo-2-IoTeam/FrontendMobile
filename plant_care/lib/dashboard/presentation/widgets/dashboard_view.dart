import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';
import '../../../shared/presentation/widgets/custom_bottom_navbar.dart';
import '../../../plants/presentation/widgets/plant_detail_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    const metrics = [
      {"title": "Humidity", "value": "65%", "icon": Icons.water_drop, "color": Colors.blue},
      {"title": "Temperature", "value": "22°C", "icon": Icons.thermostat, "color": Colors.orange},
      {"title": "Total Plants", "value": "12", "icon": Icons.local_florist, "color": Colors.green},
      {"title": "Alerts", "value": "3", "icon": Icons.warning_amber, "color": Colors.red},
    ];

    final recentActivity = [
      {"icon": Icons.water_drop, "text": "Ficus was watered", "time": "5 min ago"},
      {"icon": Icons.warning, "text": "Aloe Vera needs water", "time": "1 hr ago"},
      {"icon": Icons.thermostat, "text": "Temperature back to normal", "time": "3 hrs ago"},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Here’s the latest update about your plants 🌱",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Métricas con InkWell
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: metrics
                    .map(
                      (m) => InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: (m["color"] as Color).withOpacity(0.2),
                    onTap: () {
                      // en el futuro: navegación o más métricas
                    },
                    child: _MetricCard(
                      title: m["title"] as String,
                      value: m["value"] as String,
                      icon: m["icon"] as IconData,
                      color: m["color"] as Color,
                    ),
                  ),
                )
                    .toList(),
              ),

              const SizedBox(height: 24),

              // Planta que necesita atención
              Text("Needs Attention",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) =>
                        const PlantDetailView(plantId: "1"),
                        transitionsBuilder: (_, animation, __, child) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          );
                          return SlideTransition(
                              position: offsetAnimation, child: child);
                        },
                      ),
                    );
                  },
                  splashColor: AppTheme.primaryGreen.withOpacity(0.2),
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Imagen de la planta (placeholder)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.secondaryGreen.withOpacity(0.2),
                          ),
                          child: const Icon(Icons.local_florist,
                              size: 40, color: AppTheme.primaryGreen),
                        ),
                        const SizedBox(width: 16),

                        // Info planta
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Aloe Vera",
                                  style:
                                  Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 4),
                              Text("Needs watering",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                      color: AppTheme.criticalColor)),
                              const SizedBox(height: 8),
                              Text("Last watered: 2 days ago",
                                  style: Theme.of(context).textTheme
                                      .bodySmall),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => context.go("/plant/1"),
                          child: const Text("View"),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Actividad reciente
              Text("Recent Activity",
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  children: recentActivity
                      .map((a) => _ActivityItem(
                    icon: a["icon"] as IconData,
                    text: a["text"] as String,
                    time: a["time"] as String,
                  ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}

// Métrica individual
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// Actividad reciente
class _ActivityItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String time;

  const _ActivityItem({
    required this.icon,
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {}, // futuro: ver detalle
      splashColor: AppTheme.primaryGreen.withOpacity(0.15),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        subtitle: Text(time, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}