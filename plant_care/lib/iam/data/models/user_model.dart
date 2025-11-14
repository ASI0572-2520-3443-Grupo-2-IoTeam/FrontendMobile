import 'package:plant_care/iam/domain/entities/role.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  /// Token opcional devuelto por el backend tras iniciar sesión
  final String? token;

  /// Indica si el usuario está logueado localmente
  final bool isLoggedIn;

  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.password,
    required super.role,
    required super.createdAt,
    required super.updatedAt,
    this.token,
    this.isLoggedIn = false,
  });

  /// 🔸 Crea un UserModel desde una entidad de dominio [User]
  factory UserModel.fromUser(User user, {String? token, bool isLoggedIn = false}) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      password: user.password,
      role: user.role,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      token: token,
      isLoggedIn: isLoggedIn,
    );
  }

  /// 🔸 Deserializa desde JSON (respuesta del backend)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? const Uuid().v4(), // 👈 garantiza tipo String
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: Role.fromString(json['role'] ?? 'user'),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      token: json['token'],
      isLoggedIn: json['isLoggedIn'] ?? false,
    );
  }

  /// 🔸 Serializa a JSON (para enviar al backend)
  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'password': password,
        'role': role.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (token != null) 'token': token,
        'isLoggedIn': isLoggedIn,
      };

  /// 🔸 Copia el objeto con campos modificados
  @override
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? password,
    Role? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
    bool? isLoggedIn,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, username: $username, email: $email, role: ${role.name}, token: $token, isLoggedIn: $isLoggedIn)';
}