import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSource({required this.firestore});

  /// Lấy giỏ hàng của người dùng
  Future<CartModel?> getCart(String userId) async {
    try {
      final doc = await firestore.collection('carts').doc(userId).get();
      if (!doc.exists) return null;
      return CartModel.fromSnapshot(doc);
    } catch (e) {
      throw Exception('Lỗi khi lấy giỏ hàng: $e');
    }
  }

  /// Cập nhật giỏ hàng
  Future<void> updateCart(CartModel cart) async {
    try {
      await firestore.collection('carts').doc(cart.userId).set(cart.toJson());
    } catch (e) {
      throw Exception('Lỗi khi cập nhật giỏ hàng: $e');
    }
  }

  /// Xóa giỏ hàng (thường sau khi thanh toán)
  Future<void> deleteCart(String userId) async {
    try {
      await firestore.collection('carts').doc(userId).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa giỏ hàng: $e');
    }
  }
}
