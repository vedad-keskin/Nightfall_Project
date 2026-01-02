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
        color: const Color(0xFF1B263B), // Dark medieval blue
        border: Border.all(
          color: const Color(0xFF778DA9), // Silvery blue-grey border
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            offset: const Offset(8, 8),
            blurRadius: 0, // Hard pixel shadow
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        color: const Color(0xFF0D1B2A), // Deepest night blue
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.pressStart2p(
                color: const Color(0xFFE0E1DD), // Off-white/Silver text
                fontSize: 27,
                shadows: [
                  const Shadow(color: Color(0xFF000000), offset: Offset(3, 3)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            PixelButton(
              label: 'PLAY NOW',
              // Use a rich dark accent interaction color, or keep dynamic if needed
              color: const Color(0xFF415A77),
              onPressed: () {
                // Placeholder action if needed, or handled by parent
              },
            ),
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
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _playSound(); // Play sound on release
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Transform.translate(
        offset: Offset(
          0,
          translate,
        ), // Move ONLY vertically for a button press feel? Or x,y? Original was x,y. Let's keep x,y for pixel art feel or just y. Let's stick to original x,y for consistent 3D feel.
        // Actually, for a "press" usually just Y or both if the shadow is diagonal. Shadow is diagonal (4,4), so shift (4,4) to "cover" the shadow.
        child: Container(
          decoration: BoxDecoration(
            color: _isPressed ? widget.color.withOpacity(0.8) : widget.color,
            border: Border.all(
              color: const Color(0xFFE0E1DD), // Silver border
              width: 2,
            ),
            boxShadow: [
              if (!_isPressed)
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(4, 4),
                  blurRadius: 0,
                ),
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
                shadows: [
                  const Shadow(color: Colors.black, offset: Offset(1, 1)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
