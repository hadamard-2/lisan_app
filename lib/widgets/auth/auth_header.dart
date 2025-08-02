import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Icon with Ethiopian colors accent
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFFF1CC06), Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF1CC06).withAlpha((0.3 * 255).toInt()),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.translate,
            size: 40,
            color: Color(0xFF14161B),
          ),
        ),

        const SizedBox(height: 24),

        // App Name
        const Text(
          'Lisan',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF1CC06),
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle with Amharic text
        const Text(
          'Learn Amharic • አማርኛ እንማር',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFFB0B0B0),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
