import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../food/domain/entities/food_entity.dart';

class RecentFoodsSection extends StatelessWidget {
  final List<FoodEntity> foods;
  const RecentFoodsSection({super.key, required this.foods});

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 25, 24, 15),
          child: Text(
            'Vừa xem gần đây 🕒',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return _buildRecentCard(context, food);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCard(BuildContext context, FoodEntity food) {
    return GestureDetector(
      onTap: () => context.push('/food_detail', extra: food),
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(food.imageUrl),
            ),
            const SizedBox(height: 5),
            Text(
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
