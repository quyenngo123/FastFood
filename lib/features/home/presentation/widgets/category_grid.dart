import 'package:flutter/material.dart';
import '../../../food/presentation/pages/category_detail_page.dart';

class CategoryGrid extends StatelessWidget {
  CategoryGrid({super.key});

  // Đã cập nhật: Thay icon bằng URL ảnh PNG 3D và đổi tên key thành 'image'
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Burger',
      'image': 'assets/images/categories/burger.png',
      'color': const Color(0xFFFFECB3),
    },
    {
      'name': 'Pizza',
      'image': 'assets/images/categories/pizza.png',
      'color': const Color(0xFFFFCCBC),
    },
    {
      'name': 'Bánh Mì',
      'image': 'assets/images/categories/banh_mi.png',
      'color': const Color(0xFFDCEDC8),
    },
    {
      'name': 'Kimbap',
      'image': 'assets/images/categories/kimbap.png',
      'color': const Color(0xFFE1F5FE),
    },
    {
      'name': 'Gà Rán',
      'image':'assets/images/categories/ga_ran.png',
      'color': const Color(0xFFFFF9C4),
    },
    {
      'name': 'Mì Ý',
      'image': 'assets/images/categories/mi_y.png',
      'color': const Color(0xFFFFE0B2),
    },
    {
      'name': 'Ăn vặt',
      'image':'assets/images/categories/an_vat.png',
      'color': const Color(0xFFF1F8E9),
    },
    {
      'name': 'Đồ uống',
      'image':'assets/images/categories/do_uong.png',
      'color': const Color(0xFFE8EAF6),
    },
    {
      'name': 'Tráng miệng',
      'image': 'assets/images/categories/trang_miem.png',
      'color': const Color(0xFFFCE4EC),
    },
    {
      'name': 'Lẩu',
      'image': 'assets/images/categories/lau.png',
      'color': const Color(0xFFFFEBEE),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10, // Giảm khoảng cách ngang để hiện được nhiều món hơn
          crossAxisSpacing: 12,
          childAspectRatio: 1.45, // Tỷ lệ này giúp các item hẹp lại -> hiển thị được nhiều hơn
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CategoryDetailPage(
                  categoryName: cat['name'] ?? 'Danh mục',
                  categoryImage: cat['image'] ?? '',
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 62, // Thu nhỏ nhẹ vòng tròn để hợp với tỷ lệ mới
                  height: 62,
                  decoration: BoxDecoration(
                    color: (cat['color'] as Color).withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (cat['color'] as Color).withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
            child: Center(
              child: Image.asset(
                cat['image'] ?? '',
                width: 42,
                height: 42,
                fit: BoxFit.contain,
                // loadingBuilder không dùng được với Image.asset -> đã xóa
                errorBuilder: (context, error, stackTrace) {
                  // Nếu không tìm thấy file ảnh trong assets, hiện icon mặc định
                  return const Icon(Icons.fastfood, color: Colors.grey);
                },
              ),
            ),
                ),


                const SizedBox(height: 6),
                Text(
                  cat['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF37474F),
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}