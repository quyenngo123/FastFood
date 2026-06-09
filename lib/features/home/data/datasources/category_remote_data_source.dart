import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSource({required this.firestore});

  /// Lấy danh sách danh mục đang hoạt động
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => CategoryModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách danh mục: $e');
    }
  }
}
