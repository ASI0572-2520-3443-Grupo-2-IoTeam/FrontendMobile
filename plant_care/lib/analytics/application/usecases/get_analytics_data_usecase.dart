import 'package:plant_care/analytics/domain/entities/analytics_data.dart';
import 'package:plant_care/analytics/domain/repositories/analytics_repository.dart';

class GetAnalyticsDataUseCase {
  final AnalyticsRepository repository;

  GetAnalyticsDataUseCase(this.repository);

  Future<AnalyticsData> call(String userId, String token) async {
    return await repository.getAnalyticsData(userId, token);
  }
}
