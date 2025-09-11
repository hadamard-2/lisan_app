import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';

class TopNavigation extends StatelessWidget {
  final int streakCount;
  final int hearts;

  const TopNavigation({
    super.key,
    required this.streakCount,
    required this.hearts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Streak Counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: DesignColors.backgroundCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: DesignColors.backgroundBorder),
            ),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '🔥',
                    style: GoogleFonts.notoColorEmoji(fontSize: 18),
                  ),
                  TextSpan(
                    text: '  $streakCount',
                    style: GoogleFonts.rubik(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          // Hearts Indicator
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Coming soon!",
                    style: TextStyle(color: DesignColors.textPrimary),
                  ),
                  backgroundColor: DesignColors.backgroundBorder,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: DesignColors.backgroundCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: DesignColors.backgroundBorder),
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '❤️',
                      style: GoogleFonts.notoColorEmoji(fontSize: 18),
                    ),
                    TextSpan(
                      text: '  $hearts',
                      style: GoogleFonts.rubik(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
