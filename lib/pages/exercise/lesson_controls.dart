import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/exercise_state.dart';

class LessonControls extends StatelessWidget {
  final String exerciseType;
  final ExerciseState exerciseState;
  final Listenable buttonAnimation;
  final VoidCallback handleCheck;
  final String buttonText;
  final Color buttonColor;

  const LessonControls({
    super.key,
    required this.exerciseType,
    required this.exerciseState,
    required this.buttonAnimation,
    required this.handleCheck,
    required this.buttonText,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    String skipText = '';
    switch (exerciseType) {
      case 'speaking':
        skipText = 'CAN\'T SPEAK NOW';
        break;
      case 'listening':
        skipText = 'CAN\'T LISTEN NOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Column(
        spacing: DesignSpacing.md,
        children: [
          if (skipText.isNotEmpty && exerciseState == ExerciseState.initial)
            TextButton(
              onPressed: () {},
              child: Text(
                skipText,
                style: TextStyle(
                  color: DesignColors.textTertiary,
                  fontSize: 15,
                ),
              ),
            ),

          // Main Action Button (only show when no feedback)
          if (exerciseState != ExerciseState.correct &&
              exerciseState != ExerciseState.incorrect)
            AnimatedBuilder(
              animation: buttonAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: exerciseState == ExerciseState.checking
                        ? null
                        : handleCheck,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: DesignColors.backgroundDark,
                      elevation: 8,
                      shadowColor: buttonColor.withAlpha(76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: exerciseState == ExerciseState.checking
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
