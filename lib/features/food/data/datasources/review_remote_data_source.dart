import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewRemoteDataSource {
  final FirebaseFirestore firestore;

  ReviewRemoteDataSource({required this.firestore});

  /// Lấy danh sách đánh giá của một món ăn
  Future<List<ReviewModel>> getReviewsByFoodId(String foodId) async {
    try {
      final snapshot = await firestore
          .collection('reviews')
          .where('foodId', isEqualTo: foodId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => ReviewModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách đánh giá: $e');
    }
  }

  /// Thêm đánh giá mới
  Future<void> addReview(ReviewModel review) async {
    try {
      await firestore.collection('reviews').doc(review.id).set(review.toJson());
    } catch (e) {
      throw Exception('Lỗi khi thêm đánh giá: $e');
    }
  }
}
