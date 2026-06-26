import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    String initialName = '';
    String initialPhone = '';
    if (state is AuthSuccess) {
      initialName = state.user.name ?? '';
      initialPhone = state.user.phone ?? '';
    }
    _nameController = TextEditingController(text: initialName);
    _phoneController = TextEditingController(text: initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chỉnh sửa hồ sơ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật hồ sơ thành công'), backgroundColor: AppColors.success),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAvatarSection(state.user),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _nameController,
                      label: 'Họ và tên',
                      icon: Icons.person_outline,
                      validator: (value) => value == null || value.isEmpty ? 'Vui lòng nhập tên' : null,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Số điện thoại',
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 40),
                    _buildSaveButton(state.user),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Đã xảy ra lỗi'));
        },
      ),
    );
  }

  Widget _buildAvatarSection(UserEntity user) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? NetworkImage(user.photoUrl!)
                : NetworkImage('https://ui-avatars.com/api/?name=${user.name ?? 'User'}&background=FF9800&color=fff&size=128'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildSaveButton(UserEntity user) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            final updatedUser = UserEntity(
              uid: user.uid,
              email: user.email,
              name: _nameController.text,
              phone: _phoneController.text,
              photoUrl: user.photoUrl,
            );
            context.read<AuthBloc>().add(UpdateProfileRequested(updatedUser));
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: const Text('LƯU THAY ĐỔI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
