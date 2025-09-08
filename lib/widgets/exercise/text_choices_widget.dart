import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';

class TextChoicesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final int selectedOptionIndex;
  final Function(int) onOptionSelect;

  const TextChoicesWidget({
    super.key,
    required this.options,
    required this.selectedOptionIndex,
    required this.onOptionSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: options.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onOptionSelect(index),
          child: Container(
            width: double.infinity,
            height: 60,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(DesignSpacing.md),
            margin: const EdgeInsets.only(bottom: DesignSpacing.sm),
            decoration: BoxDecoration(
              color: selectedOptionIndex == index
                  ? DesignColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: selectedOptionIndex == index
                    ? DesignColors.primary
                    : DesignColors.backgroundBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              options[index]['text'],
              style: GoogleFonts.notoSansEthiopic(
                color: DesignColors.textPrimary,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}
