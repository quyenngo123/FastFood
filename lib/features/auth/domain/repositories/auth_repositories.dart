import '../entities/user_entity.dart';

/// Contract (hợp đồng) — định nghĩa những gì Auth có thể làm
/// Tầng Data sẽ implement interface này với Firebase thật
abstract class AuthRepository {
  /// Đăng nhập bằng email và password
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Đăng ký tài khoản mới
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  });

  /// Đăng nhập bằng Google
  Future<UserEntity> loginWithGoogle();

  /// Đăng nhập bằng Facebook
  Future<UserEntity> loginWithFacebook();

  /// Đăng xuất
  Future<void> logout();

  /// Lấy user hiện tại (nếu đã đăng nhập)
  Future<UserEntity?> getCurrentUser();
}