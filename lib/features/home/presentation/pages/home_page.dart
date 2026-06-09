import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/combo_list.dart';
import '../widgets/home_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _cartCount = 0;

  String get _displayName {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? user?.email ?? 'Bạn';
    return name.split(' ').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: CustomScrollView(
        slivers: [
          // Header + Search bar: Thu nhỏ chỉ còn Search bar khi cuộn
          SliverAppBar(
            pinned: true,
            expandedHeight: 190,
            toolbarHeight: 0, // Đặt về 0 để khi thu gọn chỉ còn lại thanh Search Bar
            backgroundColor: AppColors.primaryDark,
            elevation: 0,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax, // Hiệu ứng mờ dần khi cuộn
              background: HomeHeader(userName: _displayName, showSearchBar: false),
            ),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: HomeSearchBar(),
              ),
            ),
          ),
          
          // Phần nội dung cuộn bên dưới
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const PromoCarousel(),
                _buildSectionTitle('Danh mục'),
                CategoryGrid(),
                _buildSectionTitle('Combo đặc sắc 🔥'),
                ComboList(
                  onCartUpdated: (count) =>
                      setState(() => _cartCount += count),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _selectedIndex,
        cartCount: _cartCount,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 25, 24, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF263238))),
          const Text('Xem tất cả',
              style: TextStyle(
                  color: Color(0xFF1976D2),
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
