import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/food/data/datasources/voucher_data.dart';

class SeedVouchers {
  static Future<void> uploadVouchers() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload danh sách voucher...');

      for (final voucher in VoucherData.vouchers) {
        Map<String, dynamic> uploadData = Map.from(voucher);

        // Chuyển String date thành Firestore Timestamp
        if (voucher['expiryDate'] != null) {
          uploadData['expiryDate'] = Timestamp.fromDate(DateTime.parse(voucher['expiryDate']));
        }

        await firestore
            .collection('vouchers')
            .doc(voucher['id'] as String)
            .set(uploadData);

        print('Đã upload voucher: ${voucher['code']}');
      }

      print('======================');
      print('VOUCHERS UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('VOUCHERS UPLOAD ERROR: $e');
    }
  }
}
