import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<UserProfile> call({
    required String token,
    required Map<String, dynamic> data,
  }) {
    return repository.updateProfile(token, data);
  }
}
