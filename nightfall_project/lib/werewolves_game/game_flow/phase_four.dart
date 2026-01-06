import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/werewolves_game/offline_db/player_service.dart';
import 'package:nightfall_project/werewolves_game/offline_db/role_service.dart';

class WerewolfPhaseFourScreen extends StatelessWidget {
  final Map<String, WerewolfRole> playerRoles;
  final List<WerewolfPlayer> players;
  final List<String> deadPlayerIds;

  const WerewolfPhaseFourScreen({
    super.key,
    required this.playerRoles,
    required this.players,
    required this.deadPlayerIds,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF87CEEB), // Day Sky Blue
      body: Stack(
        children: [
          // Sun / Day background (Placeholder)
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.yellow,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.5),
                    blurRadius: 50,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "DAY PHASE",
                  style: GoogleFonts.pressStart2p(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Discussion Time!",
                  style: GoogleFonts.vt323(color: Colors.black, fontSize: 24),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(32.0),
                //   child: PixelButton(
                //     label: "VOTE NOW",
                //     color: Colors.orange,
                //     onPressed: () {
                //        // TODO: Voting Phase
                //     }
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
