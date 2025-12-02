import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plant_care/iam/domain/entities/role.dart';
import 'package:plant_care/iam/application/usecases/google_signin_usecase.dart';
import '../../domain/entities/user.dart';
import '../../application/usecases/login_usecase.dart';
import '../../application/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;

  User? _currentUser;
  String? _token;
  bool _isLoading = false;

  AuthProvider({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _googleSignInUseCase = googleSignInUseCase {
    _loadStoredToken();
  }

  // ===== Getters =====
  User? get currentUser => _currentUser;
  String? get token => _token;
  bool get isAuthenticated => _currentUser != null && _token != null;
  bool get isLoading => _isLoading;

  // ===== Login =====
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      final loginResponse =
      await _loginUseCase.execute(email: email, password: password);

      _token = loginResponse.token;

      _currentUser = User(
        id: loginResponse.id,
        email: loginResponse.email,
        username: loginResponse.username,
        password: loginResponse.password,
        role: loginResponse.role,
        createdAt: loginResponse.createdAt,
        updatedAt: loginResponse.updatedAt,
      );

      // Guardar token localmente
      if (_token != null) await _saveToken(_token!);

      debugPrint("✅ Usuario logueado: ${_currentUser?.email}");
    } catch (e) {
      debugPrint("❌ Error al iniciar sesión: $e");
      rethrow;
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

      // Guardar token del registro
      if (user.token != null) await _saveToken(user.token!);

      debugPrint("✅ Usuario registrado: ${_currentUser?.email}");
    } catch (e) {
      debugPrint("❌ Error al registrar usuario: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ===== Google Sign-In =====
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("🚫 Inicio de sesión cancelado por el usuario");
        return;
      }

      final googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      if (idToken == null) throw Exception("No se recibió idToken de Google");

      final response = await _googleSignInUseCase.execute(idToken);

      _token = response['token'] ?? response['jwt'];

      _currentUser = User(
        id: response['uuid'] ?? response['id'] ?? '',
        email: response['email'] ?? googleUser.email,
        username: response['username'] ?? googleUser.displayName ?? "Usuario",
        password: '',
        role: Role.user,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Guardar token
      if (_token != null) await _saveToken(_token!);

      debugPrint("✅ Usuario autenticado con Google: ${_currentUser?.email}");
    } catch (e) {
      debugPrint("❌ Error al iniciar sesión con Google: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // ===== Logout =====
  Future<void> logout() async {
    _currentUser = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token'); //Borra el token anterior
    await GoogleSignIn().signOut();

    debugPrint("👋 Sesión cerrada, token eliminado");
    notifyListeners();
  }

  // ===== Persistencia del token =====
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint("💾 Token guardado localmente");
  }

  Future<void> _loadStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('auth_token');

    if (storedToken != null) {
      _token = storedToken;
      debugPrint("🔁 Token restaurado de sesión previa");
      notifyListeners();
    }
  }

  // ===== Private helper =====
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}