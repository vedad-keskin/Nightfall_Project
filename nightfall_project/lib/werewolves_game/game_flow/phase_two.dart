import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/alliance_service.dart';
import 'phase_three_night.dart';
import 'dart:math';

class WerewolfPhaseTwoScreen extends StatefulWidget {
  final Map<String, WerewolfRole> playerRoles;
  final List<WerewolfPlayer> players;

  const WerewolfPhaseTwoScreen({
    super.key,
    required this.playerRoles,
    required this.players,
  });

  @override
  State<WerewolfPhaseTwoScreen> createState() => _WerewolfPhaseTwoScreenState();
}

class _WerewolfPhaseTwoScreenState extends State<WerewolfPhaseTwoScreen> {
  final Set<String> _viewedPlayerIds = {};
  final WerewolfAllianceService _allianceService = WerewolfAllianceService();

  void _showRoleDialog(WerewolfPlayer player) {
    if (_viewedPlayerIds.contains(player.id)) return;

    final role = widget.playerRoles[player.id];
    if (role == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isRevealed = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF778DA9),
                  border: Border.all(color: const Color(0xFF415A77), width: 4),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B2A),
                    border: Border.all(color: Colors.black, width: 4),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isRevealed) ...[
                        Text(
                          'SECRET ROLE',
                          style: GoogleFonts.vt323(
                            color: Colors.white70,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Player Name removed from here

                      // Card Flip Section
                      Flexible(
                        child: GestureDetector(
                          onTap: () {
                            if (!isRevealed) {
                              setDialogState(() {
                                isRevealed = true;
                              });
                            }
                          },
                          child: AspectRatio(
                            // Even taller aspect ratio
                            aspectRatio: 0.65,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: isRevealed ? 180 : 0,
                              ),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutBack,
                              builder: (context, value, child) {
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
                                          child: _buildCardBack(
                                            role,
                                            player.name,
                                          ),
                                        )
                                      : _buildCardFront(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      if (isRevealed) ...[
                        const SizedBox(height: 16),
                        Center(
                          child: SizedBox(
                            width: 200,
                            child: PixelButton(
                              label: 'UNDERSTOOD',
                              color: const Color(0xFF415A77),
                              onPressed: () {
                                setState(() {
                                  _viewedPlayerIds.add(player.id);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardFront() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        border: Border.all(color: const Color(0xFF415A77), width: 4),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, color: Color(0xFFE63946), size: 64),
          const SizedBox(height: 16),
          Text(
            'TOP SECRET',
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'TAP TO REVEAL',
            style: GoogleFonts.vt323(color: Colors.white70, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showRoleDescriptionDialog(WerewolfRole role) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            border: Border.all(color: const Color(0xFF415A77), width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ROLE DETAILS',
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Text(
                    role.description,
                    style: GoogleFonts.vt323(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 20,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PixelButton(
                label: 'CLOSE',
                color: const Color(0xFFE63946),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBack(WerewolfRole role, String playerName) {
    final alliance = _allianceService.getAllianceById(role.allianceId);
    final allianceColor = _getAllianceColor(role.allianceId);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A), // Darker background
        border: Border.all(color: allianceColor, width: 4),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Cover (Takes all remaining space)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: allianceColor, width: 4),
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        role.imagePath,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      // Name Overlay
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black.withOpacity(0.6),
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            playerName.toUpperCase(),
                            style: GoogleFonts.vt323(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Minimal Content Footer
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                color: const Color(0xFF0D1B2A),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Text(
                      role.name.toUpperCase(),
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 16, // Slightly smaller to be compacted
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alliance?.name.toUpperCase() ?? '',
                      style: GoogleFonts.vt323(
                        color: allianceColor,
                        fontSize: 20, // Slightly smaller
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 2,
                      width: 60,
                      color: allianceColor.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Pixel Art Details Button
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => _showRoleDescriptionDialog(role),
              child: Container(
                width: 39,
                height: 39,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF415A77),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  '?',
                  style: GoogleFonts.vt323(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    final allViewed = _viewedPlayerIds.length == widget.players.length;

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
                        label: 'BACK',
                        color: const Color(0xFF415A77),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'ROLE DISCOVERY',
                          style: GoogleFonts.pressStart2p(
                            color: Colors.white,
                            fontSize: 18,
                            shadows: [
                              const Shadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),

                // Instructions
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8,
                  ),
                  child: Text(
                    'PASS THE PHONE TO THE PLAYERS TO REVEAL THEIR ROLES',
                    style: GoogleFonts.vt323(
                      color: Colors.white60,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Players Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.4,
                          ),
                      itemCount: widget.players.length,
                      itemBuilder: (context, index) {
                        final player = widget.players[index];
                        final isViewed = _viewedPlayerIds.contains(player.id);

                        return GestureDetector(
                          onTap: isViewed
                              ? null
                              : () => _showRoleDialog(player),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isViewed
                                  ? Colors.black.withOpacity(0.3)
                                  : const Color(0xFF1B263B).withOpacity(0.9),
                              border: Border.all(
                                color: isViewed
                                    ? Colors.grey.withOpacity(0.2)
                                    : const Color(0xFF415A77),
                                width: 3,
                              ),
                              boxShadow: isViewed
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.blueAccent.withOpacity(
                                          0.2,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isViewed
                                        ? Icons.check_circle
                                        : Icons.help_outline,
                                    color: isViewed
                                        ? Colors.greenAccent
                                        : Colors.white70,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    player.name,
                                    style: GoogleFonts.vt323(
                                      color: isViewed
                                          ? Colors.white38
                                          : Colors.white,
                                      fontSize: 24,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Proceed Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: allViewed ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: !allViewed,
                      child: SizedBox(
                        width: double.infinity,
                        child: PixelButton(
                          label: 'COMMENCE NIGHT',
                          color: const Color(0xFFE63946),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => WerewolfPhaseThreeScreen(
                                  playerRoles: widget.playerRoles,
                                  players: widget.players,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
