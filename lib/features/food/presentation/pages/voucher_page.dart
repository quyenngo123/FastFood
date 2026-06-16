import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fash_food/core/theme/app_colors.dart';
import 'package:fash_food/features/food/presentation/bloc/voucher_bloc.dart';
import 'package:fash_food/features/food/presentation/bloc/cart_bloc.dart';
import 'package:fash_food/features/food/domain/entities/voucher_entity.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  @override
  void initState() {
    super.initState();
    context.read<VoucherBloc>().add(GetVouchersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ưu đãi của bạn', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<VoucherBloc, VoucherState>(
        builder: (context, state) {
          if (state is VoucherLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is VoucherLoaded) {
            final vouchers = state.vouchers;
            if (vouchers.isEmpty) {
              return _buildEmptyState();
            }

            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                final appliedVoucher = cartState is CartLoaded ? cartState.cart?.appliedVoucher : null;
                final double subtotal = cartState is CartLoaded ? (cartState.cart?.subtotal ?? 0.0) : 0.0;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: vouchers.length,
                  itemBuilder: (context, index) {
                    return _buildVoucherCard(vouchers[index], appliedVoucher, subtotal);
                  },
                );
              },
            );
          }

          if (state is VoucherError) {
            return Center(child: Text('Lỗi: ${state.message}', style: const TextStyle(color: AppColors.error)));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.confirmation_number_outlined, size: 100, color: AppColors.textHint.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('Hiện chưa có mã giảm giá nào', 
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(VoucherEntity voucher, VoucherEntity? appliedVoucher, double subtotal) {
    final bool isApplied = appliedVoucher?.id == voucher.id;
    final bool canApply = subtotal >= voucher.minOrderAmount;
    final bool isExpired = voucher.isExpired;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipPath(
        clipper: VoucherClipper(),
        child: Row(
          children: [
            // Cột trái: Giá trị
            Container(
              width: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isExpired 
                      ? [Colors.grey.shade400, Colors.grey.shade500] 
                      : [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars, color: Colors.white, size: 28),
                  const SizedBox(height: 4),
                  Text(
                    '${(voucher.discountAmount / 1000).round()}k',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text('GIẢM GIÁ', 
                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
                ],
              ),
            ),
            
            // Đường kẻ đứt quãng
            CustomPaint(
              size: const Size(1, double.infinity),
              painter: DashedLinePainter(color: Colors.grey.shade300),
            ),

            // Cột phải: Thông tin
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              voucher.code,
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 16, 
                                color: isExpired ? AppColors.textSecondary : AppColors.primaryDark,
                              ),
                            ),
                            if (isApplied)
                              const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          voucher.description,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đơn tối thiểu: ${_formatPrice(voucher.minOrderAmount)}đ',
                              style: const TextStyle(fontSize: 10, color: AppColors.textHint),
                            ),
                            Text(
                              'HSD: ${DateFormat('dd/MM/yyyy').format(voucher.expiryDate)}',
                              style: TextStyle(
                                fontSize: 10, 
                                color: isExpired ? AppColors.error : AppColors.textSecondary, 
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                        _buildActionButton(voucher, isApplied, canApply, isExpired),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(VoucherEntity voucher, bool isApplied, bool canApply, bool isExpired) {
    String label = 'DÙNG NGAY';
    Color btnColor = AppColors.primary;
    VoidCallback? onPressed = () {
      context.read<CartBloc>().add(ApplyVoucherEvent(voucher));
      Navigator.pop(context);
    };

    if (isExpired) {
      label = 'HẾT HẠN';
      btnColor = Colors.grey;
      onPressed = null;
    } else if (isApplied) {
      label = 'ĐANG DÙNG';
      btnColor = AppColors.success;
      onPressed = null;
    } else if (!canApply) {
      label = 'CHƯA ĐỦ';
      btnColor = AppColors.textHint;
      onPressed = null;
    }

    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  String _formatPrice(double price) {
    return NumberFormat('#,###', 'vi_VN').format(price);
  }
}

class VoucherClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double holeRadius = 10;
    double dashPosition = 110;

    path.lineTo(0, 0);
    path.lineTo(0, size.height);
    path.lineTo(dashPosition - holeRadius, size.height);
    path.arcToPoint(
      Offset(dashPosition + holeRadius, size.height),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(dashPosition + holeRadius, 0);
    path.arcToPoint(
      Offset(dashPosition - holeRadius, 0),
      radius: Radius.circular(holeRadius),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 15;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height - 15) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
