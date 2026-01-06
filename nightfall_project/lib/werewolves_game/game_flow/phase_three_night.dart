import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_components.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';
import 'phase_four_day.dart';
import 'dart:math';

class WerewolfPhaseThreeScreen extends StatefulWidget {
  final Map<String, WerewolfRole> playerRoles;
  final List<WerewolfPlayer> players;

  // History state passed from previous nights
  final String? lastHealedId;
  final String? lastPlagueTargetId;

  const WerewolfPhaseThreeScreen({
    super.key,
    required this.playerRoles,
    required this.players,
    this.lastHealedId,
    this.lastPlagueTargetId,
  });

  @override
  State<WerewolfPhaseThreeScreen> createState() =>
      _WerewolfPhaseThreeScreenState();
}

enum NightStep {
  werewolves, // Includes Vampire
  doctor,
  guard,
  plagueDoctor,
}

class _WerewolfPhaseThreeScreenState extends State<WerewolfPhaseThreeScreen> {
  late List<NightStep> _nightSteps;
  int _currentStepIndex = 0;

  // Night State
  String? _targetKilledId;
  String? _targetHealedId;

  @override
  void initState() {
    super.initState();
    _calculateNightSteps();
  }

  void _calculateNightSteps() {
    _nightSteps = [];

    // Get role IDs only from alive players
    final alivePlayerIds = widget.players.map((p) => p.id).toSet();
    final aliveRoles = widget.playerRoles.entries
        .where((entry) => alivePlayerIds.contains(entry.key))
        .map((entry) => entry.value.id)
        .toSet();

    // 1. Werewolves/Vampire/Avenging Twin always wake up (unless all dead, but game usually ends then)
    if (aliveRoles.contains(2) ||
        aliveRoles.contains(7) ||
        aliveRoles.contains(8)) {
      _nightSteps.add(NightStep.werewolves);
    }

    // 2. Doctor (only if alive)
    if (aliveRoles.contains(3)) {
      _nightSteps.add(NightStep.doctor);
    }

    // 3. Guard (only if alive)
    if (aliveRoles.contains(4)) {
      _nightSteps.add(NightStep.guard);
    }

    // 4. Plague Doctor (only if alive)
    if (aliveRoles.contains(5)) {
      _nightSteps.add(NightStep.plagueDoctor);
    }

    // Safety check if no steps (shouldn't happen in standard setup)
    if (_nightSteps.isEmpty) {
      // Auto proceed?
    }
  }

  NightStep get _currentStep => _nightSteps[_currentStepIndex];

  String get _stepTitle {
    switch (_currentStep) {
      case NightStep.werewolves:
        return 'WEREWOLVES & VAMPIRE';
      case NightStep.doctor:
        return 'THE DOCTOR';
      case NightStep.guard:
        return 'THE GUARD';
      case NightStep.plagueDoctor:
        return 'PLAGUE DOCTOR';
    }
  }

  String get _stepInstruction {
    switch (_currentStep) {
      case NightStep.werewolves:
        return 'SELECT A TARGET to ELIMINATE';
      case NightStep.doctor:
        return 'SELECT A TARGET to HEAL';
      case NightStep.guard:
        return 'SELECT A TARGET to INSPECT';
      case NightStep.plagueDoctor:
        return 'SELECT A TARGET (RISKY HEAL)';
    }
  }

  Color get _stepColor {
    switch (_currentStep) {
      case NightStep.werewolves:
        return const Color(0xFFE63946); // Red
      case NightStep.doctor:
        return const Color(0xFF4CC9F0); // Blue
      case NightStep.guard:
        return const Color(0xFFFFD166); // Yellow (Shieldy)
      case NightStep.plagueDoctor:
        return const Color(0xFF06D6A0); // Greenish/Toxic
    }
  }

  void _handlePlayerTap(WerewolfPlayer player) {
    if (_currentStepIndex >= _nightSteps.length) return;

    final targetRole = widget.playerRoles[player.id];
    if (targetRole == null) return; // Should not happen

    setState(() {
      switch (_currentStep) {
        case NightStep.werewolves:
          // Restriction: Cannot kill Werewolf Alliance
          if (targetRole.allianceId == 2) {
            // Show feedback? For now just ignore tap
            return;
          }

          // Toggle selection. Only one can be selected.
          if (_targetKilledId == player.id) {
            _targetKilledId = null;
          } else {
            _targetKilledId = player.id;
          }
          break;

        case NightStep.doctor:
          // Restriction: Cannot heal same person twice in a row
          if (player.id == widget.lastHealedId) {
            return;
          }

          if (_targetHealedId == player.id) {
            _targetHealedId = null;
          } else {
            _targetHealedId = player.id;
          }
          break;

        case NightStep.guard:
          // Restriction: Cannot inspect self (if target is Guard role)
          if (targetRole.id == 4) {
            // ID 4 is Guard
            return;
          }

          // Instant check logic
          _performGuardCheck(player);
          break;

        case NightStep.plagueDoctor:
          // Restriction: Cannot heal same person twice in a row
          if (player.id == widget.lastPlagueTargetId) {
            return;
          }

          if (_targetHealedId == player.id) {
            _targetHealedId = null;
          } else {
            _targetHealedId = player.id;
          }
          break;
      }
    });
  }

