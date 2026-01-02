import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/impostor_game/offline_db/category_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/player_service.dart';
import 'package:nightfall_project/impostor_game/offline_db/words_service.dart';

class PhaseThreeScreen extends StatefulWidget {
  final String votedPlayerId;
  final String impostorId;
  final List<Player> players;
  final Category category;
  final Word word;

  const PhaseThreeScreen({
    super.key,
    required this.votedPlayerId,
    required this.impostorId,
    required this.players,
    required this.category,
    required this.word,
  });

  @override
  State<PhaseThreeScreen> createState() => _PhaseThreeScreenState();
}

class _PhaseThreeScreenState extends State<PhaseThreeScreen> {
  final PlayerService _playerService = PlayerService();
  bool _isRevealDone = false;
  late Player _votedPlayer;
  late Player _realImpostor;
  bool _impostorWon = false;

  @override
  void initState() {
    super.initState();
    _votedPlayer = widget.players.firstWhere(
      (p) => p.id == widget.votedPlayerId,
    );
    _realImpostor = widget.players.firstWhere((p) => p.id == widget.impostorId);
    _impostorWon = widget.votedPlayerId != widget.impostorId;

    // Logic: If impostor escaped, give them 1 point
    if (_impostorWon) {
      _applyPoints();
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isRevealDone = true;
        });
      }
    });
  }

  Future<void> _applyPoints() async {
    final players = await _playerService.loadPlayers();
    final updatedPlayers = players.map((p) {
      if (p.id == widget.impostorId) {
        return Player(id: p.id, name: p.name, points: p.points + 1);
      }
      return p;
    }).toList();
    await _playerService.savePlayers(updatedPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfield(),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "THE VERDICT",
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _buildVerdictCard(),
                    const SizedBox(height: 48),
                    if (_isRevealDone) ...[
                      _buildResultText(),
                      const SizedBox(height: 64),
                      PixelButton(
                        label: "BACK TO MENU",
                        color: const Color(0xFF415A77),
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).popUntil(ModalRoute.withName('/impostor_game'));
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerdictCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _isRevealDone
            ? (_impostorWon ? const Color(0xFF3D0C02) : const Color(0xFF1B4332))
            : const Color(0xFF1B263B),
        border: Border.all(
          color: _isRevealDone
              ? (_impostorWon
                    ? const Color(0xFFE63946)
                    : const Color(0xFF52B788))
              : const Color(0xFF415A77),
          width: 6,
        ),
      ),
      child: Column(
        children: [
          Text(
            "VOTED AS IMPOSTOR:",
            style: GoogleFonts.vt323(color: Colors.white70, fontSize: 24),
          ),
          const SizedBox(height: 8),
          Text(
            _votedPlayer.name.toUpperCase(),
            style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 24),
          if (_isRevealDone) ...[
            const Icon(Icons.arrow_downward, color: Colors.white54, size: 32),
            const SizedBox(height: 24),
            Text(
              _impostorWon ? "THEY WERE INNOCENT!" : "THEY WERE THE IMPOSTOR!",
              style: GoogleFonts.vt323(
                color: _impostorWon
                    ? const Color(0xFFFFBA08)
                    : Colors.greenAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ] else
            const CircularProgressIndicator(color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildResultText() {
    return Column(
      children: [
        if (_impostorWon) ...[
          Text(
            "THE IMPOSTOR ESCAPED!",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xFFE63946),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Real Impostor: ${_realImpostor.name}",
            style: GoogleFonts.vt323(color: Colors.white70, fontSize: 22),
          ),
          const SizedBox(height: 12),
          Text(
            "+1 POINT TO ${_realImpostor.name.toUpperCase()}",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xFFFFBA08),
              fontSize: 12,
            ),
          ),
        ] else ...[
          Text(
            "INNOCENTS WIN!",
            style: GoogleFonts.pressStart2p(
              color: const Color(0xFF52B788),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You caught the Impostor!",
            style: GoogleFonts.vt323(color: Colors.white70, fontSize: 22),
          ),
        ],
      ],
    );
  }
}
