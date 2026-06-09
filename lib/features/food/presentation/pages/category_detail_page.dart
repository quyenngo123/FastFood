import 'package:flutter/material.dart';
import '../../data/datasources/food_data.dart';
import '../../domain/entities/food_entity.dart';
import '../widgets/food_card.dart';

enum SortType { recent, bestSeller, rating }

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final String categoryImage;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _cartCount = 0;
  SortType _sortType = SortType.bestSeller;

  final List<_TabItem> _tabs = const [
    _TabItem(label: 'Gần đây', icon: Icons.access_time_rounded, sort: SortType.recent),
    _TabItem(label: 'Bán chạy', icon: Icons.local_fire_department_rounded, sort: SortType.bestSeller),
    _TabItem(label: 'Đánh giá', icon: Icons.star_rounded, sort: SortType.rating),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _sortType = _tabs[_tabController.index].sort);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<FoodEntity> get _sortedFoods {
    final foods = FoodData.getByCategory(widget.categoryName);

    switch (_sortType) {
      case SortType.bestSeller:
        return [...foods]..sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case SortType.rating:
        return [...foods]..sort((a, b) => b.rating.compareTo(a.rating));
      case SortType.recent:
        return [...foods].reversed.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Column(
        children: [
          _buildHeader(),
          _buildTabBar(),
          const SizedBox(height: 12),
          Expanded(child: _buildFoodGrid()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              widget.categoryName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shopping_cart_outlined,
                    size: 22, color: Colors.white),
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.all(4),
        indicator: BoxDecoration(
          color: const Color(0xFF0D47A1),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF9E9E9E),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        dividerColor: Colors.transparent,
        tabs: _tabs.map((tab) => Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tab.icon, size: 16),
              const SizedBox(width: 6),
              Text(tab.label),
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildFoodGrid() {
    final foods = _sortedFoods;

    if (foods.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.no_food_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 12),
            Text('Chưa có món nào trong danh mục này',
                style: TextStyle(color: Colors.grey, fontSize: 15)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.65, // Giảm tỷ lệ để Card cao hơn, tránh lỗi Overflow
      ),
      itemCount: foods.length,
      itemBuilder: (context, index) {
        return FoodCard(
          food: foods[index],
          onAddToCart: () {
            setState(() => _cartCount++);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm ${foods[index].name}!'),
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
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final SortType sort;
  const _TabItem({required this.label, required this.icon, required this.sort});
}
