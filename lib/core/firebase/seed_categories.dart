import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/food/data/datasources/category_data.dart';
class SeedCategories {
  static Future<void> uploadCategories() async {
    final firestore = FirebaseFirestore.instance;

    try {
      for (final category in CategoryData.categories) {
        await firestore
            .collection('categories')
            .doc(category['id'] as String)
            .set({
          'id': category['id'],
          'name': category['name'],
          'image': category['image'],
          'isActive': category['isActive'],
        });

        print('Uploaded: ${category['name']}');
      }

      print('======================');
      print('CATEGORY UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('CATEGORY UPLOAD ERROR: $e');
    }
  }
}