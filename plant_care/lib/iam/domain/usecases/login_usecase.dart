import 'package:plant_care/iam/data/models/user_model.dart';

import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Retorna un UserModel con token y estado de login
  Future<UserModel> execute({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email: email, password: password);
  }
}