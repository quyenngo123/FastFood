import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/combo_entity.dart';

class ComboData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<ComboEntity>> getCombosFromFirebase() async {
    try {
      final snapshot = await _firestore
          .collection('combos')
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ComboEntity(
          id: data['id'] ?? doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          image: data['image'] ?? '',
          originalPrice: (data['originalPrice'] as num).toDouble(),
          comboPrice: (data['comboPrice'] as num).toDouble(),
          discountPercent: data['discountPercent'] ?? 0,
          isActive: data['isActive'] ?? true,
          isBestSeller: data['isBestSeller'] ?? false,
          isNew: data['isNew'] ?? false,
          items: (data['items'] as List).map((item) => ComboItemEntity(
            productId: item['productId'],
            productName: item['productName'],
            quantity: item['quantity'],
          )).toList(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching combos: $e');
      return [];
    }
  }

  static final List<ComboEntity> combos = [
    ComboEntity(
      id: 'c001',
      name: 'Combo Burger Cơ Bản',
      description: '1 Burger Bò Phô Mai + 1 Khoai Tây Chiên + 1 Nước Ngọt',
      image: 'https://images.unsplash.com/photo-1594212699903-ec8a3eca50f5?auto=format&fit=crop&q=80&w=500',
      originalPrice: 120000,
      comboPrice: 89000,
      discountPercent: 26,
      isActive: true,
      isBestSeller: true,
      isNew: false,
      items: [
        ComboItemEntity(productId: 'p001', productName: 'Burger Bò Phô Mai', quantity: 1),
        ComboItemEntity(productId: 'p031', productName: 'Khoai Tây Chiên Phô Mai', quantity: 1),
        ComboItemEntity(productId: 'p023', productName: 'Cà Phê Sữa Đá', quantity: 1),
      ],
    ),
    ComboEntity(
      id: 'c002',
      name: 'Combo Gia Đình Lẩu',
      description: '1 Lẩu Thái Hải Sản + 2 Phần Cơm + 4 Nước Ngọt + 1 Tráng Miệng',
      image: 'https://images.unsplash.com/photo-1555126634-323283e090fa?auto=format&fit=crop&q=80&w=500',
      originalPrice: 420000,
      comboPrice: 320000,
      discountPercent: 24,
      isActive: true,
      isBestSeller: true,
      isNew: false,
      items: [
        ComboItemEntity(productId: 'p025', productName: 'Lẩu Thái Hải Sản', quantity: 1),
        ComboItemEntity(productId: 'p022', productName: 'Nước Chanh Dây', quantity: 4),
        ComboItemEntity(productId: 'p032', productName: 'Bánh Flan Caramel', quantity: 2),
      ],
    ),
    ComboEntity(
      id: 'c003',
      name: 'Combo Pizza Đôi',
      description: '2 Pizza Cỡ Vừa + 2 Nước Uống + 2 Tráng Miệng',
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&q=80&w=500',
      originalPrice: 380000,
      comboPrice: 280000,
      discountPercent: 26,
      isActive: true,
      isBestSeller: false,
      isNew: true,
      items: [
        ComboItemEntity(productId: 'p005', productName: 'Pizza Pepperoni', quantity: 1),
        ComboItemEntity(productId: 'p007', productName: 'Pizza Margherita', quantity: 1),
        ComboItemEntity(productId: 'p021', productName: 'Trà Sữa Trân Châu', quantity: 2),
        ComboItemEntity(productId: 'p033', productName: 'Kem Ba Vị Que', quantity: 2),
      ],
    ),
    ComboEntity(
      id: 'c004',
      name: 'Combo Ăn Vặt Học Sinh',
      description: '1 Bánh Tráng Nướng + 1 Trứng Cút + 1 Xúc Xích + 1 Trà Sữa',
      image: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?auto=format&fit=crop&q=80&w=500',
      originalPrice: 120000,
      comboPrice: 85000,
      discountPercent: 29,
      isActive: true,
      isBestSeller: true,
      isNew: false,
      items: [
        ComboItemEntity(productId: 'p028', productName: 'Bánh Tráng Nướng', quantity: 1),
        ComboItemEntity(productId: 'p029', productName: 'Trứng Cút Chiên Xiên', quantity: 1),
        ComboItemEntity(productId: 'p030', productName: 'Xúc Xích Chiên Giòn', quantity: 1),
        ComboItemEntity(productId: 'p021', productName: 'Trà Sữa Trân Châu', quantity: 1),
      ],
    ),
    ComboEntity(
      id: 'c005',
      name: 'Combo Gà Rán Nhóm Bạn',
      description: '9 miếng Gà Rán + 12 Cánh Gà Cay + 4 Khoai Tây + 4 Nước',
      image: 'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&q=80&w=500',
      originalPrice: 420000,
      comboPrice: 315000,
      discountPercent: 25,
      isActive: true,
      isBestSeller: true,
      isNew: false,
      items: [
        ComboItemEntity(productId: 'p009', productName: 'Gà Rán Giòn 3 Miếng', quantity: 3),
        ComboItemEntity(productId: 'p010', productName: 'Cánh Gà Cay Vừa', quantity: 2),
        ComboItemEntity(productId: 'p031', productName: 'Khoai Tây Chiên Phô Mai', quantity: 4),
        ComboItemEntity(productId: 'p023', productName: 'Cà Phê Sữa Đá', quantity: 4),
      ],
    ),
    ComboEntity(
      id: 'c006',
      name: 'Combo Hàn Quốc Yêu Thích',
      description: '2 Kimbap Cổ Điển + 1 Kimbap Bulgogi + 2 Trà Sữa Matcha',
      image: 'https://images.unsplash.com/photo-1590301157890-4810ed352733?auto=format&fit=crop&q=80&w=800',
      originalPrice: 282000,
      comboPrice: 210000,
      discountPercent: 26,
      isActive: true,
      isBestSeller: false,
      isNew: true,
      items: [
        ComboItemEntity(productId: 'p015', productName: 'Kimbap Cổ Điển', quantity: 2),
        ComboItemEntity(productId: 'p017', productName: 'Kimbap Bò Bulgogi', quantity: 1),
        ComboItemEntity(productId: 'p024', productName: 'Matcha Latte', quantity: 2),
      ],
    ),
    ComboEntity(
      id: 'c007',
      name: 'Combo Tráng Miệng Ngọt Ngào',
      description: '1 Bánh Flan + 1 Tiramisu + 2 Kem Ba Vị + 2 Chè Ba Màu',
      image: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&q=80&w=500',
      originalPrice: 193000,
      comboPrice: 148000,
      discountPercent: 23,
      isActive: true,
      isBestSeller: false,
      isNew: false,
      items: [
        ComboItemEntity(productId: 'p032', productName: 'Bánh Flan Caramel', quantity: 1),
        ComboItemEntity(productId: 'p035', productName: 'Tiramisu', quantity: 1),
        ComboItemEntity(productId: 'p033', productName: 'Kem Ba Vị Que', quantity: 2),
        ComboItemEntity(productId: 'p034', productName: 'Chè Ba Màu', quantity: 2),
      ],
    ),
    ComboEntity(
      id: 'c008',
      name: 'Combo Sáng Bánh Mì',
      description: '2 Bánh Mì Thịt Nguội + 1 Bánh Mì Trứng + 3 Cà Phê Sữa Đá',
      image: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?auto=format&fit=crop&q=80&w=500',
      originalPrice: 158000,
      comboPrice: 115000,
      discountPercent: 27,
      isActive: true,
      isBestSeller: true,
      isNew: false,
      items: [
        ComboItemEntity(productId: 'p012', productName: 'Bánh Mì Thịt Nguội', quantity: 2),
        ComboItemEntity(productId: 'p013', productName: 'Bánh Mì Trứng Ốp La', quantity: 1),
        ComboItemEntity(productId: 'p023', productName: 'Cà Phê Sữa Đá', quantity: 3),
      ],
    ),
  ];
}
