import 'package:fash_food/features/auth/domain/repositories/auth_repositories.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> call() async {
    return await _repository.logout();
  }
}
