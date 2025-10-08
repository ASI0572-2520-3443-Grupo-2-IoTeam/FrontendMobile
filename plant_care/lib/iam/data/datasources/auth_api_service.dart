import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class AuthApiService {
  final String baseUrl;

  AuthApiService({this.baseUrl = 'https://fakeapiplant.vercel.app'});
  final List<Map<String, dynamic>> _fakeUsers = [
    {
      "id": "1",
      "useremail": "demo@gmail.com",
      "password": "password",
      "roles": ["ROLE_USER"]
    },
    {
      "id": "2",
      "useremail": "admin@gmail.com",
      "password": "adminpass",
      "roles": ["ROLE_ADMIN", "ROLE_USER"]
    },
    {
      "id": "3",
      "useremail": "sideral@gmail.com",
      "password": "sideral",
      "roles": ["ROLE_USER"]
    }
  ];

  /// ===== Login =====
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simular tiempo de espera de una petición HTTP
    await Future.delayed(Duration(seconds: 1));

    try {
      final user = _fakeUsers.firstWhere(
        (u) => u['useremail'] == email && u['password'] == password,
      );
      // Retornar datos del usuario
      return {
        'id': user['id'],
        'email': user['useremail'],
        'roles': user['roles'],
      };
    } catch (e) {
      throw Exception('Usuario o contraseña incorrectos');
    }
  }

  /// ===== Obtener todos los usuarios =====
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await Future.delayed(Duration(milliseconds: 500)); // simula request
    return _fakeUsers;
  }

  /// ===== Obtener usuario por email =====
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    await Future.delayed(Duration(milliseconds: 500));
    try {
      return _fakeUsers.firstWhere((u) => u['useremail'] == email);
    } catch (e) {
      return null;
    }
  }


}