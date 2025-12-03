import 'user_stats.dart';

class UserProfile {
  final String uuid;
  final String email;
  final String username;
  final String? fullName;
  final String? phone;
  final String? bio;
  final String? location;
  final String? avatarUrl;
  final DateTime? joinDate;
  final DateTime? lastLogin;
  final UserStats? stats;

  const UserProfile({
    required this.uuid,
    required this.email,
    required this.username,
    this.fullName,
    this.phone,
    this.bio,
    this.location,
    this.avatarUrl,
    this.joinDate,
    this.lastLogin,
    this.stats,
  });
}
