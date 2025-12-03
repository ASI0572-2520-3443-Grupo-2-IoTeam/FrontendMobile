import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/achievement_model.dart';
import '../models/user_profile_model.dart';
import '../models/user_stats_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getProfile(String token);
  Future<UserProfileModel> updateProfile(String token, Map<String, dynamic> data);
  Future<String> uploadAvatar(String token, String filePath);
  Future<UserStatsModel> getStats(String token);
  Future<List<AchievementModel>> getAchievements(String token);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1',
  });

  final http.Client client;
  final String baseUrl;

  Map<String, String> _headers(String token, {bool withJson = false}) {
    return {
      'Authorization': 'Bearer $token',
      if (withJson) 'Content-Type': 'application/json',
      'accept': 'application/json',
    };
  }

  @override
  Future<UserProfileModel> getProfile(String token) async {
    final uri = Uri.parse('$baseUrl/users/profile');
    final response = await client.get(uri, headers: _headers(token));
    _throwIfError(response);
    return UserProfileModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<UserProfileModel> updateProfile(String token, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/users/profile');
    final response = await client.patch(
      uri,
      headers: _headers(token, withJson: true),
      body: jsonEncode(data),
    );
    _throwIfError(response);
    return UserProfileModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<String> uploadAvatar(String token, String filePath) async {
    final uri = Uri.parse('$baseUrl/users/profile/avatar');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers(token))
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    _throwIfError(response);

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['avatarUrl']?.toString() ?? '';
  }

  @override
  Future<UserStatsModel> getStats(String token) async {
    final uri = Uri.parse('$baseUrl/users/stats');
    final response = await client.get(uri, headers: _headers(token));
    _throwIfError(response);
    return UserStatsModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  @override
  Future<List<AchievementModel>> getAchievements(String token) async {
    final uri = Uri.parse('$baseUrl/users/achievements');
    final response = await client.get(uri, headers: _headers(token));
    _throwIfError(response);
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic> && decoded['achievements'] is List) {
      return (decoded['achievements'] as List)
          .map((e) => AchievementModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (decoded is List) {
      return decoded.map((e) => AchievementModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  void _throwIfError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    if (response.statusCode == 401) {
      throw HttpException('Unauthorized: ${response.body}');
    }
    if (response.statusCode == 403) {
      throw HttpException('Forbidden: ${response.body}');
    }
    throw HttpException('Request failed: ${response.statusCode} ${response.body}');
  }
}
