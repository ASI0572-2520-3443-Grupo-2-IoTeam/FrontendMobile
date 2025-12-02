class CommunityMember {
  final String userId;
  final String username;
  final String role;
  final DateTime joinedAt;

  CommunityMember({
    required this.userId,
    required this.username,
    required this.role,
    required this.joinedAt,
  });

  factory CommunityMember.fromJson(Map<String, dynamic> json) {
    return CommunityMember(
      userId: json['userId'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );
  }
}
