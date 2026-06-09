import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../food/data/datasources/combo_data.dart';
import '../../../food/domain/entities/combo_entity.dart';

class ComboList extends StatefulWidget {
  final ValueChanged<int> onCartUpdated;

  const ComboList({super.key, required this.onCartUpdated});

  @override
  State<ComboList> createState() => _ComboListState();
}

class _ComboListState extends State<ComboList> {
  late Future<List<ComboEntity>> _combosFuture;

  @override
  void initState() {
    super.initState();
    _combosFuture = ComboData.getCombosFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ComboEntity>>(
      future: _combosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 250,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox(
            height: 250,
            child: Center(child: Text('Lỗi khi tải dữ liệu combo')),
          );
        }

        final combos = snapshot.data ?? [];
        if (combos.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Text("Combo Siêu Ưu Đãi", style: AppTextStyles.heading2),
                  const SizedBox(width: 8),
                  const Icon(Icons.local_fire_department, color: Colors.orange),
                ],
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: combos.length,
                itemBuilder: (context, index) {
                  return _buildComboCard(context, combos[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildComboCard(BuildContext context, ComboEntity combo) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16, top: 5, bottom: 20),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 1. Ảnh nền Full Container
            Positioned.fill(
              child: Image.network(
                combo.image,
                fit: BoxFit.cover, // Ảnh phủ kín toàn bộ thẻ
                errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
              ),
            ),

            // 2. Lớp phủ Gradient giúp text màu trắng dễ đọc hơn
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 3. Nội dung văn bản đè lên ảnh
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildBadge(combo),
                  const SizedBox(height: 8),
                  Text(
                    combo.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    combo.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (combo.discountPercent > 0)
                            Text(
                              '${_formatPrice(combo.originalPrice)}đ',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                decoration: TextDecoration.lineThrough,
                                fontSize: 11,
                              ),
                            ),
                          Text(
                            '${_formatPrice(combo.comboPrice)}đ',
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      // Nút Giỏ hàng hình tròn màu trắng nổi bật (CTA)
                      GestureDetector(
                        onTap: () {
                          widget.onCartUpdated(1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${combo.name} vào giỏ!'),
                              duration: const Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.shopping_cart_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 4. Nhãn giảm giá ở góc trên
            if (combo.discountPercent > 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '-${combo.discountPercent}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(ComboEntity combo) {
    if (!combo.isBestSeller && !combo.isNew) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: combo.isBestSeller ? Colors.orange : Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        combo.isBestSeller ? "BÁN CHẠY" : "MỚI",
        style: const TextStyle(
          color: Colors.white, 
          fontSize: 9, 
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}
