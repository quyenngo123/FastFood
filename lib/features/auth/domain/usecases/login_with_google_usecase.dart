import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class LoginWithGoogleUseCase {
  final AuthRepository _repository;

  LoginWithGoogleUseCase(this._repository);

  Future<UserEntity> call() async {
    return await _repository.loginWithGoogle();
  }
}
