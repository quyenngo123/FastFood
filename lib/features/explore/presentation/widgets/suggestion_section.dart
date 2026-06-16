import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../food/domain/entities/food_entity.dart';
import '../../../food/domain/entities/cart_item_entity.dart';
import '../../../food/presentation/bloc/cart_bloc.dart';

class SuggestionSection extends StatelessWidget {
  final List<FoodEntity> suggestions;
  const SuggestionSection({super.key, required this.suggestions});

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
    if (suggestions.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 25, 24, 15),
          child: Text(
            'Gợi ý dành cho bạn ✨',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 220, // Tăng nhẹ chiều cao để chứa nội dung bên dưới ảnh
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final food = suggestions[index];
              return _buildSuggestionCard(context, food);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(BuildContext context, FoodEntity food) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.foodDetail, extra: food),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                food.imageUrl,
                height: 120,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  width: 150,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_formatPrice(food.price)} VND',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.price,
                    fontSize: 11,
                  ),
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
    );
  }
}
