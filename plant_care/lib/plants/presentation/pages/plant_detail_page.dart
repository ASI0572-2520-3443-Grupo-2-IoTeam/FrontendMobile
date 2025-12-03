import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/value_objetcs/plant_status.dart';
import 'package:plant_care/plants/presentation/widgets/metrics_card.dart';
import 'package:plant_care/plants/presentation/components/plants_cubit.dart';

class PlantDetailPage extends StatelessWidget {
  final Plant plant;

  const PlantDetailPage({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: PlantDetailPageContent(plant: plant),
      ),
    );
  }
}

class PlantDetailPageContent extends StatefulWidget {
  final Plant plant;
  const PlantDetailPageContent({super.key, required this.plant});

  @override
  State<PlantDetailPageContent> createState() => _PlantDetailPageContentState();
}

class _PlantDetailPageContentState extends State<PlantDetailPageContent> {
  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Plant'),
          content: Text(
            'Are you sure you want to delete "${widget.plant.name}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePlant();
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deletePlant() async {
    try {
      await context.read<PlantsCubit>().removePlant(widget.plant.id.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plant deleted successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete plant: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surfaceContainerLowest;

    return Container(
      color: backgroundColor,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                40 + MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.plant.name,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.primaryContainer.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      widget.plant.type.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Info Row modernizado
                  _buildInfoRow(context),
                  const SizedBox(height: 32),

                  // Biography
                  _ModernSectionTitle(
                    title: 'Biography',
                    icon: Icons.auto_stories_rounded,
                  ),
                  const SizedBox(height: 12),
                  _ModernContentCard(
                    child: Text(
                      widget.plant.bio,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                        fontSize: 15,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Irrigation Cycle
                  _ModernSectionTitle(
                    title: 'Irrigation Cycle',
                    icon: Icons.water_drop_rounded,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _WateringTile(
                          label: 'Last watering',
                          date: widget.plant.lastWatered,
                          icon: Icons.water_drop_rounded,
                          color: const Color(0xFF007AFF),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _WateringTile(
                          label: 'Next watering',
                          date: widget.plant.nextWatering,
                          icon: Icons.access_alarm_rounded,
                          color: const Color(0xFFFF9500),
                          isNext: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  _ModernSectionTitle(
                    title: 'Live Sensors',
                    icon: Icons.sensors,
                  ),
                  const SizedBox(height: 12),
                  if (widget.plant.latestMetric != null)
                    MetricsCard(metric: widget.plant.latestMetric!)
                  else
                    _ModernContentCard(
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.sensors_off,
                              size: 48,
                              color: theme.colorScheme.outline.withOpacity(0.5),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Connecting sensors...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380,
      backgroundColor: Colors.transparent,
      stretch: true,
      pinned: true,
      leading: _GlassButton(
        icon: Icons.arrow_back_ios_new,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        _GlassButton(
          icon: Icons.more_horiz,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        title: const Text('Delete Plant'),
                        onTap: () {
                          Navigator.of(context).pop();
                          _showDeleteConfirmation();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.plant.imgUrl, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (widget.plant.status) {
      case PlantStatus.HEALTHY:
        statusColor = const Color(0xFF34C759);
        statusText = 'Healthy';
        statusIcon = Icons.check_circle_rounded;
        break;
      case PlantStatus.WARNING:
        statusColor = const Color(0xFFFF9500);
        statusText = 'Warning';
        statusIcon = Icons.warning_rounded;
        break;
      case PlantStatus.DANGER:
        statusColor = const Color(0xFFFF3B30);
        statusText = 'In danger';
        statusIcon = Icons.error_rounded;
        break;
      case PlantStatus.CRITICAL:
        statusColor = const Color(0xFFAF52DE);
        statusText = 'Critical';
        statusIcon = Icons.priority_high_rounded;
        break;
      case PlantStatus.UNKNOWN:
        statusColor = Colors.grey;
        statusText = 'Unknown';
        statusIcon = Icons.help_rounded;
        break;
    }

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            statusColor.withOpacity(0.25),
                            statusColor.withOpacity(0.15),
                          ]
                        : [
                            statusColor.withOpacity(0.2),
                            statusColor.withOpacity(0.1),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(statusIcon, size: 14, color: statusColor),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        statusText,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            theme.colorScheme.surface.withOpacity(0.6),
                            theme.colorScheme.surface.withOpacity(0.4),
                          ]
                        : [
                            Colors.white.withOpacity(0.7),
                            Colors.white.withOpacity(0.5),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.plant.location,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _GlassButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: IconButton(
              icon: Icon(icon, size: 20, color: Colors.white),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}

class _ModernSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _ModernSectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary.withOpacity(0.15),
                theme.colorScheme.primary.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

class _ModernContentCard extends StatelessWidget {
  final Widget child;

  const _ModernContentCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      theme.colorScheme.surface.withOpacity(0.6),
                      theme.colorScheme.surface.withOpacity(0.4),
                    ]
                  : [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.5),
                    ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _WateringTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final IconData icon;
  final Color color;
  final bool isNext;

  const _WateringTile({
    required this.label,
    required this.date,
    required this.icon,
    required this.color,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formatted = '${date.day}/${date.month}/${date.year}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [color.withOpacity(0.2), color.withOpacity(0.1)]
                  : [color.withOpacity(0.15), color.withOpacity(0.08)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withOpacity(isDark ? 0.3 : 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Glass icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.3), color.withOpacity(0.2)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 16),

              // Label
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),

              // Date
              Text(
                formatted,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: color,
                  letterSpacing: -0.3,
                ),
              ),

              if (isNext) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Mark as watered',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
