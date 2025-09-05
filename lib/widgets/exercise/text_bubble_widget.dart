import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/utils/language_detection.dart';

class TextBubbleWidget extends StatelessWidget {
  final String text;
  final String? audioUrl;

  const TextBubbleWidget({super.key, required this.text, this.audioUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.lg),
      decoration: BoxDecoration(
        color: DesignColors.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.backgroundBorder),
      ),
      child: Row(
        spacing: DesignSpacing.sm,
        children: [
          if (audioUrl != null)
            IconButton(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              onPressed: () {
                print('playing voice');
              },
              icon: Icon(Icons.volume_up_rounded, color: DesignColors.primary),
            ),
          Expanded(
            child: Text(
              text,
              style:
                  (isMostlyAmharic(text)
                          ? GoogleFonts.notoSansEthiopic()
                          : GoogleFonts.rubik())
                      .copyWith(color: DesignColors.textPrimary, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
