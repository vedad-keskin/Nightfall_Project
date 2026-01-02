import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class PixelDialog extends StatelessWidget {
  final String title;
  final Color color;
  final Color accentColor;

  const PixelDialog({
    super.key,
    required this.title,
    required this.color,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: accentColor,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        color: color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.pressStart2p(
                color: Colors.white,
                fontSize: 27,
                shadows: [
                  const Shadow(color: Colors.black, offset: Offset(4, 4)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            PixelButton(label: 'PLAY NOW', color: accentColor),
          ],
        ),
      ),
    );
  }
}

class PixelButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const PixelButton({
    super.key,
    required this.label,
    required this.color,
    this.onPressed,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    try {
      // Assumes assets/audio/click.mp3 exists or will exist
      await _audioPlayer.play(AssetSource('images/click.wav'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3D effect calculation
    final double translate = _isPressed ? 4 : 0;

    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _playSound();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(translate, translate),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              if (!_isPressed)
                const BoxShadow(color: Colors.black, offset: Offset(4, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              widget.label,
              style: GoogleFonts.vt323(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
