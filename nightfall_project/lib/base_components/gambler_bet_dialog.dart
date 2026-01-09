import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:nightfall_project/services/sound_settings_service.dart';

/// Represents the alliance the Gambler bet on
enum GamblerBet {
  village, // +1 point if Village wins
  werewolves, // +2 points if Werewolves win
  specials, // +3 points if Specials (Jester) wins
}

class GamblerBetDialog extends StatefulWidget {
  final String playerName;
  final Function(GamblerBet) onBetConfirmed;

  const GamblerBetDialog({
    super.key,
    required this.playerName,
    required this.onBetConfirmed,
  });

  @override
  State<GamblerBetDialog> createState() => _GamblerBetDialogState();
}

class _GamblerBetDialogState extends State<GamblerBetDialog>
    with TickerProviderStateMixin {
  GamblerBet? _selectedBet;
  bool _isRolling = false;
  bool _betConfirmed = false;
  late AnimationController _diceController;
  late AnimationController _glowController;
  late AnimationController _cardRevealController;
  final Random _random = Random();

  // Dice face values for animation
  int _dice1 = 1;
  int _dice2 = 1;

  @override
  void initState() {
    super.initState();
    _diceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _cardRevealController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _diceController.addListener(() {
      if (_isRolling) {
        setState(() {
          _dice1 = _random.nextInt(6) + 1;
          _dice2 = _random.nextInt(6) + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _diceController.dispose();
    _glowController.dispose();
    _cardRevealController.dispose();
    super.dispose();
  }

  Future<void> _playDiceSound() async {
    if (context.read<SoundSettingsService>().isMuted) return;
    final player = AudioPlayer();
    try {
      await player.play(AssetSource('audio/werewolves/dice_roll.mp3'));
    } catch (e) {
      debugPrint('Dice sound not available: $e');
    }
  }

  Future<void> _confirmBet() async {
    if (_selectedBet == null) return;

    setState(() {
      _isRolling = true;
    });

    _playDiceSound();
    _diceController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isRolling = false;
      _betConfirmed = true;
    });

    _cardRevealController.forward();

    await Future.delayed(const Duration(milliseconds: 2000));

    widget.onBetConfirmed(_selectedBet!);
  }

  Color _getBetColor(GamblerBet bet) {
    switch (bet) {
      case GamblerBet.village:
        return const Color(0xFF52B788); // Green
      case GamblerBet.werewolves:
        return const Color(0xFFE63946); // Red
      case GamblerBet.specials:
        return const Color(0xFF9D4EDD); // Purple
    }
  }

  String _getBetLabel(GamblerBet bet) {
    final lang = context.read<LanguageService>();
    switch (bet) {
      case GamblerBet.village:
        return lang.translate('gambler_bet_village');
      case GamblerBet.werewolves:
        return lang.translate('gambler_bet_werewolves');
      case GamblerBet.specials:
        return lang.translate('gambler_bet_specials');
    }
  }

  String _getBetReward(GamblerBet bet) {
    final lang = context.read<LanguageService>();
    switch (bet) {
      case GamblerBet.village:
        return lang.translate('gambler_village_reward');
      case GamblerBet.werewolves:
        return lang.translate('gambler_werewolves_reward');
      case GamblerBet.specials:
        return lang.translate('gambler_specials_reward');
    }
  }

  Widget _buildDice(int value) {
    return AnimatedBuilder(
      animation: _diceController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _isRolling ? _diceController.value * 4 * pi : 0,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F0E1), // Aged parchment
              border: Border.all(color: const Color(0xFF2D1810), width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getDiceSymbol(value),
                style: GoogleFonts.pressStart2p(
                  color: const Color(0xFF2D1810),
                  fontSize: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getDiceSymbol(int value) {
    // Using Unicode dice faces
    switch (value) {
      case 1:
        return '⚀';
      case 2:
        return '⚁';
      case 3:
        return '⚂';
      case 4:
        return '⚃';
      case 5:
        return '⚄';
      case 6:
        return '⚅';
      default:
        return '⚀';
    }
  }

  Widget _buildBetCard(GamblerBet bet) {
    final isSelected = _selectedBet == bet;
    final color = _getBetColor(bet);

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return GestureDetector(
          onTap: _betConfirmed ? null : () => setState(() => _selectedBet = bet),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.3) : const Color(0xFF1B263B),
              border: Border.all(
                color: isSelected ? color : const Color(0xFF415A77),
                width: isSelected ? 3 : 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Alliance Icon
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    _getBetIcon(bet),
                    color: isSelected ? Colors.white : color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                // Label
                Text(
                  _getBetLabel(bet),
                  style: GoogleFonts.pressStart2p(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 8,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                // Reward
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    border: Border.all(
                      color: Colors.amber.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getBetReward(bet),
                    style: GoogleFonts.vt323(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getBetIcon(GamblerBet bet) {
    switch (bet) {
      case GamblerBet.village:
        return Icons.home_work;
      case GamblerBet.werewolves:
        return Icons.pets;
      case GamblerBet.specials:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 340,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          border: Border.all(
            color: const Color(0xFFD4AF37), // Gold trim
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(6, 6),
              blurRadius: 0,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF415A77), width: 2),
          ),
          padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with ornate design
                _buildOrnateHeader(),
                const SizedBox(height: 8),

                // Player name
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFFD4AF37).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.playerName.toUpperCase(),
                    style: GoogleFonts.vt323(
                      color: const Color(0xFFD4AF37),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  lang.translate('gambler_bet_title'),
                  style: GoogleFonts.pressStart2p(
                    color: const Color(0xFFD4AF37),
                    fontSize: 14,
                    shadows: [
                      const Shadow(
                        color: Colors.black,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  lang.translate('gambler_bet_subtitle'),
                  style: GoogleFonts.vt323(
                    color: Colors.white60,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Dice decoration
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDice(_dice1),
                    const SizedBox(width: 16),
                    _buildDice(_dice2),
                  ],
                ),
                const SizedBox(height: 20),

                // Bet options
                if (!_betConfirmed) ...[
                  Row(
                    children: [
                      Expanded(child: _buildBetCard(GamblerBet.village)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildBetCard(GamblerBet.werewolves)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildBetCard(GamblerBet.specials)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Confirm button
                  _buildConfirmButton(),
                ] else ...[
                  // Show confirmed bet
                  _buildConfirmedBetDisplay(),
                ],
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildOrnateHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCornerOrnament(false),
        const SizedBox(width: 8),
        Container(
          width: 30,
          height: 2,
          color: const Color(0xFFD4AF37).withOpacity(0.5),
        ),
        const SizedBox(width: 8),
        // Center diamond
        Transform.rotate(
          angle: pi / 4,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              border: Border.all(color: const Color(0xFF8B6914), width: 1),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 30,
          height: 2,
          color: const Color(0xFFD4AF37).withOpacity(0.5),
        ),
        const SizedBox(width: 8),
        _buildCornerOrnament(true),
      ],
    );
  }

  Widget _buildCornerOrnament(bool flip) {
    return Transform(
      transform: flip ? (Matrix4.identity()..scale(-1.0, 1.0)) : Matrix4.identity(),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 20,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37),
                  const Color(0xFFD4AF37).withOpacity(0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    final canConfirm = _selectedBet != null && !_isRolling;

    return GestureDetector(
      onTap: canConfirm ? _confirmBet : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: canConfirm
              ? const Color(0xFFD4AF37).withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
          border: Border.all(
            color: canConfirm ? const Color(0xFFD4AF37) : Colors.grey,
            width: 3,
          ),
          boxShadow: canConfirm
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRolling ? Icons.casino : Icons.check_circle,
              color: canConfirm ? const Color(0xFFD4AF37) : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _isRolling
                  ? '...'
                  : context.read<LanguageService>().translate('gambler_roll_dice'),
              style: GoogleFonts.pressStart2p(
                color: canConfirm ? const Color(0xFFD4AF37) : Colors.grey,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmedBetDisplay() {
    if (_selectedBet == null) return const SizedBox.shrink();

    final color = _getBetColor(_selectedBet!);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  border: Border.all(color: color, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      _getBetIcon(_selectedBet!),
                      color: color,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getBetLabel(_selectedBet!),
                      style: GoogleFonts.pressStart2p(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getBetReward(_selectedBet!),
                      style: GoogleFonts.vt323(
                        color: Colors.amber,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.read<LanguageService>().translate('gambler_fate_sealed'),
                style: GoogleFonts.pressStart2p(
                  color: const Color(0xFFD4AF37),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
