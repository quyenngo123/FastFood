import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/widgets/category_grid.dart';
import '../../../home/presentation/widgets/combo_list.dart';
import '../../../food/presentation/bloc/food_bloc.dart';
import '../widgets/explore_search_bar.dart';
import '../widgets/best_seller_section.dart';
import '../widgets/food_list_section.dart';
import '../widgets/highly_rated_section.dart';
import '../widgets/suggestion_section.dart';
import '../widgets/recent_foods_section.dart';
import '../widgets/explore_skeleton.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<FoodBloc>().add(WatchFoodsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state is FoodLoading) {
            return _buildLoadingState();
          }

          if (state is FoodLoaded) {
            final allFoods = state.foods;
            
            if (allFoods.isEmpty && _searchQuery.isEmpty) {
              return _buildEmptyState();
            }

            // Logic lọc món ăn theo tìm kiếm
            final searchResults = allFoods.where((food) {
              final name = food.name.toLowerCase();
              final category = food.category.toLowerCase();
              final query = _searchQuery.toLowerCase();
              return name.contains(query) || category.contains(query);
            }).toList();

            return RefreshIndicator(
              onRefresh: () async {
                _loadData();
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(),
                  
                  if (_searchQuery.isNotEmpty) ...[
                    // CHẾ ĐỘ TÌM KIẾM: Hiện kết quả search
                    SliverToBoxAdapter(
                      child: searchResults.isEmpty 
                        ? _buildNoResultState()
                        : FoodListSection(
                            foods: searchResults, 
                            title: 'Kết quả tìm kiếm cho "$_searchQuery"',
                          ),
                    ),
                  ] else ...[
                    // CHẾ ĐỘ KHÁM PHÁ: Hiện các Section gợi ý
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          _buildSectionHeader('Bạn muốn ăn gì hôm nay?', showViewAll: false),
                          CategoryGrid(), // Xóa const vì constructor không phải là const

                          RecentFoodsSection(foods: allFoods.take(5).toList()),

                          if (allFoods.where((f) => f.isPromo).isNotEmpty)
                            SuggestionSection(suggestions: allFoods.where((f) => f.isPromo).toList()),

                          BestSellerSection(foods: allFoods.where((f) => f.isPopular).toList()),

                          HighlyRatedSection(foods: allFoods.where((f) => f.rating >= 4.8).toList()),

                          _buildSectionHeader('Combo tiết kiệm 🎁'),
                          const ComboList(),

                          FoodListSection(foods: allFoods),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }

          if (state is FoodError) {
            return _buildErrorState(state.message);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 150, // Tăng nhẹ từ 140 lên 150
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 85), // Đẩy title lên cao hơn một chút (từ 75 lên 85)
        title: const Text(
          'Khám phá món ngon',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(70), // Tăng từ 60 lên 70 để tránh overflow
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
          child: ExploreSearchBar(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            autofocus: false, 
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = true}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF263238))),
          if (showViewAll)
            const Text('Xem tất cả', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildNoResultState() {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('Không tìm thấy kết quả cho "$_searchQuery"', 
              style: const TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        const SliverToBoxAdapter(
          child: ExploreSkeleton(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu_rounded, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('Chưa có dữ liệu món ăn', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverFillRemaining(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  const Text('Đã có lỗi xảy ra', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('Thử lại', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
