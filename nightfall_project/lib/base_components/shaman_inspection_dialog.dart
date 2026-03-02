import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:nightfall_project/services/sound_settings_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'package:provider/provider.dart';

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
  static const Color crimsonSmoke = Color(0xFF8B2500);
  static const Color emberGlow = Color(0xFFFF6B35);
  static const Color spiritRed = Color(0xFFB22222);

  late AnimationController _pulseController;
  late AnimationController _revealController;
  late AnimationController _smokeController;
  late AnimationController _runeController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _revealOpacity;
  late Animation<double> _revealScale;
  late Animation<double> _smokeFade;

  int _stage = 0;
  String _typedText = '';
  Timer? _typeTimer;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.15, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _revealOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );
    _revealScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _smokeFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _runeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _startChannelingSequence();
  }

  Future<void> _startChannelingSequence() async {
    final lang = context.read<LanguageService>();
    final channelingText = lang.translate('shaman_channeling');

    await _typeText(channelingText);

    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    final isMuted = context.read<SoundSettingsService>().isMuted;
    if (!isMuted) {
      final player = AudioPlayer();
      try {
        await player.play(
          AssetSource('audio/werewolves/shaman_reveal.mp3'),
        );
      } catch (_) {
        // Silently ignore if file doesn't exist
      }
    }

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() => _stage = 1);
    _revealController.forward();
  }

  Future<void> _typeText(String text) async {
    _typedText = '';
    final completer = Completer<void>();
    int idx = 0;
    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
      if (idx < text.length && mounted) {
        setState(() => _typedText += text[idx]);
        idx++;
      } else {
        timer.cancel();
        completer.complete();
      }
    });
    return completer.future;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _revealController.dispose();
    _smokeController.dispose();
    _runeController.dispose();
    _typeTimer?.cancel();
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
                color: const Color(0xFF0A0E14),
                border: Border.all(
                  color: shamanColor.withOpacity(0.8),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: shamanColor.withOpacity(_pulseAnimation.value),
                    blurRadius: 28,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: crimsonSmoke.withOpacity(_pulseAnimation.value * 0.4),
                    blurRadius: 56,
                    spreadRadius: 6,
                  ),
                ],
              ),
              child: ClipRect(
                child: child,
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

  /// Stage 0: Channeling spirits with red smoke, ritual circle, runes
  Widget _buildChanneling(LanguageService lang) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Dark mystical gradient background
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    const Color(0xFF1A0A0A).withOpacity(0.9),
                    const Color(0xFF0D0505),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),

            // Rising red smoke particles
            ...List.generate(25, (i) => _buildSmokeParticle(i, w, h)),

            // Spirit wisps (floating ember orbs)
            ...List.generate(8, (i) => _buildSpiritWisp(i, w, h)),

            // Ritual circle
            Center(
              child: AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _runeController]),
                builder: (context, _) {
                  final glow = 0.3 + _pulseAnimation.value * 0.5;
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: _RitualCirclePainter(
                        color: shamanColor.withOpacity(glow),
                        innerGlow: crimsonSmoke.withOpacity(glow * 0.6),
                        progress: _runeController.value,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Central spirit icon
            Center(
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) {
              return Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: shamanColor.withOpacity(0.5 + _pulseAnimation.value * 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: shamanColor.withOpacity(_pulseAnimation.value * 0.8),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: emberGlow.withOpacity(_pulseAnimation.value * 0.4),
                      blurRadius: 48,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: shamanColor.withOpacity(0.6 + _pulseAnimation.value * 0.4),
                  size: 44,
                ),
              );
            },
          ),
            ),

            // Typed channeling text
            Positioned(
          left: 24,
          right: 24,
          bottom: 100,
          child: Center(
            child: Text(
              _typedText,
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                color: shamanColor.withOpacity(0.9),
                fontSize: 22,
                letterSpacing: 3,
                height: 1.4,
                shadows: [
                  Shadow(color: crimsonSmoke.withOpacity(0.8), blurRadius: 12),
                  Shadow(color: shamanColor.withOpacity(0.5), blurRadius: 6),
                ],
              ),
            ),
          ),
            ),

            // Header
            Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildHeader(lang),
            ),

            // Footer
            Positioned(
          bottom: 0,
          left: 0,
          right: 0,
              child: _buildFooter(lang),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSmokeParticle(int index, double width, double height) {
    final random = math.Random(index);
    final startX = random.nextDouble();
    final size = 40.0 + random.nextDouble() * 80;
    final duration = 2.5 + random.nextDouble() * 2.0;
    final delay = random.nextDouble() * 1.5;

    return AnimatedBuilder(
      animation: _smokeController,
      builder: (context, _) {
        final t = ((_smokeController.value + (delay / duration)) % 1.0);
        final y = 1.0 - t;
        final x = startX + math.sin(t * math.pi * 2) * 0.1;
        final opacity = (1.0 - t) * 0.4;
        final scale = 0.5 + t * 1.5;

        return Positioned(
          left: width * x - (size * scale) / 2,
          top: height * (0.3 + y * 0.7) - (size * scale) / 2,
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      crimsonSmoke.withOpacity(0.6),
                      spiritRed.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpiritWisp(int index, double width, double height) {
    final random = math.Random(index + 100);
    final x = random.nextDouble() * 0.8 + 0.1;
    final y = random.nextDouble() * 0.6 + 0.2;
    final phase = random.nextDouble() * math.pi * 2;

    return AnimatedBuilder(
      animation: _smokeController,
      builder: (context, _) {
        final pulse = math.sin(_smokeController.value * math.pi * 2 + phase) * 0.5 + 0.5;
        final size = 6.0 + pulse * 4;

        return Positioned(
          left: width * x - size / 2,
          top: height * y - size / 2,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: shamanColor.withOpacity(0.3 + pulse * 0.5),
              boxShadow: [
                BoxShadow(
                  color: emberGlow.withOpacity(pulse * 0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Aspect ratio of role card images (880 x 1184)
  static const double _imageAspectRatio = 880 / 1184;

  /// Stage 1: Role revealed – smoke parts, dramatic scale-in
  Widget _buildRevealed(LanguageService lang, Color roleColor) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.0,
              colors: [
                const Color(0xFF0D1B2A),
                const Color(0xFF0A0E14),
              ],
            ),
          ),
        ),

        // Lingering smoke overlay (fades out during reveal)
        AnimatedBuilder(
          animation: _revealController,
          builder: (context, _) {
            if (_smokeFade.value <= 0) return const SizedBox.shrink();
            return IgnorePointer(
              child: Container(
                color: Color.lerp(
                  Colors.transparent,
                  const Color(0xFF1A0505),
                  _smokeFade.value * 0.5,
                )!,
              ),
            );
          },
        ),

        // Main content
        FadeTransition(
          opacity: _revealOpacity,
          child: ScaleTransition(
            scale: _revealScale,
            child: Column(
              children: [
                _buildHeader(lang),

                // "Spirits reveal the truth" banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        shamanColor.withOpacity(0.15),
                        crimsonSmoke.withOpacity(0.1),
                      ],
                    ),
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFF415A77), width: 2),
                    ),
                  ),
                  child: Text(
                    lang.translate('shaman_spirits_reveal'),
                    style: GoogleFonts.pressStart2p(
                      color: shamanColor,
                      fontSize: 12,
                      shadows: [
                        Shadow(color: shamanColor.withOpacity(0.6), blurRadius: 8),
                        Shadow(color: crimsonSmoke.withOpacity(0.4), blurRadius: 4),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Role image with overlays
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
                        child: AnimatedBuilder(
                          animation: _revealController,
                          builder: (context, _) {
                            final glow = _revealOpacity.value * 0.5;
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: shamanColor.withOpacity(glow),
                                    blurRadius: 40,
                                    spreadRadius: 4,
                                  ),
                                  BoxShadow(
                                    color: roleColor.withOpacity(glow * 0.5),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
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
                                    Positioned(
                                      top: 12,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors.black.withOpacity(0.7),
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                          widget.playerName.toUpperCase(),
                                          style: GoogleFonts.vt323(
                                            color: Colors.white,
                                            fontSize: 28,
                                            letterSpacing: 4,
                                            shadows: [
                                              Shadow(
                                                color: shamanColor.withOpacity(0.5),
                                                blurRadius: 10,
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
                                              const Color(0xFF0A0E14).withOpacity(0.8),
                                              const Color(0xFF0A0E14),
                                            ],
                                            stops: const [0.0, 0.4, 1.0],
                                          ),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 18,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    roleColor.withOpacity(0.2),
                                                    roleColor.withOpacity(0.3),
                                                    roleColor.withOpacity(0.2),
                                                  ],
                                                ),
                                                border: Border.all(
                                                  color: roleColor.withOpacity(0.9),
                                                  width: 2.5,
                                                ),
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: roleColor.withOpacity(0.5),
                                                    blurRadius: 16,
                                                    spreadRadius: 1,
                                                  ),
                                                  BoxShadow(
                                                    color: roleColor.withOpacity(0.25),
                                                    blurRadius: 28,
                                                    spreadRadius: 2,
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
                                                  fontSize: 18,
                                                  height: 1.3,
                                                  shadows: [
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
                      );
                    },
                  ),
                ),

                _buildFooter(lang),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(LanguageService lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            shamanColor.withOpacity(0.25),
            crimsonSmoke.withOpacity(0.15),
          ],
        ),
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
          letterSpacing: 2,
          shadows: [
            Shadow(color: shamanColor.withOpacity(0.6), blurRadius: 8),
            Shadow(color: crimsonSmoke.withOpacity(0.3), blurRadius: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(LanguageService lang) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
      ),
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

/// Custom painter for the ritual circle with rotating runes
class _RitualCirclePainter extends CustomPainter {
  final Color color;
  final Color innerGlow;
  final double progress;

  _RitualCirclePainter({
    required this.color,
    required this.innerGlow,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Outer glow
    final glowPaint = Paint()
      ..color = innerGlow.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 90, glowPaint);

    // Outer ring
    final outerPaint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, 85, outerPaint);

    // Inner ring
    final innerPaint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 60, innerPaint);

    // Rotating rune segments (8 segments)
    for (int i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi + progress * 2 * math.pi;
      final x1 = center.dx + 70 * math.cos(angle);
      final y1 = center.dy + 70 * math.sin(angle);
      final x2 = center.dx + 75 * math.cos(angle);
      final y2 = center.dy + 75 * math.sin(angle);

      final segmentPaint = Paint()
        ..color = color.withOpacity(0.5 + 0.3 * math.sin(progress * math.pi * 2 + i))
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), segmentPaint);
    }

    // Center dot
    final centerPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 4, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _RitualCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.innerGlow != innerGlow ||
        oldDelegate.progress != progress;
  }
}
