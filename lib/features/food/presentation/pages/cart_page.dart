import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../config/routes/app_routes.dart';
import '../bloc/cart_bloc.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/cart_entity.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Giỏ hàng')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Vui lòng đăng nhập để xem giỏ hàng'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('ĐĂNG NHẬP'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Giỏ hàng', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            context.read<CartBloc>().add(WatchCartEvent(userId));
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartLoaded) {
            final cart = state.cart;
            if (cart == null || cart.items.isEmpty) {
              return _buildEmptyCart(context);
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, cart, cart.items[index]);
                    },
                  ),
                ),
                _buildSummary(context, cart),
              ],
            );
          }

          if (state is CartError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Giỏ hàng của bạn đang trống', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('MUA SẮM NGAY', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartEntity cart, CartItemEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: _buildItemImage(item.image),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 6),
                Text('${_formatPrice(item.price)}đ', style: const TextStyle(color: AppColors.price, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuantityPicker(context, cart, item),
                    IconButton(
                      onPressed: () => _removeItem(context, cart, item.productId),
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(String imagePath) {
    return Image.network(
      imagePath,
      width: 90,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: 90,
        height: 90,
        color: Colors.grey[100],
        child: const Icon(Icons.fastfood, color: Colors.grey),
      ),
    );
  }

  Widget _buildQuantityPicker(BuildContext context, CartEntity cart, CartItemEntity item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _qtyBtn(Icons.remove, () => _updateQty(context, cart, item, item.quantity - 1)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          _qtyBtn(Icons.add, () => _updateQty(context, cart, item, item.quantity + 1)),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  void _updateQty(BuildContext context, CartEntity cart, CartItemEntity item, int newQty) {
    if (newQty < 1) return;
    final items = List<CartItemEntity>.from(cart.items);
    final index = items.indexWhere((i) => i.productId == item.productId);
    items[index] = item.copyWith(quantity: newQty);
    
    context.read<CartBloc>().add(UpdateCartEvent(cart.copyWith(items: items, updatedAt: DateTime.now())));
  }

  void _removeItem(BuildContext context, CartEntity cart, String productId) {
    final items = List<CartItemEntity>.from(cart.items)..removeWhere((i) => i.productId == productId);
    context.read<CartBloc>().add(UpdateCartEvent(cart.copyWith(items: items, updatedAt: DateTime.now())));
  }

  Widget _buildSummary(BuildContext context, CartEntity cart) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Phần Voucher
            InkWell(
              onTap: () => context.push(AppRoutes.vouchers),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.confirmation_number_outlined, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        cart.appliedVoucher != null 
                            ? 'Mã giảm giá: ${cart.appliedVoucher!.code}' 
                            : 'Chọn hoặc nhập mã giảm giá',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: cart.appliedVoucher != null ? AppColors.primary : Colors.black54,
                        ),
                      ),
                    ),
                    if (cart.appliedVoucher != null)
                      IconButton(
                        onPressed: () => context.read<CartBloc>().add(RemoveVoucherEvent()),
                        icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      )
                    else
                      const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Chi tiết tiền
            _buildPriceRow('Tạm tính', cart.subtotal),
            if (cart.discountAmount > 0)
              _buildPriceRow('Giảm giá', -cart.discountAmount, isDiscount: true),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tổng cộng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${_formatPrice(cart.totalAmount)}đ', style: AppTextStyles.heading2.copyWith(color: AppColors.price)),
              ],
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.push(AppRoutes.checkout, extra: cart),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text('THANH TOÁN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
          Text(
            '${amount > 0 ? '' : '-'}${_formatPrice(amount.abs())}đ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
