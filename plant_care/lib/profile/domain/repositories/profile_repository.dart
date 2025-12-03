import '../entities/achievement.dart';
import '../entities/user_profile.dart';
import '../entities/user_stats.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile(String token);
  Future<UserProfile> updateProfile(String token, Map<String, dynamic> data);
  Future<String> uploadAvatar(String token, String filePath);
  Future<UserStats> getStats(String token);
  Future<List<Achievement>> getAchievements(String token);
}
