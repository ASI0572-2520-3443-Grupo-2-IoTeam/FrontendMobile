import '../../domain/entities/achievement.dart';

class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.title,
    required super.description,
    required super.icon,
    required super.status,
    super.earnedDate,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      earnedDate: json['earnedDate'] != null && (json['earnedDate'] as String).isNotEmpty
          ? DateTime.tryParse(json['earnedDate'])
          : null,
    );
  }
}
