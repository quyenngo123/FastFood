import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';

class FavoriteRemoteDataSource {
  final FirebaseFirestore firestore;

  FavoriteRemoteDataSource({required this.firestore});

  /// Lấy danh sách yêu thích của người dùng
  Future<List<FavoriteModel>> getFavorites(String userId) async {
    try {
      final snapshot = await firestore
          .collection('favorites')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => FavoriteModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách yêu thích: $e');
    }
  }

  /// Thêm/Xóa khỏi danh sách yêu thích
  Future<void> toggleFavorite(FavoriteModel favorite, bool isAdd) async {
    try {
      final docRef = firestore.collection('favorites').doc(favorite.id);
      if (isAdd) {
        await docRef.set(favorite.toJson());
      } else {
        await docRef.delete();
      }
    } catch (e) {
      throw Exception('Lỗi khi cập nhật yêu thích: $e');
    }
  }
}
