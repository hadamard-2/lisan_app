import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/available_block.dart';
import 'package:lisan_app/widgets/exercise/block.dart';

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
