import '../../domain/repositories/profile_repository.dart';

class UploadAvatar {
  final ProfileRepository repository;

  UploadAvatar(this.repository);

  Future<String> call({
    required String token,
    required String filePath,
  }) {
    return repository.uploadAvatar(token, filePath);
  }
}
