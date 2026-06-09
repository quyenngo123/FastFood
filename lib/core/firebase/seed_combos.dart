import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/food/data/datasources/combo_data.dart';

class SeedCombos {
  static Future<void> uploadCombos() async {
    final firestore = FirebaseFirestore.instance;
    try {
      print('--- BẮT ĐẦU CẬP NHẬT COMBO ---');
      for (final combo in ComboData.combos) {
        await firestore.collection('combos').doc(combo.id).set({
          'id': combo.id,
          'name': combo.name,
          'description': combo.description,
          'image': combo.image,
          'originalPrice': combo.originalPrice,
          'comboPrice': combo.comboPrice,
          'discountPercent': combo.discountPercent,
          'isActive': combo.isActive,
          'isBestSeller': combo.isBestSeller,
          'isNew': combo.isNew,
          'items': combo.items.map((item) => {
            'productId': item.productId,
            'productName': item.productName,
            'quantity': item.quantity,
          }).toList(),
        });
        print('✅ Đã cập nhật Combo: ${combo.name}');
      }
      print('--- CẬP NHẬT COMBO THÀNH CÔNG ---');
    } catch (e) {
      print('❌ LỖI UPLOAD COMBO: $e');
    }
  }
}
