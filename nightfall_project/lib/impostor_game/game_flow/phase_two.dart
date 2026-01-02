import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/impostor_game/game_flow/phase_three.dart';
import 'package:nightfall_project/impostor_game/offline_db/category_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/player_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/words_service.dart';

class PhaseTwoScreen extends StatefulWidget {
  final List<Player> players;
  final Category category;
  final Word word;
  final String impostorId;

  const PhaseTwoScreen({
    super.key,
    required this.players,
    required this.category,
    required this.word,
    required this.impostorId,
  });

  @override
  State<PhaseTwoScreen> createState() => _PhaseTwoScreenState();
}

class _PhaseTwoScreenState extends State<PhaseTwoScreen> {
  bool _showInstructions = true;
  Player? _selectedSuspect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfield(),
          SafeArea(
            child: _showInstructions ? _buildInstructions() : _buildVoting(),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "DISCUSSION TIME",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xFFE63946),
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1B263B).withOpacity(0.9),
              border: Border.all(color: const Color(0xFF415A77), width: 4),
            ),
            child: Column(
              children: [
                _buildInstructionShot(
                  "1",
                  "Go around in a circle for 2 or 3 rounds.",
                ),
                const SizedBox(height: 24),
                _buildInstructionShot(
                  "2",
                  "Each player must say ONE WORD related to their secret.",
                ),
                const SizedBox(height: 24),
                _buildInstructionShot(
                  "3",
                  "After rounds are over, you must vote for the IMPOSTOR!",
                ),
              ],
            ),
          ),
          const SizedBox(height: 64),
          PixelButton(
            label: "START VOTING",
            color: const Color(0xFF52B788),
            onPressed: () {
              setState(() {
                _showInstructions = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionShot(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(color: Color(0xFFE0E1DD)),
          child: Center(
            child: Text(
              num,
              style: GoogleFonts.pressStart2p(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildVoting() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "WHO IS THE IMPOSTOR?",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xFFE0E1DD),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),

        // Drop Zone
        Center(
          child: DragTarget<Player>(
            onWillAccept: (data) => data != null,
            onAccept: (player) {
              setState(() {
                _selectedSuspect = player;
              });
            },
            builder: (context, candidateData, rejectedData) {
              final isHovering = candidateData.isNotEmpty;
              return Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  color: isHovering
                      ? Colors.red.withOpacity(0.2)
                      : Colors.black.withOpacity(0.5),
                  border: Border.all(
                    color: _selectedSuspect != null
                        ? const Color(0xFFE63946)
                        : Colors.white24,
                    width: 4,
                    style: _selectedSuspect != null
                        ? BorderStyle.solid
                        : BorderStyle.none,
                  ),
                ),
                child: Center(
                  child: _selectedSuspect == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.touch_app,
                              color: Colors.white24,
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "DRAG SUSPECT HERE",
                              style: GoogleFonts.vt323(
                                color: Colors.white24,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.gavel,
                              color: Color(0xFFE63946),
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _selectedSuspect!.name.toUpperCase(),
                              style: GoogleFonts.pressStart2p(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),

        // Players List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: widget.players.length,
            itemBuilder: (context, index) {
              final player = widget.players[index];
              final isSelected = _selectedSuspect?.id == player.id;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSuspect = player;
                    });
                  },
                  child: LongPressDraggable<Player>(
                    data: player,
                    feedback: Material(
                      color: Colors.transparent,
                      child: _buildPlayerCard(player, true),
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: _buildPlayerCard(player, false),
                    ),
                    child: _buildPlayerCard(
                      player,
                      false,
                      isSelected: isSelected,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Action Button
        if (_selectedSuspect != null)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PixelButton(
              label: "REVEAL IMPOSTOR",
              color: const Color(0xFFE63946),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PhaseThreeScreen(
                      votedPlayerId: _selectedSuspect!.id,
                      impostorId: widget.impostorId,
                      players: widget.players,
                      category: widget.category,
                      word: widget.word,
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
              "Drag a player to the box to vote",
              style: GoogleFonts.vt323(color: Colors.white54, fontSize: 20),
            ),
          ),
      ],
    );
  }

  Widget _buildPlayerCard(
    Player player,
    bool isFeedback, {
    bool isSelected = false,
  }) {
    return Container(
      width: isFeedback ? 250 : double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF3D0C02).withOpacity(0.9)
            : const Color(0xFF1B263B).withOpacity(0.9),
        border: Border.all(
          color: isSelected ? const Color(0xFFE63946) : const Color(0xFF415A77),
          width: 3,
        ),
      ),
      child: Center(
        child: Text(
          player.name,
          style: GoogleFonts.vt323(
            color: Colors.white,
            fontSize: 28,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
