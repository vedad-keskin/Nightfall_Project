import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class ShamanInspectionDialog extends StatefulWidget {
  final String playerName;
  final WerewolfRole role;
  final VoidCallback onClose;

  const ShamanInspectionDialog({
    super.key,
    required this.playerName,
    required this.role,
    required this.onClose,
  });

  @override
  State<ShamanInspectionDialog> createState() => _ShamanInspectionDialogState();
}

class _ShamanInspectionDialogState extends State<ShamanInspectionDialog>
    with TickerProviderStateMixin {
  static const Color shamanColor = Color(0xFFE8720C);

  late AnimationController _pulseController;
  late AnimationController _revealController;
  late AnimationController _spiritController;
  late AnimationController _smokeController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _revealOpacity;
  late Animation<double> _spiritGlow;
  late Animation<double> _smokeAnimation;

  int _stage = 0;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.1, end: 0.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _revealOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _revealController, curve: Curves.easeIn));

    _spiritController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _spiritGlow = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _spiritController, curve: Curves.easeInOut),
    );

    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _smokeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _smokeController, curve: Curves.linear),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _stage = 1);
        _revealController.forward();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _revealController.dispose();
    _spiritController.dispose();
    _smokeController.dispose();
    super.dispose();
  }

  Color _getRoleAllianceColor(int allianceId) {
    switch (allianceId) {
      case 1:
        return const Color(0xFF4CC9F0);
      case 2:
        return const Color(0xFFE63946);
      case 3:
        return const Color(0xFF9D4EDD);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    final roleColor = _getRoleAllianceColor(widget.role.allianceId);
    final screenH = MediaQuery.of(context).size.height;

    return Center(
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: screenH * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B2A),
                border: Border.all(color: shamanColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE63946).withOpacity(_pulseAnimation.value * 0.4),
                    blurRadius: 36,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: shamanColor.withOpacity(_pulseAnimation.value),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: shamanColor.withOpacity(_pulseAnimation.value * 0.3),
                    blurRadius: 48,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Red Smoke Background Layer
                  AnimatedBuilder(
                    animation: _smokeAnimation,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: RedSmokePainter(_smokeAnimation.value),
                        size: Size.infinite,
                      );
                    },
                  ),
                  // Content on top of smoke
                  child!,
                ],
              ),
            );
          },
          child: _stage == 0
              ? _buildChanneling(lang)
              : _buildRevealed(lang, roleColor),
        ),
      ),
    );
  }

  /// Stage 0: channeling spirits
  Widget _buildChanneling(LanguageService lang) {
    return Column(
      children: [
        _buildHeader(lang),
        Expanded(
          child: AnimatedBuilder(
            animation: _spiritGlow,
            builder: (context, _) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated mystical aura
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE63946).withOpacity(
                              _spiritGlow.value * 0.6,
                            ),
                            blurRadius: 40,
                            spreadRadius: 12,
                          ),
                          BoxShadow(
                            color: const Color(0xFFE63946).withOpacity(
                              _spiritGlow.value * 0.3,
                            ),
                            blurRadius: 60,
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: shamanColor.withOpacity(
                              _spiritGlow.value * 0.4,
                            ),
                            blurRadius: 30,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Inner circle with border
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: shamanColor.withOpacity(_spiritGlow.value),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: shamanColor.withOpacity(
                              _spiritGlow.value * 0.5,
                            ),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                          BoxShadow(
                            color: const Color(0xFFE63946).withOpacity(
                              _spiritGlow.value * 0.3,
                            ),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.local_fire_department,
                        color: shamanColor.withOpacity(
                          0.4 + _spiritGlow.value * 0.6,
                        ),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      lang.translate('shaman_channeling'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vt323(
                        color: shamanColor.withOpacity(
                          0.4 + _spiritGlow.value * 0.6,
                        ),
                        fontSize: 20,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: const Color(0xFFE63946).withOpacity(
                              _spiritGlow.value * 0.5,
                            ),
                            blurRadius: 12,
                          ),
                          Shadow(
                            color: shamanColor.withOpacity(0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildFooter(context.watch<LanguageService>()),
      ],
    );
  }

  /// Aspect ratio of role card images (880 x 1184)
  static const double _imageAspectRatio = 880 / 1184;

  /// Stage 1: role revealed – full image (880x1184) with name + role overlaid at bottom
  Widget _buildRevealed(LanguageService lang, Color roleColor) {
    return FadeTransition(
      opacity: _revealOpacity,
      child: Column(
        children: [
          _buildHeader(lang),

          // "Spirits reveal the truth" - Minimalistic banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: shamanColor.withOpacity(0.1),
              border: const Border(
                bottom: BorderSide(color: Color(0xFF415A77), width: 2),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE63946).withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  lang.translate('shaman_spirits_reveal'),
                  style: GoogleFonts.pressStart2p(
                    color: shamanColor,
                    fontSize: 14,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFE63946).withOpacity(0.6),
                        blurRadius: 12,
                      ),
                      Shadow(
                        color: shamanColor.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Image displayed fully (880x1184), with name + role in bottom overlay
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;
                double imgW, imgH;
                if (w / h > _imageAspectRatio) {
                  imgH = h;
                  imgW = h * _imageAspectRatio;
                } else {
                  imgW = w;
                  imgH = w / _imageAspectRatio;
                }
                return Center(
                  child: SizedBox(
                    width: imgW,
                    height: imgH,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Image.asset(
                          widget.role.imagePath,
                          width: imgW,
                          height: imgH,
                          fit: BoxFit.contain,
                        ),
                        // Player Name Overlay (top of image)
                        Positioned(
                          top: 12,
                          left: 0,
                          right: 0,
                          child: Container(
                            color: Colors.black.withOpacity(0.65),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              widget.playerName.toUpperCase(),
                              style: GoogleFonts.vt323(
                                color: Colors.white,
                                fontSize: 30,
                                letterSpacing: 3,
                                shadows: [
                                  Shadow(
                                    color: shamanColor.withOpacity(0.4),
                                    blurRadius: 8,
                                  ),
                                  const Shadow(
                                    color: Colors.black,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  const Color(0xFF0D1B2A).withOpacity(0.7),
                                  const Color(0xFF0D1B2A).withOpacity(0.95),
                                ],
                                stops: const [0.0, 0.4, 1.0],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Enhanced Role Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        roleColor.withOpacity(0.2),
                                        roleColor.withOpacity(0.35),
                                        roleColor.withOpacity(0.2),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: roleColor.withOpacity(0.9),
                                      width: 2.5,
                                    ),
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFE63946).withOpacity(0.5),
                                        blurRadius: 20,
                                        spreadRadius: 3,
                                      ),
                                      BoxShadow(
                                        color: roleColor.withOpacity(0.4),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: roleColor.withOpacity(0.2),
                                        blurRadius: 24,
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFFE63946).withOpacity(0.15),
                                        blurRadius: 40,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    lang
                                        .translate(widget.role.translationKey)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.pressStart2p(
                                      color: roleColor,
                                      fontSize: 20,
                                      height: 1.3,
                                      shadows: [
                                        Shadow(
                                          color: const Color(0xFFE63946).withOpacity(0.7),
                                          blurRadius: 14,
                                        ),
                                        Shadow(
                                          color: roleColor.withOpacity(0.8),
                                          blurRadius: 10,
                                        ),
                                        Shadow(
                                          color: roleColor.withOpacity(0.5),
                                          blurRadius: 6,
                                        ),
                                        const Shadow(
                                          color: Colors.black,
                                          blurRadius: 6,
                                          offset: Offset(2, 2),
                                        ),
                                        const Shadow(
                                          color: Colors.black87,
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          _buildFooter(lang),
        ],
      ),
    );
  }

  /// Shared header bar
  Widget _buildHeader(LanguageService lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: shamanColor.withOpacity(0.2),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF415A77), width: 2),
        ),
      ),
      child: Text(
        lang.translate('shaman_vision_title').toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.pressStart2p(
          color: shamanColor,
          fontSize: 11,
          shadows: [Shadow(color: shamanColor.withOpacity(0.5), blurRadius: 6)],
        ),
      ),
    );
  }

  /// Shared footer button
  Widget _buildFooter(LanguageService lang) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      child: PixelButton(
        label: _stage == 1
            ? lang.translate('understood_button')
            : lang.translate('processing'),
        color: _stage == 1 ? shamanColor : Colors.grey,
        onPressed: _stage == 1 ? widget.onClose : null,
      ),
    );
  }
}

/// Custom painter for red smoke/mist effects
class RedSmokePainter extends CustomPainter {
  final double animationProgress;
  final Paint _smokePaint = Paint();
  final math.Random _random = math.Random(42); // Fixed seed for consistency

  RedSmokePainter(this.animationProgress);

  @override
  void paint(Canvas canvas, Size size) {
    // Create multiple layers of animated smoke
    _drawSmokeLayer(canvas, size, 0.2, 0.3);
    _drawSmokeLayer(canvas, size, 0.4, 0.25);
    _drawSmokeLayer(canvas, size, 0.6, 0.2);
    _drawSmokeLayer(canvas, size, 0.8, 0.15);
  }

  void _drawSmokeLayer(Canvas canvas, Size size, double baseOpacity, double hueShift) {
    final particleCount = 15;
    final smokeColor = Color.fromARGB(
      (255 * baseOpacity * (1 - (animationProgress - hueShift).abs())).toInt().clamp(0, 255),
      230, // Red
      57,  // Red
      70,  // Red
    );

    for (int i = 0; i < particleCount; i++) {
      final seed = i * 997; // Prime multiplier for consistency
      final x = (size.width * (0.5 + 0.4 * math.sin((animationProgress * 2 * math.pi + seed * 0.5)))) % size.width;
      final y = (size.height * (0.3 + 0.3 * math.cos((animationProgress * 2 * math.pi + seed * 0.7)))) % size.height;
      final radius = 30 + 20 * math.sin(seed * 0.1);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = smokeColor
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25),
      );
    }

    // Floating vertical smoke ribbons
    for (int i = 0; i < 4; i++) {
      final baseX = size.width * (0.15 + i * 0.25);
      final progress = (animationProgress + i * 0.25) % 1.0;
      final ribbonOpacity = baseOpacity * 0.5 * (1 - (progress - hueShift).abs());

      final path = Path();
      path.moveTo(baseX - 15, size.height * 0.1);

      for (int y = 0; y < 10; y++) {
        final dy = size.height * (0.1 + y * 0.08);
        final dx = baseX + 15 * math.sin((progress * 4 * math.pi + y) * 0.5);
        if (y == 0) {
          path.moveTo(dx, dy);
        } else {
          path.lineTo(dx, dy);
        }
      }

      canvas.drawPath(
        path,
        Paint()
          ..color = Color.fromARGB(
            (255 * ribbonOpacity).toInt().clamp(0, 255),
            230,
            57,
            70,
          )
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
    }
  }

  @override
  bool shouldRepaint(RedSmokePainter oldDelegate) => oldDelegate.animationProgress != animationProgress;
}
