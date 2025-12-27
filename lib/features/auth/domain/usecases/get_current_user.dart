import '../../../profile/domain/entities/user_profile.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repo);

  final AuthRepository _repo;

  Future<UserProfile> call() {
    return _repo.fetchCurrentUser();
  }
}
