import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'package:nightfall_project/werewolves_game/layouts/game_layout.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:nightfall_project/services/language_service.dart';

class WerewolfPhaseFiveScreen extends StatefulWidget {
  final Map<String, WerewolfRole> playerRoles;
  final List<WerewolfPlayer> players;
  final String winningTeam; // 'The Werewolves', 'The Village', 'The Jester'

  const WerewolfPhaseFiveScreen({
    super.key,
    required this.playerRoles,
    required this.players,
    required this.winningTeam,
  });

  @override
  State<WerewolfPhaseFiveScreen> createState() =>
      _WerewolfPhaseFiveScreenState();
}

class _WerewolfPhaseFiveScreenState extends State<WerewolfPhaseFiveScreen> {
  final WerewolfPlayerService _playerService = WerewolfPlayerService();
  String _typedTitle = "";
  Timer? _titleTimer;
  bool _showWinners = false;
  List<WerewolfPlayer> _appPlayersUpdated = [];
  late AudioPlayer _winPlayer;

  // Color scheme based on winner
  Color get _themeColor {
    final team = widget.winningTeam.toLowerCase();
    if (team.contains('werewolves')) return const Color(0xFFE63946); // Red
    if (team.contains('village')) return const Color(0xFF52B788); // Green
    if (team.contains('jester')) return const Color(0xFF9D4EDD); // Purple
    return Colors.white;
  }

  @override
  void initState() {
    super.initState();
    _winPlayer = AudioPlayer();
    _distributePoints();
    _startTypewriter();
    _playWinSound();
  }

  Future<void> _playWinSound() async {
    String soundPath = "";
    final team = widget.winningTeam.toLowerCase();
    if (team.contains('werewolves')) {
      soundPath = 'audio/werewolves/werewolf_win.mp3';
    } else if (team.contains('village')) {
      soundPath = 'audio/werewolves/village_win.mp3';
    } else if (team.contains('jester')) {
      soundPath = 'audio/werewolves/jester_win.mp3';
    }

    if (soundPath.isNotEmpty) {
      try {
        await _winPlayer.play(AssetSource(soundPath));
      } catch (e) {
        debugPrint('Error playing win sound: $e');
      }
    }
  }

  @override
  void dispose() {
    _titleTimer?.cancel();
    _winPlayer.stop();
    _winPlayer.dispose();
    super.dispose();
  }

  Future<void> _distributePoints() async {
    // 1. Determine Winning Alliance ID
    int winningAllianceId = -1;
    final team = widget.winningTeam.toLowerCase();
    if (team.contains('village')) winningAllianceId = 1;
    if (team.contains('werewolves')) winningAllianceId = 2;
    if (team.contains('jester')) winningAllianceId = 3;

    // 2. Load Current Players form DB (to get current points state)
    List<WerewolfPlayer> currentDbPlayers = await _playerService.loadPlayers();

    // 3. Update Points
    List<WerewolfPlayer> updatedList = currentDbPlayers.map((dbPlayer) {
      // Find role in this game session
      final role = widget.playerRoles[dbPlayer.id];
      if (role != null) {
        // Check if player's role belongs to winning alliance
        if (role.allianceId == winningAllianceId) {
          // Award points based on Role's point value
          return WerewolfPlayer(
            id: dbPlayer.id,
            name: dbPlayer.name,
            points: dbPlayer.points + role.points,
          );
        }
      }
      return dbPlayer;
    }).toList();

    // 4. Save to DB
    await _playerService.savePlayers(updatedList);

    if (mounted) {
      setState(() {
        _appPlayersUpdated = updatedList;
      });
    }
  }

  void _startTypewriter() {
    final languageService = context.read<LanguageService>();
    final teamName = languageService.translate(
      'winning_team_${widget.winningTeam}',
    );
    final fullText = languageService
        .translate('win_title')
        .replaceAll('{team}', teamName)
        .toUpperCase();
    int index = 0;

    _titleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (index < fullText.length) {
        setState(() {
          _typedTitle += fullText[index];
        });
        index++;
      } else {
        timer.cancel();
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _showWinners = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfield(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    context.watch<LanguageService>().translate(
                      'game_over_title',
                    ),
                    style: GoogleFonts.vt323(
                      color: Colors.white70,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Winner Card (Animated)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.elasticOut,
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _themeColor.withOpacity(0.1),
                      border: Border.all(color: _themeColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: _themeColor.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Colors.amber,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _typedTitle,
                          style: GoogleFonts.pressStart2p(
                            color: _themeColor,
                            fontSize: 20,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Winners List & Points
                  if (_showWinners && _appPlayersUpdated.isNotEmpty) ...[
                    Text(
                      context.watch<LanguageService>().translate(
                        'points_distributed_label',
                      ),
                      style: GoogleFonts.vt323(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._buildWinnersList(),
                  ],

                  const SizedBox(height: 60),

                  // Navigation
                  if (_showWinners)
                    SizedBox(
                      width: double.infinity,
                      child: PixelButton(
                        label: context.watch<LanguageService>().translate(
                          'back_to_menu',
                        ),
                        color: const Color(0xFF415A77),
                        onPressed: () async {
                          await _winPlayer.stop();
                          if (mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const WerewolfGameLayout(),
                              ),
                              (route) => route.isFirst,
                            );
                          }
                        },
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

  List<Widget> _buildWinnersList() {
    // Determine Winning Alliance ID again for filter
    int winningAllianceId = -1;
    final team = widget.winningTeam.toLowerCase();
    if (team.contains('village')) winningAllianceId = 1;
    if (team.contains('werewolves')) winningAllianceId = 2;
    if (team.contains('jester')) winningAllianceId = 3;

    List<Widget> list = [];

    // Iterate through ALL players who participated (from database), not just survivors
    for (var dbPlayer in _appPlayersUpdated) {
      final role = widget.playerRoles[dbPlayer.id];
      if (role != null && role.allianceId == winningAllianceId) {
        list.add(
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  dbPlayer.name,
                  style: GoogleFonts.vt323(color: Colors.white, fontSize: 20),
                ),
                const Spacer(),
                Text(
                  "+${role.points} PTS",
                  style: GoogleFonts.pressStart2p(
                    color: Colors.amber,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    if (list.isEmpty) {
      list.add(
        Text(
          context.watch<LanguageService>().translate('no_points_awarded_msg'),
          style: GoogleFonts.vt323(color: Colors.white54),
        ),
      );
    }

    return list;
  }
}
