import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';

class CreateReportUseCase {
  final AnalyticsRepository repository;

  CreateReportUseCase(this.repository);

  Future<Report> call(Report report, String token) async {
    return await repository.createReport(report, token);
  }
}
