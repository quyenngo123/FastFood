import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../config/routes/app_routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          // Chuyển hướng về trang login và xóa sạch stack cũ
          context.go(AppRoutes.login);
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Hồ sơ của tôi', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          // Không rebuild giao diện khi trạng thái là AuthLoggedOut
          // Điều này giúp giữ lại giao diện Profile cho đến khi Navigator thực hiện chuyển trang
          buildWhen: (previous, current) => current is! AuthLoggedOut,
          builder: (context, state) {
            if (state is AuthSuccess) {
              final user = state.user;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(context, user),
                    const SizedBox(height: 20),
                    _buildMenuSection(context),
                    const SizedBox(height: 30),
                    _buildLogoutButton(context),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            }
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            // Trả về widget trống thay vì text thông báo để tránh gây khó chịu khi đang chuyển hướng
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.orange.shade100,
                backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                    ? NetworkImage(user.photoUrl!)
                    : NetworkImage('https://ui-avatars.com/api/?name=${user.name ?? 'User'}&background=FF9800&color=fff&size=128'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.settings);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.name ?? 'Người dùng',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            user.email,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (user.phone != null && user.phone!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              user.phone!,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.history,
            title: 'Lịch sử đơn hàng',
            onTap: () => context.push(AppRoutes.orderHistory),
          ),
          _divider(),
          _buildMenuItem(
            icon: Icons.location_on_outlined,
            title: 'Địa chỉ ',
            onTap: () => context.push(AppRoutes.address),
          ),
          _divider(),
          _buildMenuItem(
            icon: Icons.confirmation_number_outlined,
            title: 'Vouchers của tôi',
            onTap: () => context.push(AppRoutes.vouchers),
          ),
          _divider(),
          _buildMenuItem(
            icon: Icons.favorite_border,
            title: 'Món ăn yêu thích',
            onTap: () => context.push(AppRoutes.favorites),
          ),
          _divider(),
          _buildMenuItem(
            icon: Icons.notifications_none_rounded,
            title: 'Thông báo',
            onTap: () => context.push(AppRoutes.notifications),
          ),
          _divider(),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Cài đặt',
            onTap: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }

  Widget _divider() {
    return Divider(height: 1, indent: 20, endIndent: 20, color: Colors.grey[100]);
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _showLogoutDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent.withOpacity(0.1),
            foregroundColor: Colors.redAccent,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text('ĐĂNG XUẤT', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final profileContext = context;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('HỦY'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              profileContext.read<AuthBloc>().add(const LogoutRequested());
            },
            child: const Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
