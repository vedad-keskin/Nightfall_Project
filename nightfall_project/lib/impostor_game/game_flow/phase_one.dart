import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/impostor_game/game_flow/phase_two.dart';
import 'package:nightfall_project/impostor_game/offline_db/category_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/player_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/words_service.dart';

class PhaseOneScreen extends StatefulWidget {
  final List<Player> players;
  final Category category;
  final Word word;
  final String impostorId;
  final bool hintsEnabled;

  const PhaseOneScreen({
    super.key,
    required this.players,
    required this.category,
    required this.word,
    required this.impostorId,
    required this.hintsEnabled,
  });

  @override
  State<PhaseOneScreen> createState() => _PhaseOneScreenState();
}

class _PhaseOneScreenState extends State<PhaseOneScreen> {
  final Set<String> _viewedPlayerIds = {};

  void _showRoleDialog(Player player) {
    if (_viewedPlayerIds.contains(player.id)) return;

    final isImpostor = player.id == widget.impostorId;

    showDialog(
      context: context,
      barrierDismissible: true,
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1B2A),
                    border: Border.all(color: Colors.black, width: 4),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "SECRET ROLE",
                        style: GoogleFonts.vt323(
                          color: Colors.white70,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        player.name.toUpperCase(),
                        style: GoogleFonts.pressStart2p(
                          color: const Color(0xFFE0E1DD),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (!isRevealed) ...[
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              isRevealed = true;
                            });
                          },
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                              begin: 0,
                              end: isRevealed ? 1.57 : 0, // 0 → 90°
                            ),
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOutCubic,
                            builder: (context, value, child) {
                              final isBackVisible = value > 0.78; // ~45°

                              return Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(value),
                                child: isBackVisible
                                    ? _buildCardBack(isImpostor)
                                    : _buildCardFront(),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 1.57,
                            end: 0,
                          ), // 90 to 0 degrees
                          duration: const Duration(milliseconds: 800),
                          builder: (context, value, child) {
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(value),
                              alignment: Alignment.center,
                              child: _buildCardBack(isImpostor),
                            );
                          },
                        ),
                      ],
                      if (isRevealed) ...[
                        const SizedBox(height: 32),
                        PixelButton(
                          label: "UNDERSTOOD",
                          color: const Color(0xFF415A77),
                          onPressed: () {
                            setState(() {
                              _viewedPlayerIds.add(player.id);
                            });
                            Navigator.of(context).pop();
                          },
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Center(
                          child: Text(
                            'PASS THE DEVICE',
                            style: GoogleFonts.pressStart2p(
                              color: const Color(0xFFE0E1DD),
                              fontSize: 18, // Adjusted slightly for row
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
                    ],
                  ),
                ),

                // Players Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.5,
                          ),
                      itemCount: widget.players.length,
                      itemBuilder: (context, index) {
                        final player = widget.players[index];
                        final isViewed = _viewedPlayerIds.contains(player.id);

                        return GestureDetector(
                          onTap: isViewed
                              ? null
                              : () => _showRoleDialog(player),
                          child: Container(
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
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (isViewed)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.green,
                                      size: 32,
                                    )
                                  else
                                    const Icon(
                                      Icons.help_outline,
                                      color: Colors.white70,
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

                // Game Start Button
                if (allViewed)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: PixelButton(
                      label: "GAME START",
                      color: const Color(0xFFE63946),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PhaseTwoScreen(
                              players: widget.players,
                              category: widget.category,
                              word: widget.word,
                              impostorId: widget.impostorId,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      "Waiting for all players...",
                      style: GoogleFonts.vt323(
                        color: Colors.white54,
                        fontSize: 20,
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

  Widget _buildCardFront() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        border: Border.all(color: const Color(0xFF415A77), width: 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.security, color: Color(0xFFE63946), size: 64),
          const SizedBox(height: 16),
          Text(
            "TOP SECRET",
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "TAP TO FLIP",
            style: GoogleFonts.vt323(color: Colors.white70, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(bool isImpostor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B263B),
        border: Border.all(
          color: isImpostor ? const Color(0xFFE63946) : const Color(0xFF4CC9F0),
          width: 4,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isImpostor) ...[
            Text(
              "YOU ARE THE",
              style: GoogleFonts.vt323(color: Colors.white70, fontSize: 24),
            ),
            Text(
              "IMPOSTOR",
              style: GoogleFonts.pressStart2p(
                color: const Color(0xFFE63946), // Red
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "CATEGORY:",
              style: GoogleFonts.vt323(color: Colors.white54, fontSize: 20),
            ),
            Text(
              widget.category.name,
              style: GoogleFonts.vt323(color: Colors.white, fontSize: 28),
            ),
            if (widget.hintsEnabled) ...[
              const SizedBox(height: 16),
              Text(
                "HINT:",
                style: GoogleFonts.vt323(color: Colors.white54, fontSize: 20),
              ),
              Text(
                widget.word.hint,
                style: GoogleFonts.vt323(
                  color: const Color(0xFF95D5B2),
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ] else ...[
            Text(
              "THE WORD IS:",
              style: GoogleFonts.vt323(color: Colors.white70, fontSize: 24),
            ),
            const SizedBox(height: 12),
            Text(
              widget.word.name,
              style: GoogleFonts.pressStart2p(
                color: const Color(0xFF4CC9F0), // Blue
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "CATEGORY:",
              style: GoogleFonts.vt323(color: Colors.white54, fontSize: 20),
            ),
            Text(
              widget.category.name,
              style: GoogleFonts.vt323(color: Colors.white, fontSize: 28),
            ),
          ],
        ],
      ),
    );
  }
}
