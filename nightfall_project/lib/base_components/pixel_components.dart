import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

class PixelDialog extends StatelessWidget {
  final String title;
  final Color color;
  final Color accentColor;
  final String? soundPath;

  const PixelDialog({
    super.key,
    required this.title,
    required this.color,
    required this.accentColor,
    this.soundPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 310,
      // Layer 1: Outer Border / Shadow Base
      decoration: BoxDecoration(
        color: const Color(0xFF000000), // Pure black outer
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(12, 12), // Deep shadow
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4), // Thickness of outer black border
      child: Container(
        // Layer 2: Main Frame Color (Silver/Stone)
        decoration: const BoxDecoration(
          color: Color(0xFF778DA9), // Stone Grey
          border: Border.symmetric(
            vertical: BorderSide(
              color: Color(0xFF415A77),
              width: 4,
            ), // Side accents
            horizontal: BorderSide(
              color: Color(0xFFE0E1DD),
              width: 4,
            ), // Top/Bottom highlights
          ),
        ),
        padding: const EdgeInsets.all(4), // Thickness of metallic frame
        child: Container(
          // Layer 3: Inner Inset Border
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A), // Inner BG base
            border: Border.all(color: const Color(0xFF000000), width: 2),
          ),
          child: Container(
            // Actual Content Background
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            color: const Color(0xFF0D1B2A), // Dark Night Blue
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B),
                    border: Border.all(
                      color: const Color(0xFF415A77),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.pressStart2p(
                      color: const Color(0xFFE0E1DD),
                      fontSize: 24,
                      shadows: [
                        const Shadow(
                          color: Color(0xFF000000),
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                PixelButton(
                  label: 'PLAY NOW',
                  color: const Color(0xFF415A77),
                  soundPath: soundPath,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PixelButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final String? soundPath;

  const PixelButton({
    super.key,
    required this.label,
    required this.color,
    this.onPressed,
    this.soundPath,
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
      await _audioPlayer.play(
        AssetSource(widget.soundPath ?? 'images/click.wav'),
      );
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
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _playSound(); // Play sound on release
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(0, translate),
        child: Container(
          // Complex Button Border
          decoration: BoxDecoration(
            color: Colors.black, // Outer border color
            boxShadow: [
              if (!_isPressed)
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                ),
            ],
          ),
          padding: const EdgeInsets.only(
            bottom: 4,
          ), // Bottom "3D" lip color (black here)
          child: Container(
            color: _isPressed ? widget.color.withOpacity(0.8) : widget.color,
            padding: const EdgeInsets.all(2), // Inner border width
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ), // Highlight
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(
                widget.label,
                style: GoogleFonts.vt323(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(color: Colors.black, offset: Offset(1, 1)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
