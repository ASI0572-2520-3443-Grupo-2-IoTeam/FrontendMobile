
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plant_care/iam/domain/entities/role.dart';
import 'package:plant_care/iam/domain/usecases/google_signin_usecase.dart';

import '../../data/models/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  /*final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase = GoogleSignInUseCase();

  User? _currentUser;
  String? _token;
  bool _isLoading = false;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase;

  // ===== Getters =====
  User? get currentUser => _currentUser;
  String? get userId => _currentUser?.id;
  String? get email => _currentUser?.email;
  String? get token => _token;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  // ===== Login =====
  Future<void> login(String email, String password) async {
  _setLoading(true);
  try {
    final loginResponse = await _loginUseCase.execute(
      email: email,
      password: password,
    );

    final token = loginResponse['token'];
    final userUuid = loginResponse['uuid'];

    _token = token;

    _currentUser = User(
      id: userUuid, // ✅ UUID real del backend
      email: email,
      username: loginResponse['username'] ?? email.split('@')[0],
      password: password,
      role: Role.user,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    debugPrint("✅ Usuario logueado: ${_currentUser?.id}");
    notifyListeners();
  } catch (e) {
    debugPrint("❌ Error al iniciar sesión: $e");
    throw Exception("Error al iniciar sesión: $e");
  } finally {
    _setLoading(false);
  }
}

  // ===== Registro =====
  Future<void> register({
    required String email,
    required String username,
    required String password,
    String role = "USER",
  }) async {
    _setLoading(true);
    try {
      final user = await _registerUseCase.execute(
        email: email,
        username: username,
        password: password,
        role: role,
      );

      _currentUser = user;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error al registrar usuario: $e");
      throw Exception("Error al registrar usuario: $e");
    } finally {
      _setLoading(false);
    }
  }

  // ===== Google Sign-In =====
  Future<void> signInWithGoogle() async {
  _setLoading(true);
  try {
    // Paso 1: obtener cuenta de Google
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      debugPrint("🚫 Inicio de sesión cancelado por el usuario");
      return;
    }

    // Paso 2: obtener token
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final String? idToken = googleAuth.idToken;
    if (idToken == null) throw Exception("No se recibió idToken de Google");

    // Paso 3: usar el caso de uso para enviar token al backend
    final response = await _googleSignInUseCase.execute(idToken);

    // Paso 4: procesar respuesta del backend
    _token = response['token'];
    _currentUser = User(
      id: response['uuid'],
      email: response['email'],
      username: response['username'] ?? googleUser.displayName ?? "Usuario",
      password: '',
      role: Role.user,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    debugPrint("✅ Usuario autenticado con Google: ${_currentUser?.email}");
    notifyListeners();
  } catch (e) {
    debugPrint("❌ Error al iniciar sesión con Google: $e");
    throw Exception("Error al iniciar sesión con Google: $e");
  } finally {
    _setLoading(false);
  }
}

  // ===== Logout =====
  void logout() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }

  // ===== Estado de carga =====
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }*/

  final LoginUseCase _loginUseCase; 
  final RegisterUseCase _registerUseCase;

  UserModel? _currentUser;
  bool _isLoading = false;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase;

  // ===== Getters =====
  UserModel? get currentUser => _currentUser;
  String? get userId => _currentUser?.id;
  String? get email => _currentUser?.email;
  String? get token => _currentUser?.token;
  bool get isAuthenticated => _currentUser?.isLoggedIn ?? false;
  bool get isLoading => _isLoading;

  // ===== Login =====
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final userModel = await _loginUseCase.execute(
        email: email,
        password: password,
      );

      _currentUser = userModel;
      debugPrint("✅ Usuario logueado: ${_currentUser?.id}");
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error al iniciar sesión: $e");
      throw Exception("Error al iniciar sesión: $e");
    } finally {
      _setLoading(false);
    }
  }

  // ===== Registro =====
  Future<void> register({
    required String email,
    required String username,
    required String password,
    String role = "USER",
  }) async {
    _setLoading(true);
    try {
      final userModel = await _registerUseCase.execute(
        email: email,
        username: username,
        password: password,
        role: role,
      );

      _currentUser = userModel;
      debugPrint("✅ Usuario registrado: ${_currentUser?.id}");
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error al registrar usuario: $e");
      throw Exception("Error al registrar usuario: $e");
    } finally {
      _setLoading(false);
    }
  }

  // ===== Logout =====
  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // ===== Estado de carga =====
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
