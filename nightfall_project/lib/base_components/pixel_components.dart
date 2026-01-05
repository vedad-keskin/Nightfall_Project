import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:provider/provider.dart';

export 'pixel_button.dart';

class PixelDialog extends StatelessWidget {
  final String title;
  final Color color;
  final Color accentColor;
  final String? soundPath;
  final VoidCallback? onPressed;

  const PixelDialog({
    super.key,
    required this.title,
    required this.color,
    required this.accentColor,
    this.soundPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      // Layer 1: Outer Border / Shadow Base
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6), // Semi-transparent outer border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(12, 12), // Deep shadow
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4), // Thickness of outer black border
      child: Container(
        // Layer 2: Main Frame Color (Silver/Stone)
        decoration: BoxDecoration(
          color: const Color(0xFF778DA9).withOpacity(0.9), // Stone Grey
          border: Border.symmetric(
            vertical: BorderSide(
              color: const Color(0xFF415A77).withOpacity(0.9),
              width: 4,
            ), // Side accents
            horizontal: BorderSide(
              color: const Color(0xFFE0E1DD).withOpacity(0.9),
              width: 4,
            ), // Top/Bottom highlights
          ),
        ),
        padding: const EdgeInsets.all(4), // Thickness of metallic frame
        child: Container(
          // Layer 3: Inner Inset Border
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A).withOpacity(0.85), // Inner BG base
            border: Border.all(color: Colors.black.withOpacity(0.6), width: 2),
          ),
          child: Container(
            // Actual Content Background
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            color: const Color(0xFF0D1B2A), // Dark Night Blue
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B).withOpacity(0.9),
                    border: Border.all(
                      color: const Color(0xFF415A77).withOpacity(0.9),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.pressStart2p(
                      color: const Color(0xFFE0E1DD),
                      fontSize: 24,
                      shadows: [
                        const Shadow(
                          color: Color(0xFF000000),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                PixelButton(
                  label: context.watch<LanguageService>().translate('play_now'),
                  color: const Color(0xFF415A77),
                  soundPath: soundPath,
                  onPressed: onPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PixelStarfield extends StatefulWidget {
  const PixelStarfield({super.key});

  @override
  State<PixelStarfield> createState() => _PixelStarfieldState();
}

class _PixelStarfieldState extends State<PixelStarfield>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Generate stars
    for (int i = 0; i < 50; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextBool() ? 2 : 4,
          speed: 0.2 + _random.nextDouble() * 0.5,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(_stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Star {
  double x;
  double y;
  final double size;
  final double speed;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF1B263B), // Deep Midnight Blue
          Color(0xFF000000), // Pure Black
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final starPaint = Paint()..color = Colors.white.withOpacity(0.4);

    for (var star in stars) {
      // Calculate animated Y position
      // Move downwards
      double currentY = (star.y + (animationValue * star.speed)) % 1.0;

      canvas.drawRect(
        Rect.fromLTWH(
          star.x * size.width,
          currentY * size.height,
          star.size,
          star.size,
        ),
        starPaint,
      );
    }
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => true;
}
