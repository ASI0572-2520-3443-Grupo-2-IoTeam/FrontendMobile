
import 'package:plant_care/iam/domain/entities/role.dart';
import 'package:uuid/uuid.dart';

class User {
  /// Unique identifier (UUID)
  final String id;

  /// Unique username
  final String username;

  /// Unique email
  final String email;

  /// Hashed password
  final String password;

  /// User role (e.g., admin, user)
  final Role role;

  /// Creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create a new user with generated UUID and timestamps
  factory User.create({
    required String username,
    required String email,
    required String password,
    required Role role,
  }) {
    return User(
      id: const Uuid().v4(),
      username: username,
      email: email,
      password: password,
      role: role,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Deserialize from JSON (from backend)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: Role.fromString(json['role']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Serialize to JSON (to backend)
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
        'role': role.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Helper: copy with modified fields
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    Role? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'User(id: $id, username: $username, email: $email, role: ${role.name})';
}


