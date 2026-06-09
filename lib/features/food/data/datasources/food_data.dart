import '../../domain/entities/food_entity.dart';

class FoodData {
  static const List<String> categories = [
    'Tất cả', 'Burger', 'Pizza', 'Gà Rán', 'Tráng Miệng'
    'Bánh Mì', 'Kimbap', 'Mì Ý', 'Đồ uống', 'Lẩu ' , 'Ăn Vặt'
  ];

  static const List<FoodEntity> foods = [
    // === BURGER ===
    FoodEntity(
      id: '1',
      name: 'Burger Bò Đặc Biệt',
      description: 'Thịt bò Úc 100%, phô mai cheddar, rau tươi',
      price: 89000,
      originalPrice: 129000,
      rating: 4.8,
      reviewCount: 234,
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=500&auto=format&fit=crop',
      category: 'Burger',
      isPopular: true,
      isPromo: true,
    ),
    FoodEntity(
      id: '2',
      name: 'Double Cheese Burger',
      description: 'Hai lớp thịt bò, phô mai đôi, sốt đặc biệt',
      price: 109000,
      rating: 4.6,
      reviewCount: 189,
      imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=500&auto=format&fit=crop',
      category: 'Burger',
      isPopular: true,
    ),
    FoodEntity(
      id: '3',
      name: 'Chicken Burger',
      description: 'Gà giòn, rau xà lách, cà chua, sốt mayo',
      price: 69000,
      rating: 4.5,
      reviewCount: 312,
      imageUrl: 'https://images.unsplash.com/photo-1513185158878-8d8c196b01d5?q=80&w=500&auto=format&fit=crop',
      category: 'Burger',
    ),
    FoodEntity(
      id: '12',
      name: 'Burger Tôm Hoàng Gia',
      description: 'Nhân tôm tươi chiên xù, sốt tartar',
      price: 75000,
      rating: 4.4,
      reviewCount: 98,
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?q=80&w=500&auto=format&fit=crop',
      category: 'Burger',
    ),

    // === PIZZA ===
    FoodEntity(
      id: '4',
      name: 'Pizza Hải Sản',
      description: 'Tôm, mực, cua, phô mai mozzarella',
      price: 159000,
      rating: 4.7,
      reviewCount: 156,
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=500&auto=format&fit=crop',
      category: 'Pizza',
      isPopular: true,
    ),
    FoodEntity(
      id: '5',
      name: 'Pizza BBQ Thịt Xông Khói',
      description: 'Thịt xông khói, hành tây, ớt chuông, sốt BBQ',
      price: 139000,
      originalPrice: 169000,
      rating: 4.9,
      reviewCount: 421,
      imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=500&auto=format&fit=crop',
      category: 'Pizza',
      isPopular: true,
      isPromo: true,
    ),
    FoodEntity(
      id: '13',
      name: 'Pizza Phô Mai 4 Vị',
      description: 'Sự kết hợp của 4 loại phô mai cao cấp',
      price: 145000,
      rating: 4.8,
      reviewCount: 112,
      imageUrl: 'https://images.unsplash.com/photo-1574123818136-1a06a0b99141?q=80&w=500&auto=format&fit=crop',
      category: 'Pizza',
    ),

    // === GÀ RÁN ===
    FoodEntity(
      id: '6',
      name: 'Gà Giòn Cay',
      description: '3 miếng gà giòn rụm, sốt cay đặc biệt',
      price: 79000,
      rating: 4.8,
      reviewCount: 567,
      imageUrl: 'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=500&auto=format&fit=crop',
      category: 'Gà Rán',
      isPopular: true,
    ),
    FoodEntity(
      id: '7',
      name: 'Combo Gà Gia Đình',
      description: '8 miếng gà, khoai tây chiên lớn, 4 Pepsi',
      price: 299000,
      originalPrice: 359000,
      rating: 4.7,
      reviewCount: 203,
      imageUrl: 'https://images.unsplash.com/photo-1562967914-608f82629710?q=80&w=500&auto=format&fit=crop',
      category: 'Gà Rán',
      isPromo: true,
    ),

    // === BÁNH MÌ ===
    FoodEntity(
      id: '10',
      name: 'Bánh Mì Thịt Nguội',
      description: 'Pate, chả lụa, thịt nguội, dưa leo, rau thơm',
      price: 35000,
      rating: 4.7,
      reviewCount: 1024,
      imageUrl: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?q=80&w=500&auto=format&fit=crop',
      category: 'Bánh Mì',
      isPopular: true,
    ),
    FoodEntity(
      id: '15',
      name: 'Bánh Mì Heo Quay',
      description: 'Heo quay giòn rụm, sốt mặn ngọt đặc trưng',
      price: 40000,
      rating: 4.9,
      reviewCount: 512,
      imageUrl: 'https://images.unsplash.com/photo-1541544741-9336d7c20904?q=80&w=500&auto=format&fit=crop',
      category: 'Bánh Mì',
      isPopular: true,
    ),
    FoodEntity(
      id: '16',
      name: 'Bánh Mì Ốp La',
      description: '2 trứng ốp la, pate, bơ, xì dầu',
      price: 25000,
      rating: 4.5,
      reviewCount: 245,
      imageUrl: 'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?q=80&w=500&auto=format&fit=crop',
      category: 'Bánh Mì',
    ),

    // === KIMBAP ===
    FoodEntity(
      id: '17',
      name: 'Kimbap Truyền Thống',
      description: 'Cơm cuộn rong biển, trứng, xúc xích, cà rốt',
      price: 55000,
      rating: 4.6,
      reviewCount: 134,
      imageUrl: 'https://images.unsplash.com/photo-1534422298391-e4f8c170db76?q=80&w=500&auto=format&fit=crop',
      category: 'Kimbap',
    ),
    FoodEntity(
      id: '18',
      name: 'Kimbap Chiên Xù',
      description: 'Kimbap tẩm bột chiên giòn, sốt mayonnaise',
      price: 65000,
      rating: 4.7,
      reviewCount: 167,
      imageUrl: 'https://images.unsplash.com/photo-1593504049359-74330189a345?q=80&w=500&auto=format&fit=crop',
      category: 'Kimbap',
      isPopular: true,
    ),

    // === MÌ Ý ===
    FoodEntity(
      id: '11',
      name: 'Mì Ý Sốt Bò Bằm',
      description: 'Mì spaghetti, thịt bò bằm, sốt cà chua Ý',
      price: 99000,
      rating: 4.6,
      reviewCount: 178,
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?q=80&w=500&auto=format&fit=crop',
      category: 'Mì Ý',
    ),
    FoodEntity(
      id: '19',
      name: 'Mì Ý Sốt Kem Nấm',
      description: 'Mì Ý sốt kem trắng, nấm và thịt xông khói',
      price: 115000,
      rating: 4.7,
      reviewCount: 89,
      imageUrl: 'https://images.unsplash.com/photo-1612452846802-920f01a3536f?q=80&w=500&auto=format&fit=crop',
      category: 'Mì Ý',
    ),

    // === ĐỒ UỐNG ===
    FoodEntity(
      id: '8',
      name: 'Trà Sữa Trân Châu',
      description: 'Trà sữa Đài Loan, trân châu đen, đường đen',
      price: 45000,
      rating: 4.6,
      reviewCount: 789,
      imageUrl: 'https://images.unsplash.com/photo-1558857563-b371033873b8?q=80&w=500&auto=format&fit=crop',
      category: 'Đồ uống',
      isPopular: true,
    ),
    FoodEntity(
      id: '20',
      name: 'Cà Phê Sữa Đá',
      description: 'Cà phê nguyên chất pha phin, sữa đặc, đá',
      price: 29000,
      rating: 4.8,
      reviewCount: 1540,
      imageUrl: 'https://images.unsplash.com/photo-1541167760496-162955ed8a9f?q=80&w=500&auto=format&fit=crop',
      category: 'Đồ uống',
      isPopular: true,
    ),
    FoodEntity(
      id: '21',
      name: 'Nước Ép Cam Tươi',
      description: 'Cam sành vắt nguyên chất, ít đường',
      price: 39000,
      rating: 4.7,
      reviewCount: 120,
      imageUrl: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?q=80&w=500&auto=format&fit=crop',
      category: 'Đồ uống',
    ),
  ];

  static List<FoodEntity> getByCategory(String category) {
    if (category == 'Tất cả') return foods;
    return foods.where((f) => f.category == category).toList();
  }

  static List<FoodEntity> getPopular() {
    return foods.where((f) => f.isPopular).toList();
  }
}
