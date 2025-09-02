import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';

class AvailableBlock {
  final String text;
  bool isSelected;

  AvailableBlock({required this.text, this.isSelected = false});
}

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
      textColor = DesignColors.primary;
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
            borderRadius: BorderRadius.circular(8),
            border: isInSelectedArea ? null : Border.all(color: borderColor),
          ),
          child: Text(
            text,
            style: GoogleFonts.notoSansEthiopic(color: textColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class BlockBuildWidget extends StatelessWidget {
  final List<String> selectedBlocks;
  final List<AvailableBlock> availableBlocks;
  final Function(String, int) onSelectedBlockTap;
  final Function(String) onAvailableBlockTap;

  const BlockBuildWidget({
    super.key,
    required this.selectedBlocks,
    required this.availableBlocks,
    required this.onSelectedBlockTap,
    required this.onAvailableBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: DesignSpacing.xl,
      children: [
        // Selected blocks
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(DesignSpacing.md),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: selectedBlocks.isEmpty
              ? const Center(
                  child: Text(
                    'Tap blocks below to build your translation',
                    style: TextStyle(
                      color: DesignColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                )
              : Wrap(
                  spacing: DesignSpacing.sm,
                  runSpacing: DesignSpacing.sm,
                  children: selectedBlocks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final block = entry.value;
                    return Block(
                      text: block,
                      isInSelectedArea: true,
                      onTap: () => onSelectedBlockTap(block, index),
                    );
                  }).toList(),
                ),
        ),
        // Available blocks
        Wrap(
          alignment: WrapAlignment.center,
          spacing: DesignSpacing.sm,
          runSpacing: DesignSpacing.sm,
          children: availableBlocks.map((block) {
            return Block(
              text: block.text,
              isSelected: block.isSelected,
              onTap: block.isSelected
                  ? null
                  : () => onAvailableBlockTap(block.text),
            );
          }).toList(),
        ),
      ],
    );
  }
}
