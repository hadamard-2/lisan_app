import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class AudioChoicesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final int selectedOptionIndex;
  final Function(int) onOptionSelect;

  late final List<int> waveformIds;

  AudioChoicesWidget({
    super.key,
    required this.options,
    required this.selectedOptionIndex,
    required this.onOptionSelect,
  }) {
    waveformIds = options.map((option) {
      final hash = option['id'].toString().hashCode.abs();
      return (hash % 7) + 1; // Ensures values 1-7
    }).toList();
  }

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
                  ? DesignColors.primary.withAlpha((0.05 * 255).toInt())
                  : Colors.transparent,
              border: Border.all(
                color: selectedOptionIndex == index
                    ? DesignColors.primary
                    : DesignColors.backgroundBorder,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Icon(Icons.volume_up_rounded, color: DesignColors.primary),
                Image.asset(
                  'assets/images/waveform (${waveformIds[index]}).png',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
