import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/food_entity.dart';
import '../../domain/entities/favorite_entity.dart';
import '../bloc/favorite_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: _buildImage(food.imageUrl),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is! AuthSuccess) return const SizedBox.shrink();
                    final userId = authState.user.uid;

                    return BlocBuilder<FavoriteBloc, FavoriteState>(
                      builder: (context, favState) {
                        bool isFavorite = false;
                        FavoriteEntity? currentFav;

                        if (favState is FavoriteLoaded) {
                          final index = favState.favorites.indexWhere((f) => f.productId == food.id);
                          isFavorite = index != -1;
                          if (isFavorite) currentFav = favState.favorites[index];
                        }

                        return GestureDetector(
                          onTap: () {
                            final favorite = currentFav ?? FavoriteEntity(
                              id: const Uuid().v4(),
                              userId: userId,
                              productId: food.id,
                              productName: food.name,
                              productImage: food.imageUrl,
                              productPrice: food.price,
                              categoryId: food.category,
                              addedAt: DateTime.now(),
                            );
                            context.read<FavoriteBloc>().add(ToggleFavoriteEvent(favorite, !isFavorite));
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isFavorite 
                                  ? Colors.white 
                                  : Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (food.isPopular)
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: _buildBadge('🔥 Hot', const Color(0xFFFF9800)),
                ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 16),
                          const SizedBox(width: 2),
                          Text(
                            '${food.rating} (${food.reviewCount})',
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_formatPrice(food.price)}đ',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFF6D00),
                        ),
                      ),
                      GestureDetector(
                        onTap: onAddToCart,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D47A1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 20),
                        ),
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

  Widget _buildImage(String path) {
    const double imgHeight = 130;
    if (path.isEmpty) return _buildErrorPlaceholder(imgHeight);

    if (path.startsWith('http')) {
      return Image.network(
        path,
        height: imgHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: imgHeight,
            color: const Color(0xFFF5F5F5),
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(imgHeight),
      );
    }

    List<String> possiblePaths = [
      path,
      if (!path.startsWith('assets/')) 'assets/$path',
      if (!path.startsWith('assets/')) 'assets/images/categories/$path',
      if (!path.startsWith('assets/')) 'assets/images/foods/$path',
    ];

    return _tryLoadAsset(possiblePaths, 0, imgHeight);
  }

  Widget _tryLoadAsset(List<String> paths, int index, double height) {
    if (index >= paths.length) return _buildErrorPlaceholder(height);

    return Image.asset(
      paths[index],
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _tryLoadAsset(paths, index + 1, height);
      },
    );
  }

  Widget _buildErrorPlaceholder(double height) {
    return Container(
      height: height,
      color: const Color(0xFFF5F5F5),
      child: const Center(
        child: Icon(Icons.fastfood_outlined, color: Colors.grey, size: 30),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 10, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
