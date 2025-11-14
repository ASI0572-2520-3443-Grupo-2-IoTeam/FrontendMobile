import 'package:plant_care/iam/data/models/user_model.dart';


abstract class AuthRepository {

  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String role,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });
}