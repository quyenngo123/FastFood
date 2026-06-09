import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({required String fullName, required String email, required String password});
  Future<UserEntity> loginWithGoogle();
  Future<UserEntity> loginWithFacebook();
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Đăng nhập email/password
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _mapFirebaseUserToEntity(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// Đăng ký tài khoản mới
  @override
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cập nhật displayName
      await credential.user!.updateDisplayName(fullName);
      await credential.user!.reload();

      return _mapFirebaseUserToEntity(_firebaseAuth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// Đăng nhập Google
  @override
  Future<UserEntity> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Đăng nhập Google bị hủy');

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(credential);
      return _mapFirebaseUserToEntity(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapFirebaseError(e.code));
    }
  }

  /// Đăng nhập Facebook — cần thêm flutter_facebook_auth ở bước sau
  @override
  Future<UserEntity> loginWithFacebook() async {
    throw Exception('Facebook login chưa được cấu hình');
  }

  /// Đăng xuất
  @override
  Future<void> logout() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  /// Lấy user hiện tại
  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return _mapFirebaseUserToEntity(user);
  }

  /// Chuyển Firebase User → UserEntity
  UserEntity _mapFirebaseUserToEntity(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  /// Dịch mã lỗi Firebase sang tiếng Việt
  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Tài khoản không tồn tại';
      case 'wrong-password':
        return 'Mật khẩu không đúng';
      case 'email-already-in-use':
        return 'Email đã được sử dụng';
      case 'invalid-email':
        return 'Email không hợp lệ';
      case 'weak-password':
        return 'Mật khẩu quá yếu (tối thiểu 6 ký tự)';
      case 'user-disabled':
        return 'Tài khoản đã bị vô hiệu hóa';
      case 'too-many-requests':
        return 'Quá nhiều lần thử, vui lòng thử lại sau';
      case 'network-request-failed':
        return 'Lỗi kết nối mạng';
      case 'invalid-credential':
        return 'Thông tin đăng nhập không hợp lệ';
      default:
        return 'Đã xảy ra lỗi, vui lòng thử lại';
    }
  }
}