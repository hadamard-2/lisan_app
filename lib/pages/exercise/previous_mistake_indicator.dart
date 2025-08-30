import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class PreviousMistakeIndicator extends StatelessWidget {
  const PreviousMistakeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.repeat_rounded, color: Colors.orange),
        SizedBox(width: DesignSpacing.sm),
        Text(
          'PREVIOUS MISTAKE',
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: DesignSpacing.xxxl),
      ],
    );
  }
}
