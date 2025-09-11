import 'package:flutter/material.dart';
import 'package:lisan_app/models/unit_data.dart';

class CurrentUnitIndicator extends StatelessWidget {
  final UnitData? currentUnit;

  const CurrentUnitIndicator({super.key, required this.currentUnit});

  @override
  Widget build(BuildContext context) {
    if (currentUnit == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: currentUnit!.color,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(
            color: _darkenColor(currentUnit!.color, 0.2),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: currentUnit!.color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UNIT ${currentUnit!.id} • CURRENTLY VIEWING",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUnit!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.book_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Color _darkenColor(Color color, double factor) {
    return HSLColor.fromColor(color)
        .withLightness(
          (HSLColor.fromColor(color).lightness - factor).clamp(0.0, 1.0),
        )
        .toColor();
  }
}
