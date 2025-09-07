import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/exercise_state.dart';

class FeedbackPanel extends StatelessWidget {
  final ExerciseState exerciseState;
  final Future<String?>? currentFeedbackMessage;
  final Future<String?>? currentCorrectAnswer;
  final VoidCallback handleContinue;
  final Animation<Offset> feedbackSlideAnimation;
  final String buttonText;
  final Color buttonColor;

  const FeedbackPanel({
    super.key,
    required this.exerciseState,
    required this.currentFeedbackMessage,
    required this.currentCorrectAnswer,
    required this.handleContinue,
    required this.feedbackSlideAnimation,
    required this.buttonText,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    if (exerciseState != ExerciseState.correct &&
        exerciseState != ExerciseState.incorrect) {
      return const SizedBox.shrink();
    }

    final isCorrect = exerciseState == ExerciseState.correct;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: feedbackSlideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              top: BorderSide(color: DesignColors.backgroundBorder, width: 2),
              left: BorderSide(color: DesignColors.backgroundBorder, width: 2),
              right: BorderSide(color: DesignColors.backgroundBorder, width: 2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Feedback Content
              Container(
                padding: const EdgeInsets.all(DesignSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel,
                          color: isCorrect
                              ? DesignColors.success
                              : DesignColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: DesignSpacing.sm),
                        Text(
                          isCorrect ? 'Nicely done.' : 'Incorrect',
                          style: TextStyle(
                            color: isCorrect
                                ? DesignColors.success
                                : DesignColors.error,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    if (currentFeedbackMessage != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      FutureBuilder<String?>(
                        future: currentFeedbackMessage!,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: TextStyle(
                                color: isCorrect
                                    ? DesignColors.success
                                    : DesignColors.textSecondary,
                                fontSize: 16,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],

                    if (!isCorrect && currentCorrectAnswer != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      Text(
                        'Correct Answer:',
                        style: const TextStyle(
                          color: DesignColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.xs),
                      FutureBuilder<String?>(
                        future: currentCorrectAnswer!,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                color: DesignColors.success,
                                fontSize: 16,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Button Section
              Container(
                padding: const EdgeInsets.all(DesignSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: DesignColors.backgroundDark,
                      elevation: 8,
                      shadowColor: buttonColor.withAlpha(76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
