import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fash_food/features/food/data/datasources/review_data.dart';

class SeedReviews {
  static Future<void> uploadReviews() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload danh sách đánh giá...');

      for (final review in ReviewData.reviews) {
        Map<String, dynamic> uploadData = Map.from(review);

        // Chuyển String date thành Firestore Timestamp để sort theo thời gian
        if (review['createdAt'] != null) {
          uploadData['createdAt'] = Timestamp.fromDate(DateTime.parse(review['createdAt']));
        }

        // Sử dụng id làm Document ID để tránh trùng lặp
        await firestore
            .collection('reviews')
            .doc(review['id'] as String)
            .set(uploadData);

        print('Đã upload đánh giá: ${review['id']}');
      }

      print('======================');
      print('REVIEWS UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('REVIEWS UPLOAD ERROR: $e');
    }
  }
}