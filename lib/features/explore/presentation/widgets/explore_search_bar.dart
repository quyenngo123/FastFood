import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ExploreSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final bool autofocus; // Thêm biến kiểm soát tự động focus

  const ExploreSearchBar({
    super.key, 
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        autofocus: autofocus, // Thiết lập autofocus
        decoration: InputDecoration(
          hintText: 'Tìm kiếm món ăn, combo...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          border: InputBorder.none,
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
          ),
        ),
      ),
    );
  }
}
