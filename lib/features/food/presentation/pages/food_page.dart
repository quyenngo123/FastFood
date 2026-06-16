import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/food_data.dart';
import '../bloc/food_bloc.dart';
import '../bloc/cart_bloc.dart';
import '../widgets/food_card.dart';
import '../widgets/food_filter_bar.dart';
import '../../domain/entities/cart_item_entity.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String _selectedCategory = 'Tất cả';

  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(WatchFoodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          FoodFilterBar(
            categories: FoodData.categories,
            selectedCategory: _selectedCategory,
            onSelected: (cat) => setState(() => _selectedCategory = cat),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<FoodBloc, FoodState>(
              builder: (context, state) {
                if (state is FoodLoading) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                }

                if (state is FoodLoaded) {
                  final filteredFoods = _selectedCategory == 'Tất cả'
                      ? state.foods
                      : state.foods.where((f) => 
                          f.category.trim().toLowerCase() == _selectedCategory.trim().toLowerCase()
                        ).toList();

                  if (filteredFoods.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7, // Điều chỉnh tỉ lệ để card cân đối hơn
                    ),
                    itemCount: filteredFoods.length,
                    itemBuilder: (context, index) {
                      final food = filteredFoods[index];
                      return FoodCard(
                        food: food,
                        onAddToCart: () {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is AuthSuccess) {
                            context.read<CartBloc>().add(AddToCartEvent(
                              userId: authState.user.uid,
                              item: CartItemEntity(
                                productId: food.id,
                                name: food.name,
                                image: food.imageUrl,
                                price: food.price,
                                quantity: 1,
                              ),
                            ));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Đã thêm ${food.name} vào giỏ hàng'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      );
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 52, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _selectedCategory == 'Tất cả' ? 'Thực đơn' : _selectedCategory,
              style: const TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold, 
                color: Colors.white,
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () => context.push(AppRoutes.cart),
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is CartLoaded && state.cart != null) {
                    count = state.cart!.items.length;
                  }
                  if (count == 0) return const SizedBox.shrink();
                  return Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_food_outlined, size: 64, color: Colors.grey.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text('Chưa có món nào trong mục $_selectedCategory', 
            style: const TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }
}
