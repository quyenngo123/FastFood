import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fash_food/injection_container.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_event.dart';
import 'package:fash_food/features/auth/presentation/bloc/auth_state.dart';
import 'package:fash_food/config/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Sử dụng Package Import đồng bộ
      create: (_) => sl<AuthBloc>()..add(const CheckAuthRequested()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppRoutes.home);
          } else if (state is AuthLoggedOut) {
            context.go(AppRoutes.login);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CustomPaint(painter: _LogoPainter()),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'FastFood',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0D47A1),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    _drawBurger(canvas, Offset(cx - 52, cy + 28), 28);
    _drawFries(canvas, Offset(cx - 44, cy - 22), 26);
    _drawBurger(canvas, Offset(cx + 46, cy - 20), 26);
    _drawFries(canvas, Offset(cx + 50, cy + 24), 22);
    _drawLightning(canvas, size);
  }

  void _drawBurger(Canvas canvas, Offset center, double r) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFFC8860A);
    final bunPath = Path()..addArc(Rect.fromCenter(center: center.translate(0, -r * 0.3), width: r * 2, height: r * 1.1), 3.14159, 3.14159);
    canvas.drawPath(bunPath, paint);
    paint.color = const Color(0xFF7B3F00);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center, width: r * 2, height: r * 0.38), const Radius.circular(3)), paint);
    paint.color = const Color(0xFF4CAF50);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(0, r * 0.22), width: r * 2.1, height: r * 0.22), const Radius.circular(3)), paint);
    paint.color = const Color(0xFFE6A020);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(0, r * 0.52), width: r * 1.9, height: r * 0.38), const Radius.circular(8)), paint);
  }

  void _drawFries(Canvas canvas, Offset center, double r) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFFB71C1C);
    final boxPath = Path()..moveTo(center.dx - r * 0.7, center.dy)..lineTo(center.dx + r * 0.7, center.dy)..lineTo(center.dx + r * 0.5, center.dy + r * 1.0)..lineTo(center.dx - r * 0.5, center.dy + r * 1.0)..close();
    canvas.drawPath(boxPath, paint);
    paint.color = const Color(0xFFFDD835);
    for (int i = -1; i <= 1; i++) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: center.translate(i * r * 0.45, -r * 0.5), width: r * 0.28, height: r * 0.9), const Radius.circular(4)), paint);
    }
  }

  void _drawLightning(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final lightningPath = Path()..moveTo(cx + 8, cy - 72)..lineTo(cx - 18, cy - 4)..lineTo(cx + 6, cy - 4)..lineTo(cx - 8, cy + 72)..lineTo(cx + 20, cy + 6)..lineTo(cx - 4, cy + 6)..close();
    canvas.drawPath(lightningPath, Paint()..shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF64B5F6), Color(0xFF1565C0)]).createShader(Rect.fromLTWH(cx - 30, cy - 75, 60, 150)));
    canvas.drawPath(lightningPath, Paint()..style = PaintingStyle.stroke..color = Colors.white..strokeWidth = 5..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
