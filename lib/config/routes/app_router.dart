import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/address_page.dart';
import '../../features/auth/presentation/pages/settings_page.dart';
import '../../features/auth/presentation/pages/edit_profile_page.dart';
import '../../features/auth/presentation/pages/change_password_page.dart';
import '../../features/auth/presentation/pages/policy_page.dart';
import '../../features/auth/presentation/widgets/splash_page.dart';
import '../../features/food/domain/entities/food_entity.dart';
import '../../features/food/domain/entities/cart_entity.dart';
import '../../features/food/presentation/pages/food_page.dart';
import '../../features/food/presentation/pages/food_detail_page.dart';
import '../../features/food/presentation/pages/cart_page.dart';
import '../../features/food/presentation/pages/voucher_page.dart';
import '../../features/food/presentation/pages/favorite_page.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/pages/checkout_page.dart';
import '../../features/orders/presentation/pages/order_success_page.dart';
import '../../features/orders/presentation/pages/order_history_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/notification_page.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.food,
        name: 'food',
        builder: (context, state) => const FoodPage(),
      ),
      GoRoute(
        path: AppRoutes.foodDetail,
        name: 'foodDetail',
        builder: (context, state) {
          final food = state.extra as FoodEntity;
          return FoodDetailPage(food: food);
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: AppRoutes.vouchers,
        name: 'vouchers',
        builder: (context, state) => const VoucherPage(),
      ),
      GoRoute(
        path: AppRoutes.favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritePage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) {
          final cart = state.extra as CartEntity;
          return CheckoutPage(cart: cart);
        },
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        name: 'order-success',
        builder: (context, state) => const OrderSuccessPage(),
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        name: 'order-history',
        builder: (context, state) => const OrderHistoryPage(),
      ),
      GoRoute(
        path: '/order-detail',
        name: 'order-detail',
        builder: (context, state) {
          final order = state.extra as OrderEntity;
          return OrderDetailPage(order: order);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.address,
        name: 'address',
        builder: (context, state) => const AddressPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.policy,
        name: 'policy',
        builder: (context, state) => const PolicyPage(),
      ),
    ],
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Trang không tìm thấy')),
    ),
  );
}
