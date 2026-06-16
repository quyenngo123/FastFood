import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../food/domain/entities/cart_entity.dart';
import '../../../food/presentation/bloc/cart_bloc.dart';
import '../../../food/presentation/bloc/cart_event.dart';

import '../../domain/entities/order_entity.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class CheckoutPage extends StatefulWidget {
  final CartEntity cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _paymentMethod = 'COD';

  @override
  void initState() {
    super.initState();
    _fillUserData();
  }

  void _fillUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final user = authState.user;
      _nameController.text = user.name ?? '';
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _onPlaceOrder() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthSuccess) return;

      final order = OrderEntity(
        id: const Uuid().v4(),
        userId: authState.user.uid,
        items: widget.cart.items,
        subtotal: widget.cart.subtotal,
        discountAmount: widget.cart.discountAmount,
        totalAmount: widget.cart.totalAmount,
        voucherCode: widget.cart.appliedVoucher?.code,
        status: 'pending',
        createdAt: DateTime.now(),
        address: _addressController.text,
        phone: _phoneController.text,
      );

      context.read<OrderBloc>().add(PlaceOrderEvent(order));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderPlacedSuccess) {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthSuccess) {
                context.read<CartBloc>().add(ClearCartEvent(authState.user.uid));
              }
              context.go(AppRoutes.orderSuccess);
            } else if (state is OrderFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          title: const Text('Thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Thông tin giao hàng', Icons.local_shipping_rounded),
                _buildInfoCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('Phương thức thanh toán', Icons.payment_rounded),
                _buildPaymentMethod(),
                const SizedBox(height: 24),
                _buildSectionTitle('Tóm tắt đơn hàng', Icons.receipt_long_rounded),
                _buildOrderSummary(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5D6785),
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          _buildInputField(
            controller: _nameController,
            label: 'Người nhận',
            icon: Icons.person_rounded,
            hint: 'Nhập họ tên',
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F1F1)),
          ),
          _buildInputField(
            controller: _phoneController,
            label: 'Số điện thoại',
            icon: Icons.phone_android_rounded,
            hint: 'Nhập số điện thoại',
            keyboardType: TextInputType.phone,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF1F1F1)),
          ),
          _buildInputField(
            controller: _addressController,
            label: 'Địa chỉ giao hàng',
            icon: Icons.location_on_rounded,
            hint: 'Nhập địa chỉ giao hàng',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)),
              TextFormField(
                controller: controller,
                maxLines: maxLines,
                keyboardType: keyboardType,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3142)),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(top: 4),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Vui lòng điền thông tin' : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: RadioListTile<String>(
        title: const Text('Thanh toán khi nhận hàng (COD)',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle:
            const Text('Giao hàng tận nơi mới thu tiền', style: TextStyle(fontSize: 12)),
        value: 'COD',
        groupValue: _paymentMethod,
        activeColor: AppColors.primary,
        onChanged: (value) {
          setState(() {
            _paymentMethod = value!;
          });
        },
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.money, color: Colors.green, size: 20),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ...widget.cart.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.quantity}x ${item.name}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4A4E69)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('${_formatPrice(item.price * item.quantity)}đ',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ],
                ),
              )),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFF1F1F1)),
          ),
          _buildPriceRow('Tạm tính', widget.cart.subtotal),
          if (widget.cart.discountAmount > 0)
            _buildPriceRow('Giảm giá (${widget.cart.appliedVoucher?.code})', -widget.cart.discountAmount, isDiscount: true),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng thanh toán',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2D3142))),
              Text('${_formatPrice(widget.cart.totalAmount)}đ',
                  style: TextStyle(
                      color: AppColors.price, fontWeight: FontWeight.w900, fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            '${amount > 0 ? '' : '-'}${_formatPrice(amount.abs())}đ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5)),
        ],
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: SafeArea(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            final isLoading = state is OrderLoading;
            return SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : _onPlaceOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('XÁC NHẬN ĐẶT HÀNG',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            letterSpacing: 0.5)),
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
