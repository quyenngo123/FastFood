import 'package:flutter/material.dart'; // THÊM DÒNG NÀY
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/widgets/splash_page.dart';
import '../../features/food/presentation/pages/food_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../injection_container.dart';
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
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const RegisterPage(),
        ),
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
    ],
    // Sửa phần errorBuilder để đảm bảo có Scaffold bọc ngoài
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Trang không tìm thấy')),
    ),
  );
}