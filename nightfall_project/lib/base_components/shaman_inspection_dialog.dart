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
  static const Color shamanColor = Color(0xFFE8720C); // Ember orange

  late AnimationController _entryController;
  late AnimationController _pulseController;
  late AnimationController _revealController;
  late AnimationController _spiritController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _revealScale;
  late Animation<double> _revealOpacity;
  late Animation<double> _spiritGlow;

  int _stage = 0; // 0: channeling, 1: revealed

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.elasticOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.1, end: 0.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _revealScale = Tween<double>(begin: 1.15, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _revealOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _spiritController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _spiritGlow = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _spiritController, curve: Curves.easeInOut),
    );

    _entryController.forward();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _stage = 1);
        _revealController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entryController.dispose();
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

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 420),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B2A),
                  border: Border.all(color: shamanColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: shamanColor.withOpacity(_pulseAnimation.value),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: shamanColor.withOpacity(
                        _pulseAnimation.value * 0.3,
                      ),
                      blurRadius: 60,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header bar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        shamanColor.withOpacity(0.3),
                        shamanColor.withOpacity(0.1),
                        shamanColor.withOpacity(0.3),
                      ],
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: shamanColor.withOpacity(0.6),
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    lang.translate('shaman_vision_title').toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.pressStart2p(
                      color: shamanColor,
                      fontSize: 12,
                      shadows: [
                        Shadow(
                          color: shamanColor.withOpacity(0.6),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),

                // Player name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    widget.playerName.toUpperCase(),
                    style: GoogleFonts.vt323(
                      color: Colors.white,
                      fontSize: 32,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          color: shamanColor.withOpacity(0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                ),

                // Main content area
                if (_stage == 0) ...[
                  _buildChannelingState(lang),
                ] else ...[
                  _buildRevealedState(lang, roleColor),
                ],

                // Footer button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: PixelButton(
                    label: _stage == 1
                        ? lang.translate('understood_button')
                        : lang.translate('processing'),
                    color: _stage == 1 ? shamanColor : Colors.grey,
                    onPressed: _stage == 1 ? widget.onClose : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChannelingState(LanguageService lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: AnimatedBuilder(
        animation: _spiritGlow,
        builder: (context, _) {
          return Column(
            children: [
              // Animated fire/spirit icon
              Container(
                width: 80,
                height: 80,
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
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.local_fire_department,
                  color: shamanColor.withOpacity(
                    0.4 + _spiritGlow.value * 0.6,
                  ),
                  size: 44,
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
                  fontSize: 22,
                  letterSpacing: 2,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRevealedState(LanguageService lang, Color roleColor) {
    return AnimatedBuilder(
      animation: _revealController,
      builder: (context, child) {
        return Transform.scale(
          scale: _revealScale.value,
          child: Opacity(
            opacity: _revealOpacity.value,
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtitle
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              lang.translate('shaman_spirits_reveal'),
              textAlign: TextAlign.center,
              style: GoogleFonts.vt323(
                color: shamanColor.withOpacity(0.8),
                fontSize: 17,
                letterSpacing: 1,
              ),
            ),
          ),

          // Big cover image
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              constraints: const BoxConstraints(maxHeight: 350),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: roleColor.withOpacity(0.7),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: roleColor.withOpacity(0.25),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: shamanColor.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  // Role image as big cover
                  AspectRatio(
                    aspectRatio: 880 / 1034,
                    child: Image.asset(
                      widget.role.imagePath,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),

                  // Bottom gradient with role name overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 40, 12, 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.95),
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Role name
                          Text(
                            lang
                                .translate(widget.role.translationKey)
                                .toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.pressStart2p(
                              color: roleColor,
                              fontSize: 16,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  color: roleColor.withOpacity(0.6),
                                  blurRadius: 10,
                                ),
                                const Shadow(
                                  color: Colors.black,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Thin colored accent line at top
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 3,
                      color: roleColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
