import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/services/language_service.dart';
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

  late AnimationController _pulseController;
  late AnimationController _revealController;
  late AnimationController _spiritController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _revealOpacity;
  late Animation<double> _spiritGlow;

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
    _revealOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeIn),
    );

    _spiritController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _spiritGlow = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _spiritController, curve: Curves.easeInOut),
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
                    color: shamanColor.withOpacity(_pulseAnimation.value),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: shamanColor.withOpacity(
                      _pulseAnimation.value * 0.3,
                    ),
                    blurRadius: 48,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: child,
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
                    const SizedBox(height: 16),
                    Text(
                      lang.translate('shaman_channeling'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.vt323(
                        color: shamanColor.withOpacity(
                          0.4 + _spiritGlow.value * 0.6,
                        ),
                        fontSize: 20,
                        letterSpacing: 2,
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

          // "Spirits reveal the truth"
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1B263B),
              border: Border(
                bottom: BorderSide(color: Color(0xFF415A77), width: 2),
              ),
            ),
            child: Text(
              lang.translate('shaman_spirits_reveal'),
              style: GoogleFonts.vt323(
                color: shamanColor.withOpacity(0.95),
                fontSize: 24,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
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
                                  const Color(0xFF0D1B2A).withOpacity(0.92),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              20,
                              16,
                              16,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.playerName.toUpperCase(),
                                  style: GoogleFonts.vt323(
                                    color: Colors.white,
                                    fontSize: 30,
                                    letterSpacing: 2,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: roleColor.withOpacity(0.2),
                                    border: Border.all(
                                      color: roleColor.withOpacity(0.8),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    lang
                                        .translate(widget.role.translationKey)
                                        .toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.pressStart2p(
                                      color: roleColor,
                                      fontSize: 23,
                                      height: 1.3,
                                      shadows: [
                                        Shadow(
                                          color: roleColor.withOpacity(0.6),
                                          blurRadius: 8,
                                        ),
                                        const Shadow(
                                          color: Colors.black,
                                          blurRadius: 4,
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
          shadows: [
            Shadow(
              color: shamanColor.withOpacity(0.5),
              blurRadius: 6,
            ),
          ],
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
