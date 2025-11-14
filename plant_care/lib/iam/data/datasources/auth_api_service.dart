import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String baseUrl;

  AuthApiService({this.baseUrl = 'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1'});

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/authentication/signup');
    debugPrint('➡️ POST $url');
    debugPrint('📦 Body: $data');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    debugPrint('📥 Status: ${response.statusCode}');
    debugPrint('📨 Response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body.isNotEmpty
          ? jsonDecode(response.body)
          : {
              "email": data["email"],
              "username": data["username"],
              "role": data["role"]
            };
    } else {
      throw Exception('Error al registrar usuario: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/authentication/signin');
    debugPrint("➡️ POST $uri");
    debugPrint("📦 Body: {email: $email, password: ***}");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    debugPrint("📥 Status: ${response.statusCode}");
    debugPrint("📨 Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Credenciales incorrectas o acceso denegado');
    } else {
      throw Exception('Error al iniciar sesión: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> googleSignIn(String idToken) async {
    final uri = Uri.parse('$baseUrl/auth/google/mobile');
    debugPrint("➡️ POST $uri");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'googleToken': idToken}),
    );

    debugPrint("📥 Status: ${response.statusCode}");
    debugPrint("📨 Response: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al autenticar con Google: ${response.body}");
    }
  }
}