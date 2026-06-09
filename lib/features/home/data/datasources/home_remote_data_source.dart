import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';
import '../models/category_model.dart';
import '../models/notification_model.dart';

class HomeRemoteDataSource {
  final FirebaseFirestore firestore;

  HomeRemoteDataSource({required this.firestore});

  // Banners
  Future<List<BannerModel>> getBanners() async {
    final snapshot = await firestore
        .collection('banners')
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => BannerModel.fromSnapshot(doc)).toList();
  }

  // Categories
  Future<List<CategoryModel>> getCategories() async {
    final snapshot = await firestore
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .get();
    return snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
  }

  // Notifications
  Future<List<NotificationModel>> getNotifications() async {
    final snapshot = await firestore
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList();
  }

  // Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await firestore
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }
}
