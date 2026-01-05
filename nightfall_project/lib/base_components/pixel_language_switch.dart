import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nightfall_project/services/language_service.dart';

class PixelLanguageSwitch extends StatelessWidget {
  const PixelLanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<LanguageService>(context);
    final isEn = languageService.currentLanguage == 'en';

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF778DA9),
          border: Border.all(color: const Color(0xFFE0E1DD), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              flagAsset: 'assets/images/uk.png',
              isSelected: isEn,
              onTap: () => languageService.setLanguage('en'),
            ),
            Container(width: 1, height: 20, color: const Color(0xFF415A77)),
            _LanguageOption(
              flagAsset: 'assets/images/bih.png',
              isSelected: !isEn,
              onTap: () => languageService.setLanguage('bs'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flagAsset;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flagAsset,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        color: isSelected ? Colors.white10 : Colors.transparent,
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.4,
          child: Image.asset(
            flagAsset,
            width: 24,
            height: 16,
            fit: BoxFit.cover,
            // Pixelated look for the flag if possible?
            // filterQuality: FilterQuality.none handles it
            filterQuality: FilterQuality.none,
          ),
        ),
      ),
    );
  }
}
