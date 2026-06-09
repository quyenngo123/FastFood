import 'package:flutter/material.dart';
import 'package:fash_food/shared/widgets/rainbow_text.dart';

class AuthHeader extends StatelessWidget {
  final String subtitle;
  final bool showBackButton;

  const AuthHeader({
    super.key,
    required this.subtitle,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1565C0),
            Color(0xFF29B6F6),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút back sát góc trên trái
            if (showBackButton)
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              )
            else
              const SizedBox(height: 8),

            // Tên app căn giữa
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: Column(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFE3F2FD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'FastFood',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Color(0x660D47A1),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    RainbowText(
                      text: subtitle,
                      fontSize: 15,
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
}