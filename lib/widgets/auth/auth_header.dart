import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

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
              colors: [DesignColors.primary, Color(0xFFFFD700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: DesignColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.translate,
            size: 40,
            color: DesignColors.backgroundDark,
          ),
        ),

        const SizedBox(height: 24),

        // App Name
        const Text(
          'Lisan',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: DesignColors.primary,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle with Amharic text
        const Text(
          'Learn Amharic • አማርኛ እንማር',
          style: TextStyle(
            fontSize: 16,
            color: DesignColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
