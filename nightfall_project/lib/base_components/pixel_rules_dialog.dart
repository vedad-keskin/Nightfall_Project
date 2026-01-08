import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nightfall_project/base_components/pixel_button.dart';
import 'package:nightfall_project/services/language_service.dart';
import 'package:provider/provider.dart';

class PixelRulesDialog extends StatelessWidget {
  final bool isImpostor;

  const PixelRulesDialog({super.key, required this.isImpostor});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageService>();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFF778DA9),
          border: Border.all(color: const Color(0xFF415A77), width: 4),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1B2A),
            border: Border.all(color: Colors.black, width: 4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lang.translate(
                  isImpostor
                      ? 'rules_impostor_title'
                      : 'rules_werewolves_title',
                ),
                style: GoogleFonts.pressStart2p(
                  color: const Color(0xFFE0E1DD),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    lang.translate(
                      isImpostor
                          ? 'rules_impostor_content'
                          : 'rules_werewolves_content',
                    ),
                    style: GoogleFonts.vt323(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PixelButton(
                label: lang.translate('back'),
                color: const Color(0xFF415A77),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
