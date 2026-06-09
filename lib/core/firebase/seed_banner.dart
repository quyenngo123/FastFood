import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/food/data/datasources/banner_data.dart';

class SeedBanner {
  static Future<void> uploadBanners() async {
    final firestore = FirebaseFirestore.instance;

    try {
      print('Bắt đầu upload danh sách banner...');

      for (var i = 0; i < BannerData.banners.length; i++) {
        final banner = BannerData.banners[i];
        await firestore
            .collection('banners')
            .doc('b${i + 1}')
            .set({
          'id': 'b${i + 1}',
          'imageUrl': banner,
          'linkAction': null,
          'isActive': true,
        });
      }

      print('======================');
      print('BANNER UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('BANNER UPLOAD ERROR: $e');
    }
  }
}
