import 'package:plant_care/iam/domain/entities/role.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/user_model.dart';

/*class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

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

}*/

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;

  AuthRepositoryImpl(this._apiService);

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    final userMap = await _apiService.register({
      'email': email,
      'username': username,
      'password': password,
      'role': role,
    });

    final user = User(
      id: userMap['uuid'] ?? '',
      username: username,
      email: email,
      password: password,
      role: Role.fromString(role),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return UserModel.fromUser(user, token: userMap['token'], isLoggedIn: true);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final userMap = await _apiService.login(email: email, password: password);

    final user = User(
      id: userMap['uuid'] ?? '',
      username: userMap['username'] ?? email.split('@')[0],
      email: email,
      password: '',
      role: Role.user,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return UserModel.fromUser(user, token: userMap['token'], isLoggedIn: true);
  }
}