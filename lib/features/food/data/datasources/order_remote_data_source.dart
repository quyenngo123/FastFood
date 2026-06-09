import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSource({required this.firestore});

  /// Lấy danh sách đơn hàng của người dùng
  Future<List<OrderModel>> getOrders(String userId) async {
    try {
      final snapshot = await firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => OrderModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy lịch sử đơn hàng: $e');
    }
  }

  /// Đặt đơn hàng mới
  Future<void> placeOrder(OrderModel order) async {
    try {
      await firestore.collection('orders').doc(order.id).set(order.toJson());
    } catch (e) {
      throw Exception('Lỗi khi đặt hàng: $e');
    }
  }

  /// Cập nhật trạng thái đơn hàng
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await firestore.collection('orders').doc(orderId).update({'status': status});
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái đơn hàng: $e');
    }
  }
}
