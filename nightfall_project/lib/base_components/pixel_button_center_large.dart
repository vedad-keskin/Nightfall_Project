import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PixelButtonCenterLarge extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;
  final double height;

  const PixelButtonCenterLarge({
    super.key,
    required this.label,
    required this.color,
    required this.onPressed,
    this.height = 100,
  });

  @override
  State<PixelButtonCenterLarge> createState() => _PixelButtonCenterLargeState();
}

class _PixelButtonCenterLargeState extends State<PixelButtonCenterLarge> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        width: double.infinity,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black, // Shadow
          boxShadow: _isPressed
              ? []
              : [
                  const BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 8),
                    blurRadius: 0,
                  ),
                ],
        ),
        margin: EdgeInsets.only(top: _isPressed ? 8 : 0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 4),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                widget.label,
                style: GoogleFonts.pressStart2p(
                  color: Colors.white,
                  fontSize: 28,
                  shadows: [
                    const Shadow(color: Colors.black, offset: Offset(4, 4)),
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
