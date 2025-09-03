import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class VoiceInputWidget extends StatelessWidget {
  final Function() onTap;

  const VoiceInputWidget({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsetsGeometry.symmetric(vertical: DesignSpacing.lg),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: DesignColors.backgroundBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: DesignSpacing.sm,
          children: [
            Icon(Icons.mic_rounded, color: DesignColors.primary),
            Text(
              'TAP TO SPEAK',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: DesignColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
