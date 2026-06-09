import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), // Thêm horizontal padding
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Giới hạn kích thước icon để không gây tràn
          SizedBox(
            width: 20,
            height: 20,
            child: icon,
          ),
          const SizedBox(width: 8),
          // Sử dụng Flexible để Text tự xuống dòng hoặc co lại nếu thiếu chỗ
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis, // Nếu dài quá sẽ hiện dấu ...
            ),
          ),
        ],
      ),
    );
  }
}