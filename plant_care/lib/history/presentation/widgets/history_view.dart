import 'package:flutter/material.dart';
import 'package:plant_care/presentation/theme/theme.dart';
import '../../../presentation/widgets/custom_bottom_navbar.dart';


class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedPlant = "All Plants";

  final List<String> plants = [
    "All Plants",
    "Aloe Vera",
    "Ficus",
    "Basil",
  ];

  // Historial simulado agrupado por días
  final Map<String, List<Map<String, dynamic>>> historyByDay = {
    "Today": [
      {
        "status": "healthy",
        "text": "Aloe Vera was watered",
        "time": "5 min ago",
      },
      {
        "status": "critical",
        "text": "Ficus needs water",
        "time": "1 hr ago",
      },
    ],
    "Yesterday": [
      {
        "status": "warning",
        "text": "Humidity dropped in Aloe Vera",
        "time": "18 hrs ago",
      },
    ],
    "2 days ago": [
      {
        "status": "info",
        "text": "New plant Basil added",
        "time": "2 days ago",
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header + filtro dentro de un Card
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("History",
                          style: Theme.of(context).textTheme.headlineLarge),
                      const SizedBox(height: 4),
                      Text("Track all recent plant activities",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 16),

                      // Filtro por planta
                      DropdownButtonFormField<String>(
                        initialValue: selectedPlant,
                        items: plants
                            .map((p) =>
                                DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedPlant = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Filter by Plant",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Historial agrupado por días
              Expanded(
                child: ListView(
                  children: historyByDay.entries.map((entry) {
                    final day = entry.key;
                    final events = entry.value;

                    // Filtro
                    final filteredEvents = selectedPlant == "All Plants"
                        ? events
                        : events
                            .where((e) => e["text"]
                                .toString()
                                .contains(selectedPlant))
                            .toList();

                    if (filteredEvents.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Título del día
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 4),
                          child: Text(
                            day,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),

                        // Notificaciones
                        ...filteredEvents.map((item) {
                          final status = item["status"] as String;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppTheme.getStatusColor(status)
                                      .withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  AppTheme.getStatusIcon(status),
                                  color: AppTheme.getStatusColor(status),
                                ),
                              ),
                              title: Text(item["text"],
                                  style:
                                      Theme.of(context).textTheme.bodyLarge),
                              subtitle: Text(item["time"],
                                  style:
                                      Theme.of(context).textTheme.bodySmall),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),

      // Barra de navegación inferior
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
