import 'package:flutter/material.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: const Color(0xFF2A2D33))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: Color(0xFF888888), fontSize: 14),
          ),
        ),
        Expanded(child: Container(height: 1, color: const Color(0xFF2A2D33))),
      ],
    );
  }
}
