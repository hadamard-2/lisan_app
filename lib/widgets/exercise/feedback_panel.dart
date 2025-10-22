import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/exercise_state.dart';
import 'package:just_audio/just_audio.dart';

class FeedbackPanel extends StatefulWidget {
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
  State<FeedbackPanel> createState() => _FeedbackPanelState();
}

class _FeedbackPanelState extends State<FeedbackPanel> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playFeedbackSound();
  }

  @override
  void didUpdateWidget(FeedbackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exerciseState != widget.exerciseState) {
      _playFeedbackSound();
    }
  }

  Future<void> _playFeedbackSound() async {
    if (widget.exerciseState == ExerciseState.correct ||
        widget.exerciseState == ExerciseState.incorrect) {
      try {
        final soundFile = widget.exerciseState == ExerciseState.correct
            ? 'assets/sound_effects/correct_answer.m4a'
            : 'assets/sound_effects/incorrect_answer.mp3';
        
        await _audioPlayer.setAsset(soundFile);
        await _audioPlayer.play();
      } catch (e) {
        debugPrint('Error playing feedback sound: $e');
      }
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.exerciseState != ExerciseState.correct &&
        widget.exerciseState != ExerciseState.incorrect &&
        widget.exerciseState != ExerciseState.skipped) {
      return const SizedBox.shrink();
    }

    final isCorrect = widget.exerciseState == ExerciseState.correct;
    final isSkipped = widget.exerciseState == ExerciseState.skipped;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: widget.feedbackSlideAnimation,
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
                color: Colors.black.withValues(alpha: 0.2),
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
                          isSkipped
                              ? Icons.skip_next_rounded
                              : (isCorrect
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel),
                          color: isSkipped
                              ? DesignColors.attention
                              : (isCorrect
                                    ? DesignColors.success
                                    : DesignColors.error),
                          size: 24,
                        ),
                        const SizedBox(width: DesignSpacing.sm),
                        Text(
                          isSkipped
                              ? 'Skipped'
                              : (isCorrect ? 'Nicely done.' : 'Incorrect'),
                          style: TextStyle(
                            color: isSkipped
                                ? DesignColors.attention
                                : (isCorrect
                                      ? DesignColors.success
                                      : DesignColors.error),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    if (widget.currentFeedbackMessage != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      FutureBuilder<String?>(
                        future: widget.currentFeedbackMessage!,
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

                    if (!isCorrect && widget.currentCorrectAnswer != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      Text(
                        'Correct Answer',
                        style: const TextStyle(
                          color: DesignColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.sm),
                      FutureBuilder<String?>(
                        future: widget.currentCorrectAnswer!,
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
                    onPressed: widget.handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.buttonColor,
                      foregroundColor: DesignColors.backgroundDark,
                      elevation: 8,
                      shadowColor: widget.buttonColor.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      widget.buttonText,
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