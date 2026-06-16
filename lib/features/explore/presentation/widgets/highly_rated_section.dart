import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../food/domain/entities/food_entity.dart';
import '../../../food/domain/entities/cart_item_entity.dart';
import '../../../food/presentation/bloc/cart_bloc.dart';

class HighlyRatedSection extends StatelessWidget {
  final List<FoodEntity> foods;
  const HighlyRatedSection({super.key, required this.foods});

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  void _handleAddToCart(BuildContext context, FoodEntity food) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để mua hàng')),
      );
      return;
    }

    final cartItem = CartItemEntity(
      productId: food.id,
      name: food.name,
      image: food.imageUrl,
      price: food.price,
      quantity: 1,
    );

    context.read<CartBloc>().add(AddToCartEvent(
          userId: user.uid,
          item: cartItem,
        ));

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        content: Text('Đã thêm ${food.name} vào giỏ hàng'),
        action: SnackBarAction(
          label: 'XEM GIỎ',
          textColor: Colors.white,
          onPressed: () => context.push(AppRoutes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 25, 24, 15),
          child: Text(
            'Đánh giá cao ⭐',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return _buildRatedCard(context, food);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRatedCard(BuildContext context, FoodEntity food) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.foodDetail, extra: food),
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            Shadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                food.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    food.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      Text(' ${food.rating}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(' (${food.reviewCount})', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatPrice(food.price)} VND',
                        style: const TextStyle(color: AppColors.price, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () => _handleAddToCart(context, food),
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

class Shadow extends BoxShadow {
  const Shadow({super.color, super.offset, super.blurRadius});
}
