import 'package:flutter/material.dart';
import 'package:plant_care/iam/domain/entities/role.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  /// ==========================
  /// 🔹 Registro de usuario
  /// ==========================
  /*@override
  Future<User> register({
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _apiService.register({
        'email': email,
        'username': username,
        'password': password,
        'role': role,
      });

      debugPrint("✅ Respuesta del backend (register): $response");

      // Si el backend devuelve el usuario, usamos esos datos.
      // Si no, generamos los faltantes localmente.
      return UserModel.fromJson({
        'id': response['id'] ?? const Uuid().v4(),
        'email': response['email'] ?? email,
        'username': response['username'] ?? username,
        'password': password,
        'role': response['role'] ?? role,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e, stack) {
      debugPrint("❌ Error en AuthRepositoryImpl.register(): $e");
      debugPrint(stack.toString());
      throw Exception("Error en AuthRepositoryImpl.register(): $e");
    }
  }

  /// ==========================
  /// 🔹 Inicio de sesión
  /// ==========================
  @override
  Future<Map<String, dynamic>> login({
  required String email,
  required String password,
  }) async {
  final response = await _apiService.login({
    'email': email,
    'password': password,
  });

  // response debe ser Map<String, dynamic> desde tu API
  return {
    'token': response['token'],
    'uuid': response['uuid'],
    'username': response['username'],
  };
  }*/

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    // Como es fake API, simulamos registro creando un User
    final user = User.create(
      username: username,
      email: email,
      password: password,
      role: Role.fromString(role),
    );

    // Convertimos a UserModel y marcamos como logueado
    return UserModel.fromUser(user, token: 'fake-token', isLoggedIn: true);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final userMap = await _apiService.login(email: email, password: password);

      // Creamos un User a partir del Map devuelto por el fake API
      final user = User(
        id: userMap['id']?.toString() ?? '',
        username: userMap['email'].split('@').first, // ejemplo: email -> username
        email: userMap['email'] ?? '',
        password: '', // no almacenamos password real
        role: Role.fromString(
          (userMap['roles'] as List).contains('ROLE_ADMIN') ? 'ADMIN' : 'USER',
        ),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Creamos UserModel con token fake y marcamos como logueado
      return UserModel.fromUser(user, token: 'fake-jwt-token', isLoggedIn: true);
    } catch (e) {
      throw Exception('Login fallido: ${e.toString()}');
    }
  }

}