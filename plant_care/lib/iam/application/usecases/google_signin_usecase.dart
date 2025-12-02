import 'package:plant_care/iam/infrastructure/datasources/auth_api_service.dart';


class GoogleSignInUseCase {
  final AuthApiService _apiService;

  GoogleSignInUseCase({AuthApiService? apiService})
      : _apiService = apiService ?? AuthApiService();

  Future<Map<String, dynamic>> execute(String idToken) async {
    return await _apiService.googleSignIn(idToken);
  }
}