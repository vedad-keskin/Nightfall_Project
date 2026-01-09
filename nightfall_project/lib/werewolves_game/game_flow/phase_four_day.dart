import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:nightfall_project/base_components/pixel_starfield_background.dart';
import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/base_components/pixel_heart.dart';
import 'package:nightfall_project/werewolves_game/offline_db/timer_settings_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'phase_five.dart';
import 'phase_three_night.dart';
import 'package:provider/provider.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nightfall_project/services/sound_settings_service.dart';
import 'package:nightfall_project/base_components/puppet_master_transformation.dart';

class WerewolfPhaseFourScreen extends StatefulWidget {
  final Map<String, WerewolfRole> playerRoles;
  final List<WerewolfPlayer> players;
  final List<String> deadPlayerIds; // IDs of players who are dead

  // History state passed specifically to maintain game state if we loop back to night
  final String? lastHealedId;
  final String? lastPlagueTargetId;
  final Map<String, int>? knightLives;

  const WerewolfPhaseFourScreen({
    super.key,
    required this.playerRoles,
    required this.players,
    required this.deadPlayerIds,
    this.lastHealedId,
    this.lastPlagueTargetId,
    this.knightLives,
  });

  @override
  State<WerewolfPhaseFourScreen> createState() =>
      _WerewolfPhaseFourScreenState();
}

