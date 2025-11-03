import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/entities/report_type.dart';

class ReportModel extends Report {
  ReportModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.description,
    required super.reportType,
    required super.createdAt,
    super.startDate,
    super.endDate,
    required super.data,
  });

  /// Crear ReportModel desde JSON
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as int,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      reportType: ReportType.fromString(json['reportType'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      data: json['data'] as Map<String, dynamic>,
    );
  }

  /// Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'reportType': reportType.name, // ✅ Usa .name del enum
      'createdAt': createdAt.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'data': data,
    };
  }
}
