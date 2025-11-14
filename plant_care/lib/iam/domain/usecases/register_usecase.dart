import 'package:plant_care/iam/data/models/user_model.dart';

import '../repositories/auth_repository.dart';

class RegisterUseCase {

  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Retorna un UserModel con token y estado de login
  Future<UserModel> execute({
    required String email,
    required String username,
    required String password,
    required String role,
  }) async {
    return await _repository.register(
      email: email,
      username: username,
      password: password,
      role: role,
    );
  }
}