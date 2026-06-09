import 'package:fash_food/features/auth/domain/entities/user_entity.dart';
import 'package:fash_food/features/auth/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await _repository.login(email: email, password: password);
  }
}
