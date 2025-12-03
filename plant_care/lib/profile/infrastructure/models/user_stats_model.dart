import '../../domain/entities/user_stats.dart';

class UserStatsModel extends UserStats {
  const UserStatsModel({
    required super.totalPlants,
    required super.wateringSessions,
    required super.successRate,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalPlants: json['totalPlants'] is int
          ? json['totalPlants'] as int
          : int.tryParse('${json['totalPlants'] ?? 0}') ?? 0,
      wateringSessions: json['wateringSessions'] is int
          ? json['wateringSessions'] as int
          : int.tryParse('${json['wateringSessions'] ?? 0}') ?? 0,
      successRate: json['successRate'] is int
          ? json['successRate'] as int
          : int.tryParse('${json['successRate'] ?? 0}') ?? 0,
    );
  }
}
