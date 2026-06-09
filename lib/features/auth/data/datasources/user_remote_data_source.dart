import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSource({required this.firestore});

  /// Lấy thông tin chi tiết người dùng từ Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromSnapshot(doc);
    } catch (e) {
      throw Exception('Lỗi khi lấy thông tin người dùng: $e');
    }
  }

  /// Cập nhật thông tin người dùng
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Lỗi khi cập nhật thông tin người dùng: $e');
    }
  }
}
