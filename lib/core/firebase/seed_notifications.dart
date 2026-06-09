import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/food/data/datasources/notification_data.dart';


class SeedNotifications {
  static Future<void> uploadNotifications() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload danh sách thông báo...');

      for (final noti in NotificationData.notifications) {
        Map<String, dynamic> uploadData = Map.from(noti);

        // Chuyển String date thành Firestore Timestamp
        if (noti['createdAt'] != null) {
          uploadData['createdAt'] = Timestamp.fromDate(DateTime.parse(noti['createdAt']));
        }

        // Sử dụng id làm Document ID để tránh trùng lặp
        await firestore
            .collection('notifications')
            .doc(noti['id'] as String)
            .set(uploadData);

        print('Đã upload thông báo: ${noti['id']}');
      }

      print('======================');
      print('NOTIFICATIONS UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('NOTIFICATIONS UPLOAD ERROR: $e');
    }
  }
}