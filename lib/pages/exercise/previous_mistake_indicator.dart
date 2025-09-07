import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class PreviousMistakeIndicator extends StatelessWidget {
  const PreviousMistakeIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.repeat_rounded, color: DesignColors.attention),
            SizedBox(width: DesignSpacing.sm),
            Text(
              'PREVIOUS MISTAKE',
              style: TextStyle(
                color: DesignColors.attention,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: DesignSpacing.lg),
      ],
    );
  }
}
