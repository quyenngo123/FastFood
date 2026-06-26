import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailUpdates = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Cài đặt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Tài khoản'),
                _buildSettingTile(
                  icon: Icons.person_outline,
                  title: 'Chỉnh sửa hồ sơ',
                  onTap: () => context.push(AppRoutes.editProfile),
                ),
                _buildSettingTile(
                  icon: Icons.lock_outline,
                  title: 'Thay đổi mật khẩu',
                  onTap: () => context.push(AppRoutes.changePassword),
                ),
                _buildSectionHeader('Thông báo'),
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Thông báo đẩy',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Cập nhật qua Email',
                  value: _emailUpdates,
                  onChanged: (val) => setState(() => _emailUpdates = val),
                ),
                _buildSectionHeader('Ứng dụng'),
                _buildSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Chế độ tối',
                  value: _darkMode,
                  onChanged: (val) => setState(() => _darkMode = val),
                ),
                _buildSettingTile(
                  icon: Icons.language_outlined,
                  title: 'Ngôn ngữ',
                  trailing: const Text('Tiếng Việt', style: TextStyle(color: Colors.grey)),
                  onTap: () => _showLanguageDialog(context),
                ),
                _buildSectionHeader('Khác'),
                _buildSettingTile(
                  icon: Icons.info_outline,
                  title: 'Về chúng tôi',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Fast Food App',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2024 Fast Food Team',
                    );
                  },
                ),
                _buildSettingTile(
                  icon: Icons.description_outlined,
                  title: 'Điều khoản và Chính sách',
                  onTap: () => context.push(AppRoutes.policy),
                ),
                const SizedBox(height: 20),
                _buildDangerZone(context),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Chọn ngôn ngữ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('Tiếng Việt'),
                trailing: const Icon(Icons.check_circle, color: AppColors.primary),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('English'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: const TextStyle(fontSize: 15)),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent, size: 22),
        title: const Text('Xóa tài khoản', style: TextStyle(color: Colors.redAccent, fontSize: 15)),
        onTap: () => _showDeleteAccountDialog(context),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa tài khoản'),
        content: const Text('Hành động này không thể hoàn tác. Tất cả dữ liệu của bạn sẽ bị xóa vĩnh viễn.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY')),
          TextButton(
            onPressed: () {
              // Thực hiện logic xóa trên Firebase
              Navigator.pop(context);
            },
            child: const Text('XÓA', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
