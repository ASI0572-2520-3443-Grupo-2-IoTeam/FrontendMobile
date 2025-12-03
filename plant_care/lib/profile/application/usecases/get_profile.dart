import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<UserProfile> call({required String token}) {
    return repository.getProfile(token);
  }
}
