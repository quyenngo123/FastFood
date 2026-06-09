import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/food/data/datasources/order_data.dart';

class SeedOrders {
  static Future<void> uploadOrders() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload đơn hàng...');

      for (final order in OrderData.orders) {
        // Chuyển đổi String date thành Firestore Timestamp
        Map<String, dynamic> uploadData = Map.from(order);

        if (order['createdAt'] != null) {
          uploadData['createdAt'] = Timestamp.fromDate(DateTime.parse(order['createdAt']));
        }

        if (order['deliveredAt'] != null) {
          uploadData['deliveredAt'] = Timestamp.fromDate(DateTime.parse(order['deliveredAt']));
        }

        // Sử dụng id từ json làm Document ID trong Firebase
        await firestore
            .collection('orders')
            .doc(order['id'] as String)
            .set(uploadData);

        print('Đã upload đơn hàng: ${order['id']} - ${order['userName']}');
      }

      print('======================');
      print('ORDER UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('ORDER UPLOAD ERROR: $e');
    }
  }
}