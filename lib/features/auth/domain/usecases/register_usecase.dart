import 'package:fash_food/features/auth/domain/entities/user_entity.dart';
import 'package:fash_food/features/auth/domain/repositories/auth_repositories.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('Vui lòng nhập đầy đủ thông tin');
    }
    if (password != confirmPassword) {
      throw Exception('Mật khẩu xác nhận không khớp');
    }

    return await _repository.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
