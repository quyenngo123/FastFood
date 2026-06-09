import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final int cartCount;
  final ValueChanged<int> onTap;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.cartCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Color(0x0D000000), blurRadius: 20)],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF1976D2),
        unselectedItemColor: const Color(0xFFB0BEC5),
        onTap: onTap,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Trang chủ'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.explore_rounded), label: 'Khám phá'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_rounded),
                if (cartCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5722),
                        shape: BoxShape.circle,
                      ),
                      constraints:
                      const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Giỏ hàng',
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: 'Yêu thích'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}