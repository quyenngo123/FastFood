import 'package:flutter/material.dart';
import '../../data/datasources/food_data.dart';
import '../../domain/entities/food_entity.dart';
import '../widgets/food_card.dart';
import '../widgets/food_filter_bar.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String _selectedCategory = 'Tất cả';
  int _cartCount = 0;

  List<FoodEntity> get _filteredFoods =>
      FoodData.getByCategory(_selectedCategory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          const SizedBox(height: 16),

          // Filter bar
          FoodFilterBar(
            categories: FoodData.categories,
            selectedCategory: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),

          const SizedBox(height: 16),

          // Danh sách món
          Expanded(
            child: _filteredFoods.isEmpty
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.no_food_outlined,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('Không có món nào',
                      style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.65, // Giảm tỷ lệ để tăng chiều cao cho Card, tránh lỗi Overflow
              ),
              itemCount: _filteredFoods.length,
              itemBuilder: (context, index) {
                return FoodCard(
                  food: _filteredFoods[index],
                  onAddToCart: () {
                    setState(() => _cartCount++);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Đã thêm ${_filteredFoods[index].name}!'),
                        backgroundColor: const Color(0xFF4CAF50),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          // Nút back
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: Color(0xFF0D47A1)),
            ),
          ),
          const SizedBox(width: 16),

          // Tiêu đề
          const Expanded(
            child: Text(
              'Thực đơn',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0D47A1),
              ),
            ),
          ),

          // Badge giỏ hàng
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_cart_outlined,
                    size: 22, color: Color(0xFF0D47A1)),
              ),
              if (_cartCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5722),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_cartCount',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}