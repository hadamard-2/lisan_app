import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(height: 1, color: DesignColors.backgroundBorder),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: DesignColors.textTertiary, fontSize: 14),
          ),
        ),
        Expanded(
          child: Container(height: 1, color: DesignColors.backgroundBorder),
        ),
      ],
    );
  }
}
