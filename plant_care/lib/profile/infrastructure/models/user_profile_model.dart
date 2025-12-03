import '../../domain/entities/user_profile.dart';
import 'user_stats_model.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.uuid,
    required super.email,
    required super.username,
    super.fullName,
    super.phone,
    super.bio,
    super.location,
    super.avatarUrl,
    super.joinDate,
    super.lastLogin,
    super.stats,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString();
    final lastName = json['lastName']?.toString();
    final computedFullName = _composeFullName(
      explicitFullName: json['fullName']?.toString(),
      name: json['name']?.toString(),
      firstName: firstName,
      lastName: lastName,
    );

    return UserProfileModel(
      uuid: json['uuid']?.toString() ?? json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      fullName: computedFullName,
      phone: json['phone']?.toString(),
      bio: json['bio']?.toString(),
      location: json['location']?.toString(),
      avatarUrl: json['avatarUrl']?.toString(),
      joinDate: _parseDate(json['joinDate']),
      lastLogin: _parseDate(json['lastLogin']),
      stats: json['stats'] is Map<String, dynamic>
          ? UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
    );
  }

  static String? _composeFullName({
    String? explicitFullName,
    String? name,
    String? firstName,
    String? lastName,
  }) {
    if (explicitFullName != null && explicitFullName.isNotEmpty) return explicitFullName;
    if (name != null && name.isNotEmpty) return name;
    final pieces = [firstName, lastName].where((p) => p != null && p.isNotEmpty).toList();
    if (pieces.isEmpty) return null;
    return pieces.join(' ');
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    final text = value.toString();
    if (text.isEmpty) return null;
    return DateTime.tryParse(text);
  }
}
