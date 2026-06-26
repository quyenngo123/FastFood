import '../../domain/entities/food_entity.dart';

class FoodData {
  static List<String> get categories {
    final Set<String> categorySet = {'Tất cả'};
    for (var food in foods) {
      categorySet.add(food.category);
    }
    return categorySet.toList();
  }

  static final List<FoodEntity> foods = [
    // MÌ Ý (PASTA)
    FoodEntity(
      id: 'p019',
      name: 'Mì Ý Carbonara',
      description: 'Mì Ý sốt kem trứng truyền thống với thịt xông khói giòn và phô mai Parmesan.',
      price: 95000,
      rating: 4.8,
      reviewCount: 210,
      imageUrl: 'https://images.unsplash.com/photo-1612874742237-6526221588e3?q=80&w=1000&auto=format&fit=crop',
      category: 'Mì Ý',
      isPopular: true,
    ),
    FoodEntity(
      id: 'p040',
      name: 'Mì Ý Lasagna Phô Mai',
      description: 'Lớp mì lá xen kẽ sốt bò bằm Bolognese và phô mai Mozzarella đút lò thơm lừng.',
      price: 125000,
      originalPrice: 150000,
      rating: 4.9,
      reviewCount: 156,
      imageUrl: 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?q=80&w=1000&auto=format&fit=crop',
      category: 'Mì Ý',
      isPromo: true,
    ),
    FoodEntity(
      id: 'p041',
      name: 'Mì Ý Đen Hải Sản',
      description: 'Mì Ý mực đen độc đáo kết hợp cùng tôm, mực tươi và sốt rượu vang trắng.',
      price: 145000,
      rating: 4.7,
      reviewCount: 89,
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?q=80&w=1000&auto=format&fit=crop',
      category: 'Mì Ý',
    ),

    // BURGER
    FoodEntity(
      id: '1',
      name: 'Burger Tôm Nướng Giòn',
      description: 'Nhân tôm tươi chiên xù giòn tan.',
      price: 75000,
      rating: 4.5,
      reviewCount: 120,
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-476775a748af?q=80&w=1000&auto=format&fit=crop',
      category: 'Burger',
    ),
  ];
}
