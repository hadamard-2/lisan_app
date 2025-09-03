import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class InstructionText extends StatelessWidget {
  const InstructionText({
    super.key,
    required this.instruction,
  });

  final String instruction;

  @override
  Widget build(BuildContext context) {
    return Text(
      instruction,
      style: const TextStyle(
        color: DesignColors.textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
