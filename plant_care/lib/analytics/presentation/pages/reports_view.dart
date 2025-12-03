import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_care/analytics/presentation/providers/analytics_provider.dart';
import 'package:plant_care/iam/presentation/providers/auth_provider.dart';
import 'package:plant_care/shared/presentation/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = context.read<AuthProvider>();
    final analyticsProvider = context.read<AnalyticsProvider>();
    final userId = authProvider.currentUser?.id;
    final token = authProvider.token;

    if (userId != null && token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        analyticsProvider.fetchReports(userId: userId, token: token);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyticsProvider = context.watch<AnalyticsProvider>();
    final reports = analyticsProvider.reports;
    final isLoading = analyticsProvider.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Reportes",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${reports.length} reportes generados",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/dashboard'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de reportes
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : reports.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 80,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  analyticsProvider.message ??
                                      "No hay reportes disponibles",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              final authProvider = context.read<AuthProvider>();
                              final userId = authProvider.currentUser?.id;
                              final token = authProvider.token;
                              if (userId != null && token != null) {
                                await analyticsProvider.fetchReports(
                                  userId: userId,
                                  token: token,
                                  force: true,
                                );
                              }
                            },
                            child: ListView.builder(
                              itemCount: reports.length,
                              itemBuilder: (context, index) {
                                final report = reports[index];
                                return _buildReportCard(context, report);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, dynamic report) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _showReportDetails(context, report);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      report.title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getReportTypeColor(report.reportType.name)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      report.reportType.displayName,
                      style: TextStyle(
                        color: _getReportTypeColor(report.reportType.name),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today,
                      size: 16, color: AppTheme.textLight),
                  const SizedBox(width: 6),
                  Text(
                    dateFormat.format(report.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.delete, color: AppTheme.criticalColor),
                    iconSize: 20,
                    onPressed: () => _confirmDelete(context, report),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getReportTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'daily':
        return Colors.blue;
      case 'weekly':
        return Colors.green;
      case 'monthly':
        return Colors.orange;
      case 'custom':
        return Colors.purple;
      default:
        return AppTheme.primaryGreen;
    }
  }

  void _showReportDetails(BuildContext context, dynamic report) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Título
              Text(
                report.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),

              // Badge de tipo
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getReportTypeColor(report.reportType.name)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  report.reportType.displayName,
                  style: TextStyle(
                    color: _getReportTypeColor(report.reportType.name),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Descripción
              Text(
                "Descripción",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                report.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              // Fechas
              Text(
                "Información",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                  "Creado", dateFormat.format(report.createdAt), Icons.event),
              if (report.startDate != null)
                _buildInfoRow("Fecha Inicio",
                    dateFormat.format(report.startDate), Icons.play_arrow),
              if (report.endDate != null)
                _buildInfoRow("Fecha Fin",
                    dateFormat.format(report.endDate), Icons.stop),

              const SizedBox(height: 16),

              // Datos del reporte
              if (report.data.isNotEmpty) ...[
                Text(
                  "Datos",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    report.data.toString(),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Reporte"),
        content:
            Text("¿Estás seguro de eliminar el reporte '${report.title}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = context.read<AuthProvider>();
              final analyticsProvider = context.read<AnalyticsProvider>();
              final token = authProvider.token;

              if (token != null) {
                await analyticsProvider.deleteReport(
                    report.id.toString(), token);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reporte eliminado")),
                  );
                }
              }
            },
            child: Text("Eliminar",
                style: TextStyle(color: AppTheme.criticalColor)),
          ),
        ],
      ),
    );
  }
}
