import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSource({required this.firestore});

  /// Theo dõi danh sách thông báo theo thời gian thực
  Stream<List<NotificationModel>> watchNotifications(String userId) {
    return firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList();
    });
  }

  /// Đánh dấu thông báo đã đọc
  Future<void> markAsRead(String notificationId) async {
    try {
      await firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});
    } catch (e) {
      throw Exception('Lỗi khi cập nhật trạng thái thông báo: $e');
    }
  }
}
