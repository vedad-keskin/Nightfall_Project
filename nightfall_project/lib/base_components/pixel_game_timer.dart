import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TimerMode { twoMinutes, fiveMinutes, tenMinutes, thirtySecondsPerPlayer }

class PixelGameTimer extends StatelessWidget {
  final TimerMode selectedMode;
  final int playerCount;
  final Function(TimerMode) onModeChanged;

  const PixelGameTimer({
    super.key,
    required this.selectedMode,
    required this.playerCount,
    required this.onModeChanged,
  });

  String _getModeLabel(TimerMode mode) {
    switch (mode) {
      case TimerMode.twoMinutes:
        return '2 MIN';
      case TimerMode.fiveMinutes:
        return '5 MIN';
      case TimerMode.tenMinutes:
        return '10 MIN';
      case TimerMode.thirtySecondsPerPlayer:
        return '30s/P';
    }
  }

  int getTimerDuration(TimerMode mode, int playerCount) {
    switch (mode) {
      case TimerMode.twoMinutes:
        return 120;
      case TimerMode.fiveMinutes:
        return 300;
      case TimerMode.tenMinutes:
        return 600;
      case TimerMode.thirtySecondsPerPlayer:
        return 30 * playerCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DAY TIMER',
          style: GoogleFonts.vt323(color: Colors.white70, fontSize: 20),
        ),
        const SizedBox(height: 12),
        // 2x2 Grid of timer options
        Column(
          children: [
            Row(
              children: [
                _buildTimerOption(TimerMode.twoMinutes),
                const SizedBox(width: 8),
                _buildTimerOption(TimerMode.fiveMinutes),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTimerOption(TimerMode.tenMinutes),
                const SizedBox(width: 8),
                _buildTimerOption(TimerMode.thirtySecondsPerPlayer),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerOption(TimerMode mode) {
    final isSelected = selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => onModeChanged(mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCA311) : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFCA311)
                  : const Color(0xFF415A77),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getModeLabel(mode),
                style: GoogleFonts.pressStart2p(
                  color: isSelected ? Colors.black : Colors.white54,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
