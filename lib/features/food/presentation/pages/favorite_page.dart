import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fash_food/core/theme/app_colors.dart';
import 'package:fash_food/features/food/presentation/bloc/favorite_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/cart_bloc.dart';
import 'package:fash_food/features/food/presentation/widgets/food_card.dart';
import 'package:fash_food/features/food/domain/entities/food_entity.dart';
import 'package:fash_food/features/food/domain/entities/cart_item_entity.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<FavoriteBloc>().add(WatchFavoritesEvent(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Món ăn yêu thích', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,

        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
            },
        ),
      ),
             // Quay lại trang trước đó (ProfilePage)


      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is FavoriteLoaded) {
            final favorites = state.favorites;
            if (favorites.isEmpty) {
              return _buildEmptyState();
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.68,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final fav = favorites[index];
                
                // Chuẩn hóa đường dẫn ảnh
                String displayImage = fav.productImage;
                if (!displayImage.startsWith('http') && !displayImage.startsWith('assets/')) {
                  // Nếu chỉ có tên file, mặc định thử thư mục categories
                  displayImage = 'assets/images/categories/$displayImage';
                }

                final food = FoodEntity(
                  id: fav.productId,
                  name: fav.productName,
                  imageUrl: displayImage,
                  price: fav.productPrice,
                  category: fav.categoryId,
                  description: 'Món ăn từ danh sách yêu thích', 
                  rating: 4.8,     
                  reviewCount: 120,
                );

                return FoodCard(
                  food: food,
                  onAddToCart: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthSuccess) {
                      final cartItem = CartItemEntity(
                        productId: food.id,
                        name: food.name,
                        image: food.imageUrl,
                        price: food.price,
                        quantity: 1,
                      );

                      context.read<CartBloc>().add(AddToCartEvent(
                        userId: authState.user.uid,
                        item: cartItem,
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

          if (state is FavoriteError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey.withValues(alpha: 0.4)),
          const SizedBox(height: 16),
          const Text('Chưa có món ăn yêu thích nào', 
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Có thể thêm logic quay về tab Home nếu cần
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Khám phá ngay', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