  Future<void> _performGuardCheck(WerewolfPlayer player) async {
    final role = widget.playerRoles[player.id];
    bool isWerewolf = false;

    // Check Logic: Werewolf (2) or Avenging Twin (7) -> "W"
    // Everyone else (including Vampire 8, Jester 9) -> "V"
    if (role != null) {
      if (role.id == 2 || role.id == 7) {
        isWerewolf = true;
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: false, // Force them to press Close
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: _stepColor, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.name.toUpperCase(),
                style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 16),
              Text(
                isWerewolf ? 'W' : 'V',
                style: GoogleFonts.pressStart2p(
                  color: isWerewolf ? Colors.red : Colors.green,
                  fontSize: 120, // Massive letter
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              PixelButton(
                label: 'CLOSE',
                color: const Color(0xFF415A77),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );

    // Auto-advance after check
    _nextStep();
  }

  // Specific state for distinct roles
  String? _doctorHealedId;
  String? _plagueDoctorTargetId;

  void _nextStep() {
    if (_currentStepIndex < _nightSteps.length - 1) {
      // Force selection logic could go here, but for now we allow skipping (e.g., if no one is selected)

      setState(() {
        _currentStepIndex++;
        // Reset transient selection state between steps
        // Capture Doctor's choice before resetting if moving away from Doctor
        if (_currentStep == NightStep.plagueDoctor ||
            _currentStep == NightStep.doctor) {
          // Logic handles this below by checking previous step?
          // No, _currentStep updates AFTER index increment.
          // We need to capture BEFORE increment or use the previous step index.
          // Easier: Capture based on the step we just finished.
        }
      });

      // Post-transition cleanup
      // If we just finished Doctor, store the ID and clear for next healer
      // Note: _nightSteps[_currentStepIndex - 1] is the one we just finished.
      final finishedStep = _nightSteps[_currentStepIndex - 1];
      if (finishedStep == NightStep.doctor) {
        _doctorHealedId = _targetHealedId;
        _targetHealedId = null;
      }
      if (finishedStep == NightStep.plagueDoctor) {
        _plagueDoctorTargetId = _targetHealedId;
        _targetHealedId = null;
      }
    } else {
      // End of Night - Capture last step's action
      if (_currentStep == NightStep.plagueDoctor) {
        _plagueDoctorTargetId = _targetHealedId;
      } else if (_currentStep == NightStep.doctor) {
        _doctorHealedId = _targetHealedId;
      }

      _calculateResults();
    }
  }

  void _calculateResults() {
    List<String> deadPlayerIds = [];
    List<String> messages = [];

    // 1. Resolve Werewolf Kill
    if (_targetKilledId != null) {
      bool isSaved = false;
      String? killedName = widget.players
          .firstWhere((p) => p.id == _targetKilledId)
          .name;

      // Saved by Doctor?
      if (_doctorHealedId == _targetKilledId) {
        isSaved = true;
        messages.add("The Doctor saved $killedName!");
      }

      // Saved by Plague Doctor? (67% chance)
      if (_plagueDoctorTargetId == _targetKilledId) {
        final rng = Random();
        if (rng.nextInt(3) != 0) {
          // 2/3 chance to HEAL
          isSaved = true;
          messages.add(
            "The Plague Doctor treated $killedName... and they survived!",
          );
        } else {
          messages.add(
            "The Plague Doctor tried to help $killedName... but failed.",
          );
        }
      }

      if (!isSaved) {
        deadPlayerIds.add(_targetKilledId!);
      }
    }

    // 2. Resolve Plague Doctor Accidental Kill on NON-Werewolf Targets
    if (_plagueDoctorTargetId != null &&
        _plagueDoctorTargetId != _targetKilledId) {
      final rng = Random();
      if (rng.nextInt(3) == 0) {
        // 1/3 chance to kill
        if (!deadPlayerIds.contains(_plagueDoctorTargetId)) {
          deadPlayerIds.add(_plagueDoctorTargetId!);
          final victimName = widget.players
              .firstWhere((p) => p.id == _plagueDoctorTargetId)
              .name;
          messages.add(
            "The Plague Doctor's 'treatment' was fatal to $victimName.",
          );
        }
      }
    }

    // Show Results
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF415A77), width: 4),
          borderRadius: BorderRadius.circular(0),
        ),
        title: Text(
          'DAWN BREAKS',
          style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (deadPlayerIds.isEmpty)
              Text(
                "It was a peaceful night.\nNo one died.",
                style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
              )
            else
              Column(
                children: [
                  Text(
                    "Tragedy has struck!",
                    style: GoogleFonts.vt323(
                      color: Colors.redAccent,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...deadPlayerIds.map((id) {
                    final p = widget.players.firstWhere(
                      (element) => element.id == id,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "${p.name.toUpperCase()} IS DEAD",
                        style: GoogleFonts.pressStart2p(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }),
                ],
              ),
            if (messages.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 10),
              ...messages.map(
                (m) => Text(
                  m,
                  style: GoogleFonts.vt323(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 200,
              child: PixelButton(
                label: 'Start Day', // Capitalized to match button style
                color: Colors.orange,
                onPressed: () {
                  Navigator.of(context).pop(); // Close Dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => WerewolfPhaseFourScreen(
                        playerRoles: widget.playerRoles,
                        players: widget.players,
                        deadPlayerIds: deadPlayerIds,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllianceSection(
    String title,
    Color color,
    List<WerewolfPlayer> sectionPlayers,
  ) {
    if (sectionPlayers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(width: 4, height: 24, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.vt323(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(height: 1, color: color.withOpacity(0.3)),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: sectionPlayers.length,
          itemBuilder: (context, index) {
            final player = sectionPlayers[index];
            final role = widget.playerRoles[player.id];

            // Determine visual state based on current step selection
            bool isSelected = false;
            bool isDisabled = false;

            if (_currentStep == NightStep.werewolves) {
              if (_targetKilledId == player.id) isSelected = true;
              // Disable Werewolf Alliance from being targeted by Werewolves
              if (role?.allianceId == 2) isDisabled = true;
            }

            if (_currentStep == NightStep.doctor) {
              if (_targetHealedId == player.id) isSelected = true;
              // Disable last healed
              if (player.id == widget.lastHealedId) isDisabled = true;
            }

            if (_currentStep == NightStep.plagueDoctor) {
              if (_targetHealedId == player.id) isSelected = true;
              if (player.id == widget.lastPlagueTargetId) isDisabled = true;
            }

            if (_currentStep == NightStep.guard) {
              // Disable Self
              if (role?.id == 4) isDisabled = true;
            }

            return GestureDetector(
              onTap: isDisabled ? null : () => _handlePlayerTap(player),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isDisabled
                      ? Colors.grey.withOpacity(0.1)
                      : isSelected
                      ? _stepColor.withOpacity(0.4)
                      : const Color(0xFF1B263B),
                  border: Border.all(
                    color: isDisabled
                        ? Colors.grey.withOpacity(0.2)
                        : isSelected
                        ? _stepColor
                        : const Color(0xFF415A77),
                    width: isSelected ? 3 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: isDisabled
                          ? const Center(
                              child: Icon(
                                Icons.block,
                                color: Colors.grey,
                                size: 32,
                              ),
                            )
                          : role != null
                          ? SizedBox.expand(
                              child: Image.asset(
                                role.imagePath,
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white60,
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      color: Colors
                          .black87, // Darker background for better contrast
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            player.name,
                            style: GoogleFonts.vt323(
                              color: isDisabled ? Colors.white24 : Colors.white,
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
                                color: isDisabled
                                    ? Colors.white12
                                    : _getRoleColor(role.id),
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
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const PixelStarfield(),
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _stepColor.withOpacity(0.2),
                    border: Border(
                      bottom: BorderSide(color: _stepColor, width: 2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _stepTitle,
                        style: GoogleFonts.pressStart2p(
                          color: _stepColor,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _stepInstruction,
                        style: GoogleFonts.vt323(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Player Sections
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildAllianceSection(
                        'THE PACK',
                        const Color(0xFFE63946),
                        widget.players.where((p) {
                          final role = widget.playerRoles[p.id];
                          return role?.allianceId == 2;
                        }).toList(),
                      ),
                      _buildAllianceSection(
                        'THE VILLAGE',
                        const Color(0xFF4CC9F0),
                        widget.players.where((p) {
                          final role = widget.playerRoles[p.id];
                          return role?.allianceId == 1;
                        }).toList(),
                      ),
                      _buildAllianceSection(
                        'SPECIALS',
                        const Color(0xFF9D4EDD), // Purple
                        widget.players.where((p) {
                          final role = widget.playerRoles[p.id];
                          return role?.allianceId != 1 && role?.allianceId != 2;
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Footer Controls
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PixelButton(
                    label: _currentStepIndex == _nightSteps.length - 1
                        ? 'END NIGHT'
                        : 'NEXT STEP',
                    color: _stepColor,
                    onPressed: _nextStep,
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
