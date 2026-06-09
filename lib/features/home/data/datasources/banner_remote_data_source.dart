import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/banner_model.dart';

class BannerRemoteDataSource {
  final FirebaseFirestore firestore;

  BannerRemoteDataSource({required this.firestore});

  /// Lấy danh sách banner đang hoạt động
  Future<List<BannerModel>> getBanners() async {
    try {
      final snapshot = await firestore
          .collection('banners')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => BannerModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách banner: $e');
    }
  }
}
