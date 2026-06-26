import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../food/presentation/bloc/cart_bloc.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../food/presentation/pages/favorite_page.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_carousel.dart';
import '../widgets/category_grid.dart';
import '../widgets/combo_list.dart';
import '../widgets/home_bottom_nav.dart';
import '../bloc/notification_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<CartBloc>().add(WatchCartEvent(user.uid));
      context.read<NotificationBloc>().add(WatchNotificationsEvent(user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String displayName = 'Bạn';
        if (authState is AuthSuccess) {
          displayName = authState.user.name ?? authState.user.email.split('@').first;
        }

        // Danh sách các trang cho Bottom Nav
        final List<Widget> pages = [
          _HomeTabContent(
            displayName: displayName,
            onSearchTap: () => setState(() => _selectedIndex = 1),
          ),
          const ExplorePage(),
          const Center(child: Text('Giỏ hàng')), 
          FavoritePage(onBack: () {
            setState(() => _selectedIndex = 0);
          }), 
          const Center(child: Text('Hồ sơ')), 
        ];

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          body: IndexedStack(
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
            builder: (context, cartState) {
              int totalItems = 0;
              if (cartState is CartLoaded && cartState.cart != null) {
                totalItems = cartState.cart!.totalItems;
              }

              return HomeBottomNav(
                currentIndex: _selectedIndex,
                cartCount: totalItems,
                onTap: (index) {
                  if (index == 2) {
                    context.push(AppRoutes.cart);
                  } else if (index == 4) {
                    context.push(AppRoutes.profile);
                  } else {
                    setState(() => _selectedIndex = index);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  final String displayName;
  final VoidCallback onSearchTap;

  const _HomeTabContent({
    required this.displayName,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 190,
          toolbarHeight: 0,
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
            collapseMode: CollapseMode.parallax,
            background: HomeHeader(
              userName: displayName, 
              showSearchBar: false,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: HomeSearchBar(onTap: onSearchTap),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const PromoCarousel(),
              _buildSectionTitle('Danh mục'),
              CategoryGrid(),
              _buildSectionTitle('Combo đặc sắc 🔥'),
              const ComboList(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
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

class HomeSearchBar extends StatelessWidget {
  final VoidCallback onTap;
  const HomeSearchBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: const Row(
          children: [
            Icon(Icons.search, color: Colors.grey, size: 20),
            SizedBox(width: 12),
            Text('Tìm món ăn bạn yêu thích...', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
