import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fash_food/injection_container.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_event.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_state.dart';
import 'package:fash_food/features/auth/presentation/pages/auth_header.dart';
import 'package:fash_food/features/auth/presentation/widgets/social_button.dart';
import 'package:fash_food/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:fash_food/config/routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFF44336),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }

        if (state is AuthSuccess) {
          context.go(AppRoutes.home);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              const AuthHeader(subtitle: 'Chào mừng bạn trở lại 👋'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    children: [
                      // KHUNG ĐĂNG NHẬP CHÍNH
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 16,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(height: 20),
                            AuthInputField(
                              controller: _emailController,
                              hint: 'Email hoặc số điện thoại',
                              icon: Icons.person_outline,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            AuthInputField(
                              controller: _passwordController,
                              hint: 'Mật khẩu',
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: const Color(0xFF90A4AE),
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                  context.read<AuthBloc>().add(
                                    LoginSubmitted(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D47A1),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                child: isLoading
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text('ĐĂNG NHẬP', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // --- PHẦN MỚI THÊM: SOCIAL LOGIN ---
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Hoặc đăng nhập bằng',
                              style: TextStyle(color: Color(0xFF90A4AE), fontSize: 13),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: SocialButton(
                              icon: Image.asset ('assets/icons/google.png'),
                              label: 'Google',
                              onPressed: isLoading ? null : () {
                                // Logic đăng nhập Google
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: SocialButton(
                              icon: Image.asset ('assets/icons/facebook.png'),
                              label: 'Facebook',
                              onPressed: isLoading ? null : () {
                                // Logic đăng nhập Facebook
                              },
                            ),
                          ),
                        ],
                      ),
                      // --- KẾT THÚC PHẦN SOCIAL LOGIN ---

                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Chưa có tài khoản? ', style: TextStyle(color: Color(0xFF90A4AE), fontSize: 14)),
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.register),
                            child: const Text(
                              'Đăng ký ngay',
                              style: TextStyle(color: Color(0xFF0D47A1), fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}