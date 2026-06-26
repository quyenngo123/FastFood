import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_state.dart';
import 'package:fash_food/config/routes/app_routes.dart';
import 'package:fash_food/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          if (state is AuthSuccess) {
            context.go(AppRoutes.home);
          } else if (state is AuthLoggedOut) {
            context.go(AppRoutes.login);
          }
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: const Text(
                    'FastFood',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
