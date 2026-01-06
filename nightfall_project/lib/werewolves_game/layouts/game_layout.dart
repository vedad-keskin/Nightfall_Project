import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/players_section/players_screen.dart';
import 'package:nightfall_project/werewolves_game/leaderboards/leaderboards_screen.dart';
import 'package:nightfall_project/werewolves_game/roles/roles_screen.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:provider/provider.dart';

class WerewolfGameLayout extends StatefulWidget {
  const WerewolfGameLayout({super.key});

  @override
  State<WerewolfGameLayout> createState() => _WerewolfGameLayoutState();
}

class _WerewolfGameLayoutState extends State<WerewolfGameLayout> {
  int _playerCount = 0;
  final WerewolfPlayerService _playerService = WerewolfPlayerService();

  @override
  void initState() {
    super.initState();
    _loadPlayerCount();
  }

  Future<void> _loadPlayerCount() async {
    final players = await _playerService.loadPlayers();
    if (mounted) {
      setState(() {
        _playerCount = players.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageService = context.watch<LanguageService>();
    return Scaffold(
      body: Stack(
        children: [
          // Background Layer (Shared Component)
          const PixelStarfield(),

          // Foreground Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      // Layer 1: Outer Shadow/Border
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(8, 8),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        // Layer 2: Metallic Frame
                        decoration: const BoxDecoration(
                          color: Color(0xFF778DA9),
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color: Color(0xFF415A77),
                              width: 6,
                            ),
                            horizontal: BorderSide(
                              color: Color(0xFFE0E1DD),
                              width: 6,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          // Layer 3: Inner Game Area
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF0D1B2A,
                            ).withOpacity(0.95), // Deep Dark Blue
                            border: Border.all(
                              color: Colors.black.withOpacity(0.8),
                              width: 4,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Inner Header Section
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    PixelButton(
                                      label: languageService.translate('back'),
                                      color: const Color(0xFF415A77),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          'WEREWOLF GAME',
                                          style: GoogleFonts.pressStart2p(
                                            color: const Color(0xFFE0E1DD),
                                            fontSize: 15,
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
                                    ),
                                  ],
                                ),
                              ),
                              // Pixel Divider
                              Container(
                                height: 4,
                                color: const Color(0xFF778DA9),
                                margin: const EdgeInsets.only(bottom: 16),
                              ),
                              // Main Game Content
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      // Player Count Section
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WerewolfPlayersScreen(),
                                            ),
                                          );
                                          _loadPlayerCount();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1B263B,
                                            ).withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xFF415A77),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languageService.translate(
                                                  'players_title',
                                                ),
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              Text(
                                                '$_playerCount',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white,
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Roles Section
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WerewolfRolesScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1B263B,
                                            ).withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xFF415A77),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'ROLES',
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.supervised_user_circle,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Leaderboards Section
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WerewolfLeaderboardsScreen(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF1B263B,
                                            ).withOpacity(0.8),
                                            border: Border.all(
                                              color: const Color(0xFF415A77),
                                              width: 3,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                languageService.translate(
                                                  'leaderboards_title',
                                                ),
                                                style: GoogleFonts.vt323(
                                                  color: Colors.white70,
                                                  fontSize: 28,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.leaderboard,
                                                color: Colors.white,
                                                size: 28,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "ADDITIONAL FEATURES\nCOMING SOON",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.pressStart2p(
                                          color: const Color(
                                            0xFFE0E1DD,
                                          ).withOpacity(0.3),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
