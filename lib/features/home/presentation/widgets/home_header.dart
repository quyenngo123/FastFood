import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';


class HomeHeader extends StatelessWidget {
  final String userName;
  final bool showSearchBar;
  final bool isSticky;

  const HomeHeader({
    super.key,
    required this.userName,
    this.showSearchBar = true,
    this.isSticky = false,
  });

  @override
  Widget build(BuildContext context) {
    // Nếu là sticky (dùng trong SliverAppBar), chúng ta để background trong suốt 
    // và điều chỉnh padding cho phù hợp với FlexibleSpaceBar
    return Container(
      padding: EdgeInsets.fromLTRB(24, isSticky ? 50 : 60, 24, showSearchBar ? 20 : 0),
      decoration: isSticky 
          ? null 
          : const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeaderUserInfo(userName: userName),
          if (showSearchBar) ...[
            const SizedBox(height: 18),
            const HomeSearchBar(),
          ],
        ],
      ),
    );
  }
}

class HomeHeaderUserInfo extends StatelessWidget {
  final String userName;
  const HomeHeaderUserInfo({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Xin chào 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        const HomeNotificationIcon(),
      ],
    );
  }
}

class HomeNotificationIcon extends StatelessWidget {
  const HomeNotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(Icons.notifications_none_rounded,
            color: Colors.white, size: 28),
        Positioned(
          right: 2,
          top: 2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
                color: Color(0xFFF44336), shape: BoxShape.circle),
            child: const Text('2',
                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.white70, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tìm burger, pizza, trà sữa...',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
