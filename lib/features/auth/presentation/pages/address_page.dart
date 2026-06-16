import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/address_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  void _loadAddresses() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<AddressBloc>().add(GetAddressesEvent(authState.user.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          'Địa chỉ của tôi',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.orange),
            onPressed: _loadAddresses,
          ),
        ],
      ),
      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          if (state is AddressLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (state is AddressLoaded) {
            if (state.addresses.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return _buildAddressItem(address);
              },
            );
          } else if (state is AddressError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  Text(state.message, style: const TextStyle(color: Colors.grey)),
                  TextButton(onPressed: _loadAddresses, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _showAddressForm(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_location_alt_outlined),
              SizedBox(width: 8),
              Text('THÊM ĐỊA CHỈ MỚI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.location_off_rounded, size: 100, color: Colors.orange.withOpacity(0.2)),
            ),
            const SizedBox(height: 24),
            const Text(
              'Chưa có địa chỉ giao hàng',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Vui lòng thêm địa chỉ để chúng tôi có thể giao hàng nhanh nhất cho bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontSize: 15, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressItem(address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: address.isDefault ? Colors.orange.withOpacity(0.5) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // Edit address
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: address.isDefault ? Colors.orange : Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    _getAddressIcon(address.label),
                    color: address.isDefault ? Colors.white : Colors.grey[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.label,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          if (address.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Mặc định',
                                style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        address.street,
                        style: TextStyle(color: Colors.grey[800], fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        address.city,
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                _buildActionMenu(address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getAddressIcon(String label) {
    final l = label.toLowerCase();
    if (l.contains('nhà')) return Icons.home_rounded;
    if (l.contains('văn phòng') || l.contains('công ty') || l.contains('work')) return Icons.business_center_rounded;
    return Icons.location_on_rounded;
  }

  Widget _buildActionMenu(address) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert, color: Colors.grey[400]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit_outlined, size: 20),
              SizedBox(width: 10),
              Text('Chỉnh sửa'),
            ],
          ),
        ),
        if (!address.isDefault)
          const PopupMenuItem(
            value: 'default',
            child: Row(
              children: [
                Icon(Icons.check_circle_outline, size: 20),
                SizedBox(width: 10),
                Text('Đặt mặc định'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: Colors.red),
              SizedBox(width: 10),
              Text('Xóa', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        final authState = context.read<AuthBloc>().state;
        if (authState is! AuthSuccess) return;

        if (value == 'delete') {
          _confirmDelete(context, address.id, authState.user.uid);
        } else if (value == 'default') {
          context.read<AddressBloc>().add(SetDefaultAddressEvent(addressId: address.id, userId: authState.user.uid));
        }
      },
    );
  }

  void _confirmDelete(BuildContext context, String addressId, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Xóa địa chỉ?'),
        content: const Text('Bạn có chắc chắn muốn xóa địa chỉ này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('HỦY')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AddressBloc>().add(DeleteAddressEvent(addressId: addressId, userId: userId));
            },
            child: const Text('XÓA', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddressForm(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng thêm địa chỉ đang được phát triển'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20),
      ),
    );
  }
}
