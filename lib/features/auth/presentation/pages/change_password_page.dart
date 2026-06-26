import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/app_colors.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate user first
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);
        
        // Then update password
        await user.updatePassword(_newPasswordController.text);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đổi mật khẩu thành công'), backgroundColor: AppColors.success),
          );
          Navigator.pop(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String message = 'Đã xảy ra lỗi. Vui lòng thử lại.';
        if (e.code == 'wrong-password') {
          message = 'Mật khẩu hiện tại không chính xác.';
        } else if (e.code == 'requires-recent-login') {
          message = 'Hành động này yêu cầu bạn phải đăng nhập lại gần đây.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xảy ra lỗi không xác định.'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đổi mật khẩu', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Để bảo mật, vui lòng nhập mật khẩu hiện tại trước khi thay đổi mật khẩu mới.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              _buildPasswordField(
                controller: _currentPasswordController,
                label: 'Mật khẩu hiện tại',
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Vui lòng nhập mật khẩu hiện tại';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'Mật khẩu mới',
                validator: (value) {
                  if (value == null || value.length < 6) return 'Mật khẩu mới phải có ít nhất 6 ký tự';
                  if (value == _currentPasswordController.text) return 'Mật khẩu mới phải khác mật khẩu hiện tại';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Xác nhận mật khẩu mới',
                validator: (value) {
                  if (value != _newPasswordController.text) return 'Mật khẩu xác nhận không khớp';
                  return null;
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('CẬP NHẬT MẬT KHẨU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
