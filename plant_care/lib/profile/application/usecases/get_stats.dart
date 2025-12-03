import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/profile_repository.dart';

class GetStats {
  final ProfileRepository repository;

  GetStats(this.repository);

  Future<UserStats> call({required String token}) {
    return repository.getStats(token);
  }
}
