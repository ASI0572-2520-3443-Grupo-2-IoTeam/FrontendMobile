import '../../domain/entities/achievement.dart';
import '../../domain/repositories/profile_repository.dart';

class GetAchievements {
  final ProfileRepository repository;

  GetAchievements(this.repository);

  Future<List<Achievement>> call({required String token}) {
    return repository.getAchievements(token);
  }
}
