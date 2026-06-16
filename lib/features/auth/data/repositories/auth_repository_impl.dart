import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repositories.dart';
import '../datasources/user_remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final UserRemoteDataSource _userRemoteDataSource;

  AuthRepositoryImpl(this._firebaseAuth, this._userRemoteDataSource);

  @override
  Future<UserEntity> login({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      
      // Lấy profile đầy đủ từ Firestore
      final userProfile = await _userRemoteDataSource.getUserProfile(user.uid);

      if (userProfile != null) {
        return userProfile;
      }

      return UserEntity(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        phone: user.phoneNumber,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      
      await user.updateDisplayName(fullName);
      
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        name: fullName,
      );
      await _userRemoteDataSource.updateUserProfile(userModel);
      
      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    
    // Luôn ưu tiên lấy dữ liệu đầy đủ từ Firestore (bao gồm SĐT và Địa chỉ)
    final userProfile = await _userRemoteDataSource.getUserProfile(user.uid);
    
    if (userProfile != null) {
      return userProfile;
    }

    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      phone: user.phoneNumber,
    );
  }

  @override
  Future<void> updateUserProfile(UserEntity user) async {
    final userModel = UserModel(
      uid: user.uid,
      email: user.email,
      name: user.name,
      photoUrl: user.photoUrl,
      phone: user.phone,
      address: user.address,
    );
    await _userRemoteDataSource.updateUserProfile(userModel);
  }

  @override
  Future<UserEntity> loginWithGoogle() => throw UnimplementedError();
  @override
  Future<UserEntity> loginWithFacebook() => throw UnimplementedError();

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'Email này chưa được đăng ký.';
      case 'wrong-password': return 'Mật khẩu không chính xác.';
      case 'email-already-in-use': return 'Email này đã được sử dụng.';
      default: return e.message ?? 'Đã có lỗi xảy ra.';
    }
  }
}
