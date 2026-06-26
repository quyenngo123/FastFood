import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class LoginWithFacebookUseCase {
  final AuthRepository _repository;

  LoginWithFacebookUseCase(this._repository);

  Future<UserEntity> call() async {
    return await _repository.loginWithFacebook();
  }
}
