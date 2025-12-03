import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';

class DeleteReportUseCase {
  final AnalyticsRepository repository;

  DeleteReportUseCase(this.repository);

  Future<void> call(String reportId, String token) async {
    await repository.deleteReport(reportId, token);
  }
}
