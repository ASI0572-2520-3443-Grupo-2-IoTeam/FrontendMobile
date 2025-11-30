import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_care/plants/domain/entities/plant.dart';
import 'package:plant_care/plants/domain/value_objetcs/plant_status.dart';
import 'package:plant_care/plants/presentation/cubit/plants_cubit.dart';
import 'package:plant_care/plants/presentation/pages/plant_detail_page.dart';

class PlantsListPage extends StatelessWidget {
  const PlantsListPage({super.key});

  @override
  Widget build(BuildContext context) {
   
    const backgroundColor = Color(0xFFF2F2F7);

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
              surfaceTintColor:
                  Colors.transparent, 
              title: const Text(
                'Mis Plantas',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.0, 
                ),
              ),
              centerTitle: false,
              expandedHeight: 120,
              floating: true,
              pinned: true,
              actions: [
                
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    
                  },
                ),
                
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black, 
                    ),
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                  onPressed: () {
                   
                    HapticFeedback.lightImpact();
                    
                  },
                ),
                const SizedBox(width: 16),
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

class _PlantsSliverGrid extends StatelessWidget {
  final List<Plant> plants;

  const _PlantsSliverGrid({required this.plants});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth >= 900
        ? 4
        : (screenWidth >= 600 ? 3 : 2);

    const double horizontalPadding =
        20.0 * 2.0; 
    const double spacing = 16.0;
    final totalSpacing = spacing * (crossAxisCount - 1);
    final cellWidth =
        (screenWidth - horizontalPadding - totalSpacing) / crossAxisCount;

    final desiredHeight = cellWidth * 1.35;
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
          return _AppleStyleCard(plant: plant);
        }, childCount: plants.length),
      ),
    );
  }
}

class _AppleStyleCard extends StatelessWidget {
  final Plant plant;

  const _AppleStyleCard({required this.plant});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlantDetailPage(plant: plant)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Image.network(
                        plant.imgUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _StatusBadge(status: plant.status),
                  ),
                ],
              ),
            ),

            // Info inferior
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plant.type.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8E8E93),
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 12,
                          color: Color(0xFF007AFF),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            plant.location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF007AFF),
                              fontWeight: FontWeight.w500,
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
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PlantStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {

    Color color;
    switch (status) {
      case PlantStatus.HEALTHY:
        color = const Color(0xFF34C759);
        break; // Green
      case PlantStatus.WARNING:
        color = const Color(0xFFFF9500);
        break; // Orange
      case PlantStatus.CRITICAL:
        color = const Color(0xFFFF3B30);
        break; // Red
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            _statusText(status),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(PlantStatus s) => s.toString().split('.').last;
}


class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    ); 
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.energy_savings_leaf_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "Without plants",
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  const _ErrorState({required this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }
}
