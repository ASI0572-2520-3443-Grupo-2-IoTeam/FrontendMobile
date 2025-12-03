import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/value_objetcs/plant_status.dart';
import 'package:plant_care/plants/presentation/components/plants_cubit.dart';
import 'package:plant_care/plants/presentation/pages/plant_detail_page.dart';
import 'package:plant_care/plants/presentation/pages/add_plant_page.dart';

class PlantsListPage extends StatelessWidget {
  const PlantsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surfaceContainerLowest;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        top: false,
        bottom: true,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              backgroundColor: backgroundColor,
              surfaceTintColor: Colors.transparent,
              title: Text(
                'My Plants',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                ),
              ),
              centerTitle: false,
              expandedHeight: 120,
              floating: true,
              pinned: true,
              actions: [
                _ModernIconButton(
                  icon: Icons.search_rounded,
                  onPressed: () {},
                  isPrimary: false,
                ),
                const SizedBox(width: 8),
                _ModernIconButton(
                  icon: Icons.add_rounded,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<PlantsCubit>(),
                          child: const AddPlantPage(),
                        ),
                      ),
                    );
                  },
                  isPrimary: true,
                ),
                const SizedBox(width: 20),
              ],
            ),

            BlocBuilder<PlantsCubit, PlantsState>(
              builder: (context, state) {
                if (state is PlantsLoading) {
                  return const SliverFillRemaining(child: _LoadingState());
                }
                if (state is PlantsError) {
                  return SliverFillRemaining(
                    child: _ErrorState(message: state.message),
                  );
                }
                if (state is PlantsLoaded) {
                  if (state.plants.isEmpty) {
                    return const SliverFillRemaining(child: _EmptyState());
                  }
                  return _PlantsSliverGrid(plants: state.plants);
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 40 + MediaQuery.of(context).padding.bottom,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Botón moderno reutilizable
class _ModernIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ModernIconButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: isPrimary
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
              )
            : null,
        color: isPrimary ? null : theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: isPrimary
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.outlineVariant.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isPrimary
                ? theme.colorScheme.primary.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 22,
          color: isPrimary ? Colors.white : theme.colorScheme.onSurfaceVariant,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _PlantsSliverGrid extends StatelessWidget {
  final List<Plant> plants;

  const _PlantsSliverGrid({required this.plants});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 900
        ? 4
        : (screenWidth >= 600 ? 3 : 2);

    const double horizontalPadding = 20.0 * 2.0;
    const double spacing = 16.0;
    final totalSpacing = spacing * (crossAxisCount - 1);
    final cellWidth =
        (screenWidth - horizontalPadding - totalSpacing) / crossAxisCount;

    final desiredHeight = cellWidth * 1.6;
    final childAspectRatio = cellWidth / desiredHeight;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final plant = plants[index];
          return _ModernPlantCard(plant: plant);
        }, childCount: plants.length),
      ),
    );
  }
}

class _ModernPlantCard extends StatelessWidget {
  final Plant plant;

  const _ModernPlantCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<PlantsCubit>(),
              child: PlantDetailPage(plant: plant),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.network(
                  plant.imgUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      size: 48,
                      color: theme.colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // Status Badge
              Positioned(
                top: 12,
                right: 12,
                child: _ModernStatusBadge(status: plant.status),
              ),

              // Glass Content Card at Bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.15),
                          ],
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Type Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              plant.type.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.8,
                                fontSize: 9,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Plant Name
                          Text(
                            plant.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                              fontSize: 15,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 1),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Location
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_on_rounded,
                                  size: 11,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  plant.location,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernStatusBadge extends StatelessWidget {
  final PlantStatus status;
  const _ModernStatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _getStatusProperties(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.white.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 10, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            _statusText(status),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getStatusProperties(PlantStatus status) {
    switch (status) {
      case PlantStatus.HEALTHY:
        return (const Color(0xFF34C759), Icons.check_circle_rounded);
      case PlantStatus.WARNING:
        return (const Color(0xFFFF9500), Icons.warning_rounded);
      case PlantStatus.CRITICAL:
        return (const Color(0xFFAF52DE), Icons.priority_high_rounded);
      case PlantStatus.DANGER:
        return (const Color(0xFFFF3B30), Icons.error_rounded);
      case PlantStatus.UNKNOWN:
        return (const Color(0xFF8E8E93), Icons.help_rounded);
    }
  }

  String _statusText(PlantStatus s) {
    switch (s) {
      case PlantStatus.HEALTHY:
        return 'Healthy';
      case PlantStatus.WARNING:
        return 'Warning';
      case PlantStatus.CRITICAL:
        return 'Critical';
      case PlantStatus.DANGER:
        return 'Danger';
      case PlantStatus.UNKNOWN:
        return 'Unknown';
    }
  }
}

// Estados mejorados
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Loading your plants...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primaryContainer.withOpacity(0.3),
                    theme.colorScheme.primaryContainer.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.energy_savings_leaf_rounded,
                size: 80,
                color: theme.colorScheme.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "No plants yet",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Start your garden by adding\nyour first plant",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<PlantsCubit>(),
                      child: const AddPlantPage(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Plant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.errorContainer.withOpacity(0.3),
                    theme.colorScheme.errorContainer.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 80,
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Oops! Something went wrong",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.lightImpact();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
