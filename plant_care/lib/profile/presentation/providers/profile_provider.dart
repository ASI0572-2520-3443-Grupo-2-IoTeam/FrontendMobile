import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../application/usecases/get_achievements.dart';
import '../../application/usecases/get_profile.dart';
import '../../application/usecases/get_stats.dart';
import '../../application/usecases/update_profile.dart';
import '../../application/usecases/upload_avatar.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/user_stats.dart';
import '../../infrastructure/datasources/profile_remote_datasource.dart';
import '../../infrastructure/repositories/profile_repository_impl.dart';

class ProfileProvider extends ChangeNotifier {
  static const String _prodBaseUrl =
      'https://plantcare-awcchhb2bfg3hxgf.canadacentral-01.azurewebsites.net/api/v1';

  ProfileProvider({
    required GetProfile getProfile,
    required UpdateProfile updateProfile,
    required UploadAvatar uploadAvatar,
    required GetStats getStats,
    required GetAchievements getAchievements,
  })  : _getProfile = getProfile,
        _updateProfile = updateProfile,
        _uploadAvatar = uploadAvatar,
        _getStats = getStats,
        _getAchievements = getAchievements;

  final GetProfile _getProfile;
  final UpdateProfile _updateProfile;
  final UploadAvatar _uploadAvatar;
  final GetStats _getStats;
  final GetAchievements _getAchievements;

  UserProfile? _profile;
  UserStats? _stats;
  List<Achievement> _achievements = [];
  bool _isLoading = false;
  String? _error;

  UserProfile? get profile => _profile;
  UserStats? get stats => _stats;
  List<Achievement> get achievements => _achievements;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll({required String token}) async {
    _setLoading(true);
    _error = null;
    try {
      final results = await Future.wait([
        _getProfile.call(token: token),
        _getStats.call(token: token),
        _getAchievements.call(token: token),
      ]);
      _profile = results[0] as UserProfile;
      _stats = results[1] as UserStats;
      _achievements = results[2] as List<Achievement>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<UserProfile?> refreshProfile({required String token}) async {
    try {
      _profile = await _getProfile.call(token: token);
      notifyListeners();
      return _profile;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<UserProfile?> updateProfile({
    required String token,
    required Map<String, dynamic> data,
  }) async {
    try {
      _profile = await _updateProfile.call(token: token, data: data);
      notifyListeners();
      return _profile;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<String?> uploadAvatar({
    required String token,
    required String filePath,
  }) async {
    try {
      final url = await _uploadAvatar.call(token: token, filePath: filePath);
      if (_profile != null) {
        _profile = UserProfile(
          uuid: _profile!.uuid,
          email: _profile!.email,
          username: _profile!.username,
          fullName: _profile!.fullName,
          phone: _profile!.phone,
          bio: _profile!.bio,
          location: _profile!.location,
          avatarUrl: url,
          joinDate: _profile!.joinDate,
          lastLogin: _profile!.lastLogin,
          stats: _profile!.stats,
        );
      }
      notifyListeners();
      return url;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Helper to create a provider with default HTTP wiring.
  static ProfileProvider create({
    http.Client? client,
    String? baseUrl,
  }) {
    final httpClient = client ?? http.Client();
    final resolvedBaseUrl = baseUrl ?? _defaultBaseUrl();
    final remote = ProfileRemoteDataSourceImpl(client: httpClient, baseUrl: resolvedBaseUrl);
    final repo = ProfileRepositoryImpl(remoteDataSource: remote);
    return ProfileProvider(
      getProfile: GetProfile(repo),
      updateProfile: UpdateProfile(repo),
      uploadAvatar: UploadAvatar(repo),
      getStats: GetStats(repo),
      getAchievements: GetAchievements(repo),
    );
  }

  static String _defaultBaseUrl() {
    if (kIsWeb) return _prodBaseUrl;
    if (defaultTargetPlatform == TargetPlatform.android) return _prodBaseUrl;
    return _prodBaseUrl;
  }
}
