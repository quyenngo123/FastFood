import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/food/data/datasources/food_data.dart';

class SeedFoods {
  static Future<void> uploadFoods() async {
    final firestore = FirebaseFirestore.instance;

    try {
      for (final food in FoodData.foods) {
        await firestore.collection('foods').doc(food.id).set({
          'id': food.id,
          'name': food.name,
          'description': food.description,
          'price': food.price,
          'originalPrice': food.originalPrice,
          'rating': food.rating,
          'reviewCount': food.reviewCount,
          'imageUrl': food.imageUrl,
          'category': food.category,
          'isPopular': food.isPopular,
          'isPromo': food.isPromo,
        });

        print('Uploaded: ${food.name}');
      }

      print('======================');
      print('UPLOAD SUCCESS');
      print('======================');
    } catch (e) {
      print('UPLOAD ERROR: $e');
    }
  }
}