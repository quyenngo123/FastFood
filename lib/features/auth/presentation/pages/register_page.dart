import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fash_food/injection_container.dart';
import 'package:fash_food/config/routes/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'auth_header.dart';
import '../widgets/auth_input_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocConsumer<AuthBloc, AuthState>(
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
            context.go(AppRoutes.home); // GoRouter — chuyển sang Home
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: Column(
              children: [
                const AuthHeader(
                  subtitle: 'Tạo tài khoản mới ✨',
                  showBackButton: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                    child: Container(
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
                            'Đăng ký',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                          const SizedBox(height: 20),
                          AuthInputField(
                            controller: _fullNameController,
                            hint: 'Họ và tên',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          AuthInputField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Icons.email_outlined,
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
                              icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AuthInputField(
                            controller: _confirmPasswordController,
                            hint: 'Xác nhận mật khẩu',
                            icon: Icons.lock_outline,
                            obscureText: _obscureConfirm,
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                                  activeColor: const Color(0xFF0D47A1),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Tôi đồng ý với ',
                                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                                    children: const [
                                      TextSpan(
                                        text: 'Điều khoản & Chính sách',
                                        style: TextStyle(
                                          color: Color(0xFF0D47A1),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (isLoading || !_agreeToTerms) ? null : () {
                                context.read<AuthBloc>().add(
                                  RegisterSubmitted(
                                    fullName: _fullNameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                    confirmPassword: _confirmPasswordController.text,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D47A1),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                elevation: _agreeToTerms ? 2 : 0,
                              ),
                              child: isLoading
                                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                  : const Text('ĐĂNG KÝ', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
