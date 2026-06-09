import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fash_food/features/food/data/datasources/cart_data.dart';

class SeedCarts {
  static Future<void> uploadCarts() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload dữ liệu giỏ hàng...');

      for (final cart in CartData.carts) {
        Map<String, dynamic> uploadData = Map.from(cart);

        // Chuyển String date thành Timestamp
        if (cart['updatedAt'] != null) {
          uploadData['updatedAt'] = Timestamp.fromDate(DateTime.parse(cart['updatedAt']));
        }

        // Sử dụng userId làm Document ID để mỗi user có 1 giỏ hàng duy nhất
        await firestore
            .collection('carts')
            .doc(cart['userId'] as String)
            .set(uploadData);

        print('Đã upload giỏ hàng cho User: ${cart['userId']}');
      }

      print('======================');
      print('CART UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('CART UPLOAD ERROR: $e');
    }
  }
}