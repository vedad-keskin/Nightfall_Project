import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/alliance_service.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:provider/provider.dart';

class WerewolfRolesScreen extends StatefulWidget {
  const WerewolfRolesScreen({super.key});

  @override
  State<WerewolfRolesScreen> createState() => _WerewolfRolesScreenState();
}

class _WerewolfRolesScreenState extends State<WerewolfRolesScreen> {
  final WerewolfRoleService _roleService = WerewolfRoleService();
  final WerewolfAllianceService _allianceService = WerewolfAllianceService();
  late List<WerewolfRole> _roles;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  // Track flip state for each card
  late List<bool> _isFlipped;

  @override
  void initState() {
    super.initState();
    _roles = _roleService.getRoles();
    _isFlipped = List.generate(_roles.length, (_) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _getAllianceColor(int allianceId) {
    switch (allianceId) {
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.redAccent;
      case 3:
        return Colors.purpleAccent;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = context.watch<LanguageService>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfield(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      PixelButton(
                        label: languageService.translate('back'),
                        color: const Color(0xFF415A77),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Center(
                          child: Text(
                            'ROLES',
                            style: GoogleFonts.pressStart2p(
                              color: const Color(0xFFE0E1DD),
                              fontSize: 24,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  offset: Offset(4, 4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 80),
                    ],
                  ),
                ),

                // Swipable Cards
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _roles.length,
                    itemBuilder: (context, index) {
                      final role = _roles[index];
                      final isSelected = index == _currentPage;

                      return AnimatedScale(
                        duration: const Duration(milliseconds: 300),
                        scale: isSelected ? 1.0 : 0.8,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: isSelected ? 1.0 : 0.5,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFlipped[index] = !_isFlipped[index];
                              });
                            },
                            child: Center(
                              child: AspectRatio(
                                aspectRatio: 880 / 1184,
                                child: TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOutBack,
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: _isFlipped[index] ? 180 : 0,
                                  ),
                                  builder: (context, double value, child) {
                                    final isBack = value > 90;
                                    return Transform(
                                      transform: Matrix4.identity()
                                        ..setEntry(3, 2, 0.001)
                                        ..rotateY(value * pi / 180),
                                      alignment: Alignment.center,
                                      child: isBack
                                          ? Transform(
                                              transform: Matrix4.identity()
                                                ..rotateY(pi),
                                              alignment: Alignment.center,
                                              child: _buildCardBack(role),
                                            )
                                          : _buildCardFront(role),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _roles.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: index == _currentPage
                              ? const Color(0xFFE0E1DD)
                              : const Color(0xFF415A77),
                        ),
                      ),
                    ),
                  ),
                ),

                Text(
                  'TAP CARD TO FLIP',
                  style: GoogleFonts.vt323(color: Colors.white38, fontSize: 20),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront(WerewolfRole role) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF778DA9), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(role.imagePath, fit: BoxFit.cover),
          // Name Overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
              child: Text(
                role.name.toUpperCase(),
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(WerewolfRole role) {
    final alliance = _allianceService.getAllianceById(role.allianceId);
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF778DA9),
        border: Border.all(color: const Color(0xFF415A77), width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              role.name.toUpperCase(),
              style: GoogleFonts.pressStart2p(
                color: const Color(0xFFE0E1DD),
                fontSize: 18,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(height: 4, width: 100, color: const Color(0xFF415A77)),
            const SizedBox(height: 20),

            // Scrollable Content Region
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Alliance
                    Text(
                      'ALLIANCE',
                      style: GoogleFonts.vt323(
                        color: Colors.white54,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      alliance?.name.toUpperCase() ?? 'UNKNOWN',
                      style: GoogleFonts.vt323(
                        color: _getAllianceColor(role.allianceId),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      role.description,
                      style: GoogleFonts.vt323(
                        color: Colors.white,
                        fontSize: 22,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Fixed Win Points at bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'WIN: ${role.points} PTS',
                    style: GoogleFonts.pressStart2p(
                      color: Colors.amber,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
