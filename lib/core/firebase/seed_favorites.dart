import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fash_food/features/food/data/datasources/favorite_data.dart';

class SeedFavorites {
  static Future<void> uploadFavorites() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload danh sách yêu thích...');

      for (final fav in FavoriteData.favorites) {
        Map<String, dynamic> uploadData = Map.from(fav);

        // Chuyển String date thành Firestore Timestamp
        if (fav['addedAt'] != null) {
          uploadData['addedAt'] = Timestamp.fromDate(DateTime.parse(fav['addedAt']));
        }

        // Sử dụng id từ json làm Document ID
        await firestore
            .collection('favorites')
            .doc(fav['id'] as String)
            .set(uploadData);

        print('Đã upload yêu thích: ${fav['id']}');
      }

      print('======================');
      print('FAVORITES UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('FAVORITES UPLOAD ERROR: $e');
    }
  }
}