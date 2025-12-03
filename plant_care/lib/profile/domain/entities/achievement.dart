class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final DateTime? earnedDate;
  final String status;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.status,
    this.earnedDate,
  });
}
