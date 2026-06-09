import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/voucher_model.dart';

class VoucherRemoteDataSource {
  final FirebaseFirestore firestore;

  VoucherRemoteDataSource({required this.firestore});

  /// Lấy danh sách voucher
  Future<List<VoucherModel>> getVouchers() async {
    try {
      final snapshot = await firestore.collection('vouchers').get();
      return snapshot.docs.map((doc) => VoucherModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách voucher: $e');
    }
  }

  /// Lấy voucher theo mã code
  Future<VoucherModel?> getVoucherByCode(String code) async {
    try {
      final snapshot = await firestore
          .collection('vouchers')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return VoucherModel.fromSnapshot(snapshot.docs.first);
    } catch (e) {
      throw Exception('Lỗi khi tìm voucher: $e');
    }
  }
}
