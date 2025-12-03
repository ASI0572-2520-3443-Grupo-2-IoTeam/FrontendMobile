import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';
import '../../../shared/presentation/widgets/custom_bottom_navbar.dart';
import '../../../plants/presentation/widgets/plant_detail_view.dart';
import '../../../plants/presentation/components/plants_cubit.dart';
import '../../../plants/presentation/providers/plant_provider.dart';
import '../../../iam/presentation/providers/auth_provider.dart';
import '../../../plants/domain/entities/plant.dart';
import '../../../plants/domain/value_objetcs/plant_status.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final userId = auth.currentUser?.id;
    final userName = auth.currentUser?.username ?? "User";
    final token = auth.token;

    if (userId == null || token == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider(
      create: (_) =>
          PlantProvider.createPlantsCubit(userId: userId, token: token)
            ..fetchPlants(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: BlocBuilder<PlantsCubit, PlantsState>(
            builder: (context, state) {
              if (state is PlantsLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Plant> plants = [];
              if (state is PlantsLoaded) {
                plants = state.plants;
              }

              // Calculate metrics
              final totalPlants = plants.length;

              double avgHumidity = 0;
              double avgTemperature = 0;
              int alerts = 0;

              if (plants.isNotEmpty) {
                double totalHum = 0;
                double totalTemp = 0;
                int countWithMetrics = 0;

                for (var p in plants) {
                  if (p.status != PlantStatus.HEALTHY) {
                    alerts++;
                  }
                  final metric = p.latestMetric;
                  if (metric != null) {
                    totalHum += metric.humidity;
                    totalTemp += metric.temperature;
                    countWithMetrics++;
                  }
                }

                if (countWithMetrics > 0) {
                  avgHumidity = totalHum / countWithMetrics;
                  avgTemperature = totalTemp / countWithMetrics;
                }
              }

              final metrics = [
                {
                  "title": "Humidity",
                  "value": "${avgHumidity.toStringAsFixed(1)}%",
                  "icon": Icons.water_drop,
                  "color": Colors.blue,
                },
                {
                  "title": "Temperature",
                  "value": "${avgTemperature.toStringAsFixed(1)}°C",
                  "icon": Icons.thermostat,
                  "color": Colors.orange,
                },
                {
                  "title": "Total Plants",
                  "value": "$totalPlants",
                  "icon": Icons.local_florist,
                  "color": Colors.green,
                },
                {
                  "title": "Alerts",
                  "value": "$alerts",
                  "icon": Icons.warning_amber,
                  "color": Colors.red,
                },
              ];

              // Find plant needing attention
              Plant? needsAttentionPlant;
              try {
                needsAttentionPlant = plants.firstWhere(
                  (p) =>
                      p.status == PlantStatus.CRITICAL ||
                      p.status == PlantStatus.DANGER ||
                      p.status == PlantStatus.WARNING,
                );
              } catch (_) {
                // If no critical/danger/warning, maybe show the one with lowest soil humidity if available?
                // For now, just leave it null
              }

              // Generate recent activity
              // We'll simulate activity based on lastWatered date
              final recentActivity = plants.map((p) {
                final now = DateTime.now();
                final diff = now.difference(p.lastWatered);
                String timeText;
                if (diff.inMinutes < 60) {
                  timeText = "${diff.inMinutes} min ago";
                } else if (diff.inHours < 24) {
                  timeText = "${diff.inHours} hrs ago";
                } else {
                  timeText = "${diff.inDays} days ago";
                }

                return {
                  "icon": Icons.water_drop,
                  "text": "${p.name} was watered",
                  "time": timeText,
                  "date": p.lastWatered,
                };
              }).toList();

              // Sort by date descending
              recentActivity.sort(
                (a, b) =>
                    (b["date"] as DateTime).compareTo(a["date"] as DateTime),
              );

              // Take top 3
              final displayActivity = recentActivity.take(3).toList();

              return Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  children: [
                    // Header
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $userName",
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Here’s the latest update about your plants 🌱",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Metrics
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: metrics
                          .map(
                            (m) => InkWell(
                              borderRadius: BorderRadius.circular(16),
                              splashColor: (m["color"] as Color).withOpacity(
                                0.2,
                              ),
                              onTap: () {},
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

                    const SizedBox(height: 32),

                    // Needs Attention
                    if (needsAttentionPlant != null) ...[
                      Text(
                        "Needs Attention",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        child: InkWell(
                          onTap: () {
                            context.push("/plant/${needsAttentionPlant!.id}");
                          },
                          splashColor: AppTheme.primaryGreen.withOpacity(0.2),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppTheme.secondaryGreen.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      needsAttentionPlant.imgUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.local_florist,
                                              size: 40,
                                              color: AppTheme.primaryGreen,
                                            );
                                          },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        needsAttentionPlant.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _statusText(needsAttentionPlant.status),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppTheme.criticalColor,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Last watered: ${_formatDate(needsAttentionPlant.lastWatered)}",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => context.push(
                                    "/plant/${needsAttentionPlant!.id}",
                                  ),
                                  child: const Text("View"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Recent Activity
                    if (displayActivity.isNotEmpty) ...[
                      Text(
                        "Recent Activity",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Column(
                          children: displayActivity
                              .map(
                                (a) => _ActivityItem(
                                  icon: a["icon"] as IconData,
                                  text: a["text"] as String,
                                  time: a["time"] as String,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ] else ...[
                      Text(
                        "Recent Activity",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("No recent activity recorded."),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      ),
    );
  }

  String _statusText(PlantStatus s) {
    switch (s) {
      case PlantStatus.HEALTHY:
        return 'Healthy';
      case PlantStatus.WARNING:
        return 'Needs checkup';
      case PlantStatus.CRITICAL:
        return 'Critical condition';
      case PlantStatus.DANGER:
        return 'In Danger';
      case PlantStatus.UNKNOWN:
        return 'Unknown status';
    }
  }

  String _formatDate(DateTime d) {
    // Simple formatter, can be improved
    return "${d.day}/${d.month}/${d.year}";
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [color.withOpacity(0.15), color.withOpacity(0.05)]
              : [color.withOpacity(0.1), Colors.white],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with circular background
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.15),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
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
