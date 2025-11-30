import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_care/plants/domain/entities/plant_metric.dart';

class MetricsCard extends StatelessWidget {
  final PlantMetric metric;

  const MetricsCard({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final lastUpdated = DateFormat('d MMM, hh:mm a').format(metric.createdAt);

    return Card(
      elevation: 0,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header simétrico
            Row(
              children: [
                Expanded(
                  child: _DeviceBadge(deviceId: metric.deviceId),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: theme.hintColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      lastUpdated,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Grid de métricas 2x2 perfectamente simétrico
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Temperature',
                    value: metric.temperature.toStringAsFixed(1),
                    unit: '°C',
                    icon: Icons.thermostat_rounded,
                    accentColor: const Color(0xFFFF6B6B),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MetricTile(
                    label: 'Humidity',
                    value: metric.humidity.toStringAsFixed(0),
                    unit: '%',
                    icon: Icons.water_drop_rounded,
                    accentColor: const Color(0xFF4ECDC4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Light',
                    value: metric.light.toStringAsFixed(0),
                    unit: 'lx',
                    icon: Icons.wb_sunny_rounded,
                    accentColor: const Color(0xFFFFD93D),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MetricTile(
                    label: 'Soil',
                    value: metric.soilHumidity.toStringAsFixed(0),
                    unit: '%',
                    icon: Icons.grass_rounded,
                    accentColor: const Color(0xFF6A994E),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceBadge extends StatelessWidget {
  final String deviceId;
  const _DeviceBadge({required this.deviceId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sensors,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              deviceId,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color accentColor;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentColor.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícono circular
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          const SizedBox(height: 12),

          // Valor y unidad
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Label
          Text(
            label.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}