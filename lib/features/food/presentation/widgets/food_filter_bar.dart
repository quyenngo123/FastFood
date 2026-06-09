import 'package:flutter/material.dart';

class FoodFilterBar extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const FoodFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == selectedCategory;
          return GestureDetector(
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0D47A1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0D47A1)
                      : const Color(0xFFE0E0E0),
                ),
                boxShadow: isSelected
                    ? const [
                  BoxShadow(
                    color: Color(0x330D47A1),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ]
                    : null,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF757575),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}