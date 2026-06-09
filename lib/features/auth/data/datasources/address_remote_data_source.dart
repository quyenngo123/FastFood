import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressRemoteDataSource {
  final FirebaseFirestore firestore;

  AddressRemoteDataSource({required this.firestore});

  /// Lấy danh sách địa chỉ của người dùng
  Future<List<AddressModel>> getAddresses(String userId) async {
    try {
      final snapshot = await firestore
          .collection('addresses')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => AddressModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách địa chỉ: $e');
    }
  }

  /// Thêm hoặc cập nhật địa chỉ
  Future<void> saveAddress(AddressModel address) async {
    try {
      await firestore
          .collection('addresses')
          .doc(address.id)
          .set(address.toJson());
    } catch (e) {
      throw Exception('Lỗi khi lưu địa chỉ: $e');
    }
  }

  /// Xóa địa chỉ
  Future<void> deleteAddress(String addressId) async {
    try {
      await firestore.collection('addresses').doc(addressId).delete();
    } catch (e) {
      throw Exception('Lỗi khi xóa địa chỉ: $e');
    }
  }

  /// Đặt địa chỉ làm mặc định
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      final batch = firestore.batch();
      
      // Lấy tất cả địa chỉ của user
      final snapshot = await firestore
          .collection('addresses')
          .where('userId', isEqualTo: userId)
          .get();

      // Cập nhật isDefault
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isDefault': doc.id == addressId});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Lỗi khi đặt địa chỉ mặc định: $e');
    }
  }
}
