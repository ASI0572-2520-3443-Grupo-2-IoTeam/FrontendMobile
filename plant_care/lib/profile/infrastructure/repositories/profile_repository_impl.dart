import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_stats.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile(String token) {
    return remoteDataSource.getProfile(token);
  }

  @override
  Future<UserProfile> updateProfile(String token, Map<String, dynamic> data) {
    return remoteDataSource.updateProfile(token, data);
  }

  @override
  Future<String> uploadAvatar(String token, String filePath) {
    return remoteDataSource.uploadAvatar(token, filePath);
  }

  @override
  Future<UserStats> getStats(String token) {
    return remoteDataSource.getStats(token);
  }

  @override
  Future<List<Achievement>> getAchievements(String token) {
    return remoteDataSource.getAchievements(token);
  }
}
