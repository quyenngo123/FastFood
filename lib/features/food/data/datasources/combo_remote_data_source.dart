import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/combo_model.dart';

class ComboRemoteDataSource {
  final FirebaseFirestore firestore;

  ComboRemoteDataSource({required this.firestore});

  /// Lấy danh sách combo đang hoạt động
  Future<List<ComboModel>> getCombos() async {
    try {
      final snapshot = await firestore
          .collection('combos')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) => ComboModel.fromSnapshot(doc)).toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh sách combo: $e');
    }
  }
}
