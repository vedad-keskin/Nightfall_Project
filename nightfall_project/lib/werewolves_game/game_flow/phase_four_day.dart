import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/timer_settings_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'phase_five.dart';
import 'phase_three_night.dart';

class WerewolfPhaseFourScreen extends StatefulWidget {
  final Map<String, WerewolfRole> playerRoles;
  final List<WerewolfPlayer> players;
  final List<String> deadPlayerIds; // IDs of players who are dead

  // History state passed specifically to maintain game state if we loop back to night
  final String? lastHealedId;
  final String? lastPlagueTargetId;

  const WerewolfPhaseFourScreen({
    super.key,
    required this.playerRoles,
    required this.players,
    required this.deadPlayerIds,
    this.lastHealedId,
    this.lastPlagueTargetId,
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
      case 'twoMinutes':
        duration = 120;
        break;
      case 'fiveMinutes':
        duration = 300;
        break;
      case 'tenMinutes':
        duration = 600;
        break;
      case 'thirtySecondsPerPlayer':
        // Calculate based on alive players or total players?
        // Usually based on current survivors for dynamic pacing, or total for consistency.
        // User said "30sec per player". Let's use current alive players (widget.players in phase 4 is survivors? No, wait)
        // Earlier I discovered phase 4 receives filtered players list from phase 3?
        // Phase 3 passes `players: widget.players` which is alive players.
        // So widget.players.length is the count of alive players.
        duration = 30 * widget.players.length;
        // Ensure at least some minimum time? e.g. 60s
        if (duration < 60) duration = 60;
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
      case 9: // Jester
        return const Color(0xFF9D4EDD); // Purple
      default:
        return Colors.white; // Villager etc.
    }
  }

  void _handleVote() {
    // 1. Jester Check (Specific Win Condition)
    if (_selectedForHangingId != null) {
      final role = widget.playerRoles[_selectedForHangingId];
      if (role?.id == 9) {
        // Jester Wins immediately if hanged
        _navigateToGameEnd("The Jester");
        return;
      }
    }

    // 2. Update Dead List
    List<String> nextDeadIds = List.from(widget.deadPlayerIds);

    if (_selectedForHangingId != null) {
      nextDeadIds.add(_selectedForHangingId!);
    }

    // 3. Twin Transformation Logic
    Map<String, WerewolfRole> updatedRoles = Map.from(widget.playerRoles);
    if (_selectedForHangingId != null) {
      final hangedRole = widget.playerRoles[_selectedForHangingId];
      if (hangedRole?.id == 6) {
        // Twin was hanged - find the other twin and transform them
        for (final player in widget.players) {
          if (player.id != _selectedForHangingId &&
              !nextDeadIds.contains(player.id)) {
            final playerRole = widget.playerRoles[player.id];
            if (playerRole?.id == 6) {
              // Found the other twin - transform to Avenging Twin
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
      _navigateToGameEnd("The Village");
    } else if (aliveWerewolves >= aliveVillagers) {
      // Werewolves Win (including after Twin transformation)
      _navigateToGameEnd("The Werewolves");
    } else {
      // Game Continues -> Night Phase (pass updated roles)
      _navigateToNextNight(nextDeadIds, updatedRoles);
    }
  }

  void _navigateToGameEnd(String winningTeam) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WerewolfPhaseFiveScreen(
          playerRoles: widget.playerRoles,
          players: widget.players,
          winningTeam: winningTeam,
        ),
      ),
    );
  }

  void _navigateToNextNight(
    List<String> nextDeadIds,
    Map<String, WerewolfRole> updatedRoles,
  ) {
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
        ),
      ),
    );
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
          const PixelStarfield(),
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
                        "DAY PHASE",
                        style: GoogleFonts.pressStart2p(
                          color: const Color(0xFFFCA311),
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "DISCUSS & VOTE",
                        style: GoogleFonts.vt323(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
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
                                ? const Color(0xFFE63946).withOpacity(
                                    0.4,
                                  ) // Red selection
                                : const Color(0xFF1B263B), // Dark card bg
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE63946)
                                  : const Color(0xFF415A77),
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Image Top (Expanded)
                              Expanded(
                                child: role != null
                                    ? SizedBox.expand(
                                        child: Image.asset(
                                          role.imagePath,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 40,
                                        ),
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
                                        role.name.toUpperCase(),
                                        style: GoogleFonts.pressStart2p(
                                          color: _getRoleColor(role.id),
                                          fontSize: 8,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    if (isSelected)
                                      Text(
                                        "HANG",
                                        style: GoogleFonts.pressStart2p(
                                          color: Colors.redAccent,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
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
                          label: "SKIP",
                          color: const Color(0xFF415A77),
                          onPressed: () {
                            _selectedForHangingId = null;
                            _handleVote();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PixelButton(
                          label: _selectedForHangingId == null
                              ? "SELECT PLAYER"
                              : "HANG",
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
