import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/utils/text_utils.dart';

class Block extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isInSelectedArea;

  const Block({
    super.key,
    required this.text,
    this.onTap,
    this.isSelected = false,
    this.isInSelectedArea = false,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isInSelectedArea) {
      backgroundColor = DesignColors.primary.withAlpha((0.2 * 255).toInt());
      textColor = DesignColors.primaryLight;
      borderColor = Colors.transparent;
    } else if (isSelected) {
      backgroundColor = DesignColors.backgroundCard.withAlpha(
        (0.5 * 255).toInt(),
      );
      textColor = DesignColors.textTertiary;
      borderColor = DesignColors.backgroundBorder.withAlpha(
        (0.5 * 255).toInt(),
      );
    } else {
      backgroundColor = Colors.transparent;
      textColor = DesignColors.textPrimary;
      borderColor = DesignColors.backgroundBorder;
    }

    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSpacing.md,
            vertical: DesignSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: isInSelectedArea
                ? null
                : Border.all(color: borderColor, width: 2),
          ),
          child: Text(
            text,
            style:
                (TextUtils.isAmharic(text)
                        ? GoogleFonts.notoSansEthiopic()
                        : GoogleFonts.rubik())
                    .copyWith(color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
