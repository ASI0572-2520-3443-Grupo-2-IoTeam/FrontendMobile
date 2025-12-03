import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:plant_care/analytics/presentation/providers/analytics_provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import 'package:plant_care/plants/presentation/components/plants_cubit.dart';
import 'package:plant_care/plants/presentation/providers/plant_provider.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';
import 'package:plant_care/shared/presentation/widgets/custom_bottom_navbar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  PlantsCubit? _plantsCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = context.read<AuthProvider>();
    final analyticsProvider = context.read<AnalyticsProvider>();
    final userId = authProvider.currentUser?.id;
    final token = authProvider.token;

    if (userId != null && token != null) {
      if (_plantsCubit == null) {
        _plantsCubit = PlantProvider.createPlantsCubit(
          userId: userId,
          token: token,
        );
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _plantsCubit!.fetchPlants();
        analyticsProvider.fetchSensorData(token: token);
      });
    }
  }

  @override
  void dispose() {
    _plantsCubit?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_plantsCubit == null) {
      return Scaffold(
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
      );
    }

    return BlocBuilder<PlantsCubit, PlantsState>(
      bloc: _plantsCubit,
      builder: (context, plantsState) {
        final analyticsProvider = context.watch<AnalyticsProvider>();

        // Solo calcular cuando las plantas cambian y aún no se han calculado
        if (plantsState is PlantsLoaded && analyticsProvider.analyticsData == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            analyticsProvider.calculateAnalyticsFromPlants(plantsState.plants);
          });
        }

        final analyticsData = analyticsProvider.analyticsData;
        final isLoading = analyticsProvider.isLoading || plantsState is PlantsLoading;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async {
                      _plantsCubit!.fetchPlants();
                      final authProvider = context.read<AuthProvider>();
                      final token = authProvider.token;
                      if (token != null) {
                        await analyticsProvider.fetchSensorData(token: token);
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Text(
                            "Analytics",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Overview de tus plantas 🌱",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),

                          if (analyticsData != null) ...[
                            // Métricas principales
                            _buildMetricsGrid(context, analyticsData),
                            const SizedBox(height: 24),

                            // Gráfico de distribución por estado
                            _buildStatusDistribution(context, analyticsData),
                            const SizedBox(height: 24),

                            // Plantas por tipo
                            _buildPlantsByType(context, analyticsData),
                            const SizedBox(height: 24),

                            // Plantas por ubicación
                            _buildPlantsByLocation(context, analyticsData),
                            const SizedBox(height: 24),

                            // Tendencia de riego
                            _buildWateringTrend(context, analyticsData),
                            const SizedBox(height: 32),

                            // Sección de Historial de Sensores
                            _buildSensorDataHistory(context, analyticsProvider),
                          ] else ...[
                            Center(
                              child: Column(
                                children: [
                                  const SizedBox(height: 60),
                                  Icon(
                                    Icons.analytics_outlined,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    analyticsProvider.message ??
                                        "No hay datos disponibles",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  // Métricas en Grid
  Widget _buildMetricsGrid(BuildContext context, dynamic data) {
    final metrics = [
      {
        "title": "Total Plantas",
        "value": "${data.totalPlants}",
        "icon": Icons.local_florist,
        "color": AppTheme.primaryGreen
      },
      {
        "title": "Saludables",
        "value": "${data.healthyPlants}",
        "icon": Icons.check_circle,
        "color": AppTheme.healthyColor
      },
      {
        "title": "Necesitan Agua",
        "value": "${data.needsWateringPlants}",
        "icon": Icons.water_drop,
        "color": AppTheme.warningColor
      },
      {
        "title": "Críticas",
        "value": "${data.criticalPlants}",
        "icon": Icons.warning,
        "color": AppTheme.criticalColor
      },
    ];

    return Column(
      children: [
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.3,
          children: metrics
              .map((m) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(m["icon"] as IconData,
                              color: m["color"] as Color, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            m["value"] as String,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: m["color"] as Color,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m["title"] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        _buildAverageMetrics(context, data),
      ],
    );
  }

  // Promedios de métricas de plantas
  Widget _buildAverageMetrics(BuildContext context, dynamic data) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: AppTheme.primaryGreen, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Promedios de Métricas",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildMetricChip(
                  context,
                  Icons.grass,
                  "Humedad Suelo",
                  "${data.averageHumidity.toStringAsFixed(1)}%",
                  AppTheme.primaryGreen,
                ),
                _buildMetricChip(
                  context,
                  Icons.thermostat,
                  "Temperatura",
                  "${data.averageTemperature.toStringAsFixed(1)}°C",
                  Colors.orange,
                ),
                _buildMetricChip(
                  context,
                  Icons.water_drop,
                  "Humedad Aire",
                  "${data.averageAirHumidity.toStringAsFixed(1)}%",
                  Colors.blue,
                ),
                _buildMetricChip(
                  context,
                  Icons.wb_sunny,
                  "Luz",
                  "${data.averageLight.toStringAsFixed(0)} lux",
                  Colors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(BuildContext context, IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            "$label: ",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  // Distribución por estado (Pie Chart)
  Widget _buildStatusDistribution(BuildContext context, dynamic data) {
    final total = data.totalPlants;
    if (total == 0) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distribución por Estado",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: data.healthyPlants.toDouble(),
                      title:
                          '${((data.healthyPlants / total) * 100).toStringAsFixed(0)}%',
                      color: AppTheme.healthyColor,
                      radius: 80,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: data.needsWateringPlants.toDouble(),
                      title:
                          '${((data.needsWateringPlants / total) * 100).toStringAsFixed(0)}%',
                      color: AppTheme.warningColor,
                      radius: 80,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: data.criticalPlants.toDouble(),
                      title:
                          '${((data.criticalPlants / total) * 100).toStringAsFixed(0)}%',
                      color: AppTheme.criticalColor,
                      radius: 80,
                      titleStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem("Saludables", AppTheme.healthyColor),
        _buildLegendItem("Necesitan Agua", AppTheme.warningColor),
        _buildLegendItem("Críticas", AppTheme.criticalColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Plantas por tipo
  Widget _buildPlantsByType(BuildContext context, dynamic data) {
    final plantsByType = data.plantsByType as Map<String, int>;
    if (plantsByType.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Plantas por Tipo",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...plantsByType.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(entry.key,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: entry.value / data.totalPlants,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryGreen),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text("${entry.value}",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Plantas por ubicación
  Widget _buildPlantsByLocation(BuildContext context, dynamic data) {
    final plantsByLocation = data.plantsByLocation as Map<String, int>;
    if (plantsByLocation.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Plantas por Ubicación",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...plantsByLocation.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 20, color: AppTheme.primaryGreen),
                    const SizedBox(width: 8),
                    Expanded(child: Text(entry.key)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${entry.value}",
                        style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Tendencia de riego
  Widget _buildWateringTrend(BuildContext context, dynamic data) {
    final trends = data.wateringTrends;
    if (trends.isEmpty) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Tendencia de Riego (últimos 7 días)",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < trends.length) {
                            final date = trends[value.toInt()].date;
                            return Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      color: AppTheme.primaryGreen,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                      ),
                      spots: [
                        for (int i = 0; i < trends.length; i++)
                          FlSpot(i.toDouble(), trends[i].count.toDouble()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Historial de datos del sensor desde edge application
  Widget _buildSensorDataHistory(BuildContext context, AnalyticsProvider provider) {
    final sensorData = provider.sensorDataHistory;
    final isLoadingSensor = provider.isLoadingSensorData;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.sensors, color: AppTheme.primaryGreen, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      "Historial de Sensores",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.refresh, color: AppTheme.primaryGreen),
                  onPressed: () async {
                    final authProvider = context.read<AuthProvider>();
                    final token = authProvider.token;
                    if (token != null) {
                      await provider.fetchSensorData(token: token, force: true);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (isLoadingSensor)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (sensorData.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      Icon(Icons.sensors_off, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        "No hay datos del sensor disponibles",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              )
            else
              _buildAverageSensorData(context, sensorData),
          ],
        ),
      ),
    );
  }

  Widget _buildAverageSensorData(BuildContext context, List<dynamic> sensorData) {
    // Calcular promedios de todos los registros
    double avgTemp = 0;
    double avgHumidity = 0;
    double avgSoilMoisture = 0;
    double avgLightLevel = 0;

    for (var data in sensorData) {
      avgTemp += data.temperature;
      avgHumidity += data.humidity;
      avgSoilMoisture += data.soilMoisture;
      avgLightLevel += data.lightLevel;
    }

    final count = sensorData.length;
    avgTemp /= count;
    avgHumidity /= count;
    avgSoilMoisture /= count;
    avgLightLevel /= count;

    final latestData = sensorData.first;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryGreen.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Promedio de $count registros",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                "Último: ${_formatTimestamp(latestData.timestamp)}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildSensorMetric(
                context,
                Icons.thermostat,
                "Temp Promedio",
                "${avgTemp.toStringAsFixed(1)}°C",
              ),
              _buildSensorMetric(
                context,
                Icons.water_drop,
                "Humedad Promedio",
                "${avgHumidity.toStringAsFixed(1)}%",
              ),
              _buildSensorMetric(
                context,
                Icons.grass,
                "Suelo Promedio",
                "${avgSoilMoisture.toStringAsFixed(1)}%",
              ),
              _buildSensorMetric(
                context,
                Icons.wb_sunny,
                "Luz Promedio",
                "${avgLightLevel.toStringAsFixed(0)} lux",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSensorMetric(BuildContext context, IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.primaryGreen),
        const SizedBox(width: 4),
        Text(
          "$label: ",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return "Hace ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "Hace ${difference.inHours}h";
    } else {
      return "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
    }
  }
}
