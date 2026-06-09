import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/food/data/datasources/address_data.dart';


class SeedAddresses {
  static Future<void> uploadAddresses() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload danh sách địa chỉ...');

      for (final address in AddressData.addresses) {
        Map<String, dynamic> uploadData = Map.from(address);

        // Chuyển String date thành Firestore Timestamp
        if (address['createdAt'] != null) {
          uploadData['createdAt'] = Timestamp.fromDate(DateTime.parse(address['createdAt']));
        }

        // Sử dụng id làm Document ID
        await firestore
            .collection('addresses')
            .doc(address['id'] as String)
            .set(uploadData);

        print('Đã upload địa chỉ: ${address['id']} - ${address['label']}');
      }

      print('======================');
      print('ADDRESSES UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('ADDRESSES UPLOAD ERROR: $e');
    }
  }
}