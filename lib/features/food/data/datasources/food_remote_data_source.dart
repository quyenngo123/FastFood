import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_model.dart';

class FoodRemoteDataSource {
  final FirebaseFirestore firestore;

  FoodRemoteDataSource({required this.firestore});

  /// Lấy toàn bộ danh sách món ăn
  Future<List<FoodModel>> getFoods() async {
    try {
      final snapshot = await firestore.collection('foods').get();
      return snapshot.docs.map((doc) => FoodModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách món ăn: $e');
    }
  }

  /// Lấy chi tiết một món ăn
  Future<FoodModel?> getFoodById(String id) async {
    try {
      final doc = await firestore.collection('foods').doc(id).get();
      if (!doc.exists) return null;
      return FoodModel.fromSnapshot(doc);
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết món ăn: $e');
    }
  }
}
