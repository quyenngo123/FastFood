import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class UpdateUserProfileUseCase {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<void> call(UserEntity user) async {
    return await repository.updateUserProfile(user);
  }
}
