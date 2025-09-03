import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/available_block.dart';
import 'package:lisan_app/widgets/exercise/block.dart';

class PartialBlockBuildWidget extends StatelessWidget {
  final String textWithBlanks;
  final List<String?> selectedBlocks;
  final List<AvailableBlock> availableBlocks;
  final Function(int) onSelectedBlockTap;
  final Function(String) onAvailableBlockTap;

  const PartialBlockBuildWidget({
    super.key,
    required this.textWithBlanks,
    required this.selectedBlocks,
    required this.availableBlocks,
    required this.onSelectedBlockTap,
    required this.onAvailableBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: DesignSpacing.md,
      children: [
        // Selected word blocks
        SizedBox(
          height: 200,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DesignSpacing.md),
            decoration: BoxDecoration(
              color: DesignColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DesignColors.backgroundBorder),
            ),
            child: _buildSentenceWithBlanks(),
          ),
        ),
        // Available word blocks
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.md),
          child: Wrap(
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
        ),
      ],
    );
  }

  Widget _buildSentenceWithBlanks() {
    List<String> parts = textWithBlanks.split('____');
    List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      // Add text part
      if (parts[i].isNotEmpty) {
        widgets.add(
          Text(
            parts[i],
            style: GoogleFonts.notoSansEthiopic(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        );
      }

      // Add blank or selected word - refactored to use Block widget
      if (i < parts.length - 1) {
        if (i < selectedBlocks.length && selectedBlocks[i] != null) {
          widgets.add(
            Block(
              text: selectedBlocks[i]!,
              isInSelectedArea: true,
              onTap: () => onSelectedBlockTap(i),
            ),
          );
        } else {
          widgets.add(
            Container(
              width: 50,
              height: 2,
              color: DesignColors.textTertiary,
              margin: const EdgeInsets.only(top: 12, left: 5, right: 5),
            ),
          );
        }
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }
}