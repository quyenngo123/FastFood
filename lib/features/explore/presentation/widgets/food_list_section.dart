import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../food/domain/entities/food_entity.dart';

class FoodListSection extends StatelessWidget {
  final List<FoodEntity> foods;
  final String? title;
  final Function(FoodEntity)? onAddToCart; // Thêm callback này

  const FoodListSection({
    super.key,
    required this.foods,
    this.title,
    this.onAddToCart,
  });

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 25, 24, 15),
          child: Text(
            title ?? 'Khám phá tất cả',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            return _buildFoodCard(context, food);
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodEntity food) {
    return GestureDetector(
      onTap: () => context.push('/food_detail', extra: food),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      food.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                  if (food.isPromo)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.promo,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'GIẢM GIÁ',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    food.category,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatPrice(food.price)} VND',
                        style: const TextStyle(
                          color: AppColors.price,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onAddToCart?.call(food),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
