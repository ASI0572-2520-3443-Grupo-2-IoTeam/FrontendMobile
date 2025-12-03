import 'package:plant_care/analytics/domain/entities/report_type.dart';

class Report {
  final int id;
  final String userId;
  final String title;
  final String description;
  final ReportType reportType; // ✅ Ahora es enum, no String
  final DateTime createdAt;
  final DateTime? startDate;
  final DateTime? endDate;
  final Map<String, dynamic> data;

  Report({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.reportType,
    required this.createdAt,
    this.startDate,
    this.endDate,
    required this.data,
  });
}
