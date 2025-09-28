import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class LessonTopBar extends StatelessWidget {
  const LessonTopBar({
    super.key,
    required double progress,
    required int remainingHearts,
    required this.onExit,
  }) : _progress = progress,
       _remainingHearts = remainingHearts;

  final double _progress;
  final int _remainingHearts;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        DesignSpacing.md,
        DesignSpacing.lg,
        DesignSpacing.lg,
        0,
      ),
      child: Row(
        spacing: DesignSpacing.md,
        children: [
          // Exit Button
          GestureDetector(
            onTap: onExit,
            child: const Icon(
              Icons.close_rounded,
              color: DesignColors.textSecondary,
              size: 27,
            ),
          ),

          // Progress Bar
          Expanded(
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: DesignColors.backgroundBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),

          // Hearts Counter
          Row(
            spacing: DesignSpacing.xs,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: DesignColors.error,
                size: 24,
              ),

              Text(
                '$_remainingHearts',
                style: const TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