class _WerewolfPhaseFourScreenState extends State<WerewolfPhaseFourScreen> {
  String? _selectedForHangingId;
  int _secondsRemaining = 300; // 5 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadTimerDuration();
  }

  Future<void> _loadTimerDuration() async {
    final timerService = TimerSettingsService();
    final modeString = await timerService.getTimerMode();
    int duration = 300; // Default 5 minutes

    switch (modeString) {
      case 'fiveMinutes':
        duration = 300;
        break;
      case 'tenMinutes':
        duration = 600;
        break;
      case 'thirtySecondsPerPlayer':
        duration = 30 * widget.players.length;
        if (duration < 60) duration = 60;
        break;
      case 'infinity':
        duration = -1;
        break;
    }

    if (mounted) {
      setState(() {
        _secondsRemaining = duration;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    if (_secondsRemaining == -1) return; // Infinity mode
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    if (_secondsRemaining == -1) return '∞';
    final minutes = (_secondsRemaining / 60).floor();
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getRoleColor(int roleId) {
    switch (roleId) {
      case 2: // Werewolf
      case 7: // Avenging Twin
      case 8: // Vampire
        return const Color(0xFFE63946); // Red
      case 6: // Twins
        return const Color(0xFF4CC9F0); // Blue
      case 3: // Doctor
        return Colors.green; // Classic Green
      case 5: // Plague Doctor
        return const Color(0xFF06D6A0); // Toxic/Emerald Green
      case 4: // Guard
        return const Color(0xFFFFD166); // Yellow
      case 10: // Drunk
        return const Color(0xFFCD9777); // Brown/Beer
      case 11: // Knight
        return const Color(0xFF9E2A2B); // Dark Red
      case 9: // Jester
        return const Color(0xFF9D4EDD); // Purple
      case 12: // Puppet Master
        return const Color(0xFF7209B7); // Indigo/Deep Purple
      default:
        return Colors.white; // Villager etc.
    }
  }

  void _handleVote() async {
    // 1. Jester Check (Specific Win Condition)
    if (_selectedForHangingId != null) {
      final role = widget.playerRoles[_selectedForHangingId];
      if (role?.id == 9) {
        // Jester Wins immediately if hanged
        _navigateToGameEnd("jester", widget.playerRoles);
        return;
      }
    }

    // 2. Update Dead List
    List<String> nextDeadIds = List.from(widget.deadPlayerIds);
    if (_selectedForHangingId != null) {
      nextDeadIds.add(_selectedForHangingId!);
    }

    // 3. Transformation Logic (Puppet Master & Twins)
    Map<String, WerewolfRole> updatedRoles = Map.from(widget.playerRoles);
    Map<String, int> updatedKnightLives = Map.from(widget.knightLives ?? {});

    if (_selectedForHangingId != null) {
      final hangedRole = widget.playerRoles[_selectedForHangingId];

      // Puppet Master Transformation
      String? puppetMasterId;
      for (final player in widget.players) {
        if (!nextDeadIds.contains(player.id) &&
            widget.playerRoles[player.id]?.id == 12) {
          puppetMasterId = player.id;
          break;
        }
      }

      if (puppetMasterId != null && hangedRole != null) {
        // Show transformation screen
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PuppetMasterTransformationDialog(
            playerName: widget.players
                .firstWhere((p) => p.id == puppetMasterId)
                .name,
            targetRole: hangedRole,
          ),
        );
        updatedRoles[puppetMasterId] = hangedRole;
        if (hangedRole.id == 11) {
          updatedKnightLives[puppetMasterId] = 2;
        }
      }

      // Twin Transformation
      if (hangedRole?.id == 6) {
        for (final player in widget.players) {
          if (player.id != _selectedForHangingId &&
              !nextDeadIds.contains(player.id)) {
            final playerRole = widget.playerRoles[player.id];
            if (playerRole?.id == 6) {
              final avengingTwinRole = WerewolfRoleService().getRoleById(7);
              if (avengingTwinRole != null) {
                updatedRoles[player.id] = avengingTwinRole;
              }
              break;
            }
          }
        }
      }
    }

    // 4. Check Win Conditions (using updated roles)
    int aliveWerewolves = 0;
    int aliveVillagers = 0;

    for (final player in widget.players) {
      if (!nextDeadIds.contains(player.id)) {
        final role = updatedRoles[player.id];
        if (role != null) {
          // Werewolf Alliance (2, 7, 8) count as "Bad"
          if (role.id == 2 || role.id == 7 || role.id == 8) {
            aliveWerewolves++;
          } else {
            // Everyone else counts as Village/Good for now
            aliveVillagers++;
          }
        }
      }
    }

    if (aliveWerewolves == 0) {
      // Village Wins
      _navigateToGameEnd("village", updatedRoles);
    } else if (aliveWerewolves >= aliveVillagers) {
      // Werewolves Win (including after Twin transformation)
      _navigateToGameEnd("werewolves", updatedRoles);
    } else if (aliveWerewolves == aliveVillagers - 1) {
      // 5. Advanced Win Condition Check (Inevitable Werewolf Victory)
      // If werewolves are 1 kill away from winning, and no one can prevent a kill tonight,
      // then their victory is already guaranteed.
      bool canPreventCasualty = false;
      for (final player in widget.players) {
        if (!nextDeadIds.contains(player.id)) {
          final role = updatedRoles[player.id];
          if (role != null) {
            // Doctor (3) or Plague Doctor (5) can save someone
            if (role.id == 3 || role.id == 5) {
              canPreventCasualty = true;
              break;
            }
            // Knight with 2 lives (11) can survive a hit
            if (role.id == 11 && (updatedKnightLives[player.id] ?? 0) >= 2) {
              canPreventCasualty = true;
              break;
            }
          }
        }
      }

      if (!canPreventCasualty) {
        // No way to stop a kill tonight. Werewolves will inevitably reach parity or majority.
        _navigateToGameEnd("werewolves", updatedRoles);
      } else {
        // Possible to block the kill - Game Continues to Night
        _navigateToNextNight(nextDeadIds, updatedRoles, updatedKnightLives);
      }
    } else {
      // Game Continues -> Night Phase
      _navigateToNextNight(nextDeadIds, updatedRoles, updatedKnightLives);
    }
  }

  void _navigateToGameEnd(
    String winningTeam,
    Map<String, WerewolfRole> playerRoles,
  ) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WerewolfPhaseFiveScreen(
          playerRoles: playerRoles,
          players: widget.players,
          winningTeam: winningTeam,
        ),
      ),
    );
  }

  void _navigateToNextNight(
    List<String> nextDeadIds,
    Map<String, WerewolfRole> updatedRoles,
    Map<String, int> updatedKnightLives,
  ) async {
    // Play night transition sound if not muted
    final isMuted = context.read<SoundSettingsService>().isMuted;

    if (!isMuted) {
      final player = AudioPlayer();
      try {
        await player.play(AssetSource('audio/werewolves/owl_howl_night.mp3'));
      } catch (e) {
        debugPrint('Error playing night sound: $e');
      }
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WerewolfPhaseThreeScreen(
            playerRoles: updatedRoles,
            // We pass ONLY the alive players to the next night phase?
            // Phase 3 expects a list of players. If we filter it, dead players are gone from the UI.
            // This matches the "Moderator View" requirement where they only see relevant info.
            players: widget.players
                .where((p) => !nextDeadIds.contains(p.id))
                .toList(),
            lastHealedId: widget.lastHealedId,
            lastPlagueTargetId: widget.lastPlagueTargetId,
            knightLives: updatedKnightLives,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter Alive Players for Display
    final alivePlayers = widget.players
        .where((p) => !widget.deadPlayerIds.contains(p.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfieldBackground(),
          SafeArea(
            child: Column(
              children: [
                // Header - Full Width Match
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFFCA311,
                    ).withOpacity(0.2), // Day/Sun Color
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFFFCA311), width: 2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        context.watch<LanguageService>().translate(
                          'day_phase_title',
                        ),
                        style: GoogleFonts.pressStart2p(
                          color: const Color(0xFFFCA311),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.watch<LanguageService>().translate(
                          'discuss_and_vote_instruction',
                        ),
                        style: GoogleFonts.vt323(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xFFFCA311).withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.watch<LanguageService>().translate(
                                'votes_needed_label',
                              ),
                              style: GoogleFonts.pressStart2p(
                                color: Colors.white70,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(alivePlayers.length / 2).floor() + 1}',
                              style: GoogleFonts.pressStart2p(
                                color: const Color(0xFFFCA311),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content - Alive Players Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: alivePlayers.length,
                    itemBuilder: (context, index) {
                      final player = alivePlayers[index];
                      final role = widget.playerRoles[player.id];
                      final isSelected = _selectedForHangingId == player.id;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedForHangingId = null;
                            } else {
                              _selectedForHangingId = player.id;
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFE63946).withOpacity(0.4)
                                : const Color(0xFF1B263B),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE63946)
                                  : const Color(0xFF415A77),
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFE63946,
                                      ).withOpacity(0.6),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            children: [
                              // Image Top (Expanded)
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: role != null
                                          ? Image.asset(
                                              role.imagePath,
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            )
                                          : const Center(
                                              child: Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            ),
                                    ),
                                    if (role?.id == 11)
                                      Positioned(
                                        top: 4,
                                        left: 4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.2,
                                              ),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              PixelHeart(
                                                isFull:
                                                    (widget.knightLives?[player
                                                            .id] ??
                                                        0) >=
                                                    1,
                                                size: 13,
                                              ),
                                              const SizedBox(width: 4),
                                              PixelHeart(
                                                isFull:
                                                    (widget.knightLives?[player
                                                            .id] ??
                                                        0) >=
                                                    2,
                                                size: 13,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    // Hanging Noose Icon Overlay
                                    if (isSelected)
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: TweenAnimationBuilder<double>(
                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          curve: Curves.elasticOut,
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: value,
                                              child: Opacity(
                                                opacity: value.clamp(0.0, 1.0),
                                                child: child,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.6,
                                              ),
                                              border: Border.all(
                                                color: const Color(
                                                  0xFFE63946,
                                                ).withOpacity(0.4),
                                                width: 1,
                                              ),
                                            ),
                                            child: Image.asset(
                                              'assets/images/hanging_noose.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Footer Text
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                color: Colors.black87,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      player.name,
                                      style: GoogleFonts.vt323(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (role != null)
                                      Text(
                                        context
                                            .watch<LanguageService>()
                                            .translate(role.translationKey)
                                            .toUpperCase(),
                                        style: GoogleFonts.pressStart2p(
                                          color: _getRoleColor(role.id),
                                          fontSize: 8,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Text(
                                  context.watch<LanguageService>().translate(
                                    'hang_button',
                                  ),
                                  style: GoogleFonts.pressStart2p(
                                    color: Colors.redAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Footer (Timer & Action) - Redesigned
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B),
                    border: const Border(
                      top: BorderSide(color: Color(0xFF415A77), width: 2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Timer Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          border: Border.all(
                            color: _secondsRemaining < 60
                                ? Colors.redAccent
                                : const Color(0xFF06D6A0),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          _formattedTime,
                          style: GoogleFonts.vt323(
                            color: _secondsRemaining < 60
                                ? Colors.redAccent
                                : Colors.greenAccent,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Buttons
                      Expanded(
                        child: PixelButton(
                          label: context.watch<LanguageService>().translate(
                            'skip_button',
                          ),
                          color: const Color(0xFF415A77),
                          onPressed: () {
                            _selectedForHangingId = null;
                            _handleVote();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        // flex: 2,
                        child: PixelButton(
                          label: _selectedForHangingId == null
                              ? context.watch<LanguageService>().translate(
                                  'select_button',
                                )
                              : context.watch<LanguageService>().translate(
                                  'hang_button',
                                ),
                          color: _selectedForHangingId == null
                              ? Colors.grey
                              : const Color(0xFFE63946),
                          onPressed: _selectedForHangingId == null
                              ? null
                              : _handleVote,
                        ),
                      ),
                    ],
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
