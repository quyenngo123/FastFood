import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSource({required this.firestore});

  /// Lấy danh sách thông báo của người dùng
  Future<List<NotificationModel>> getNotifications(String userId) async {
    try {
      final snapshot = await firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách thông báo: $e');
    }
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
