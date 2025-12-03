import 'package:plant_care/analytics/domain/entities/report.dart';
import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';

class GetReportsUseCase {
  final AnalyticsRepository repository;

  GetReportsUseCase(this.repository);

  Future<List<Report>> call(String userId, String token) async {
    return await repository.fetchReportsByUserId(userId, token);
  }
}
