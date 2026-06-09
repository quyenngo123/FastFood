import 'package:flutter/material.dart';
import '../../domain/entities/food_entity.dart';

class FoodCard extends StatelessWidget {
  final FoodEntity food;
  final VoidCallback onAddToCart;

  const FoodCard({
    super.key,
    required this.food,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh món ăn
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  food.imageUrl,
                  height: 120, // Giảm nhẹ chiều cao ảnh (từ 130 xuống 120)
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 120,
                      color: const Color(0xFFF5F5F5),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: const Color(0xFFF5F5F5),
                    child: const Icon(Icons.broken_image_outlined,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),
              if (food.hasDiscount)
                Positioned(
                  top: 8,
                  left: 8,
                  child: _buildBadge('-${food.discountPercent}%', const Color(0xFFFF5722)),
                ),
              if (food.isPopular)
                Positioned(
                  top: 8,
                  right: 8,
                  child: _buildBadge('🔥 Hot', const Color(0xFFFF9800)),
                ),
            ],
          ),

          // Thông tin món
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF212121)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        food.description,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Rating & Giá (Gom nhóm để ổn định vị trí)
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFC107), size: 14),
                          const SizedBox(width: 2),
                          Text(
                            food.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${food.reviewCount})',
                            style: const TextStyle(
                                fontSize: 9, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              '${_formatPrice(food.price)}đ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFF6D00)),
                            ),
                          ),
                          GestureDetector(
                            onTap: onAddToCart,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D47A1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
