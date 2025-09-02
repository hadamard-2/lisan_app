import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';

class SpeakingExercise extends ExerciseWidget {
  @override
  final SpeakingExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const SpeakingExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  }) : super(exerciseData: exerciseData);

  @override
  State<SpeakingExercise> createState() => _SpeakingExerciseState();

  @override
  ExerciseWidget copyWith({
    SpeakingExerciseData? exerciseData,
    Function(String)? onAnswerChanged,
    bool? isRequeued,
    Key? key,
  }) {
    return SpeakingExercise(
      key: key ?? this.key,
      exerciseData: exerciseData ?? this.exerciseData,
      onAnswerChanged: onAnswerChanged ?? this.onAnswerChanged,
      isRequeued: isRequeued ?? this.isRequeued,
    );
  }
}

class _SpeakingExerciseState extends State<SpeakingExercise> {
  @override
  Widget build(BuildContext context) {
    final instruction = widget.exerciseData.instruction;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isRequeued) PreviousMistakeIndicator(),

          // Instruction text
          Text(
            instruction,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignSpacing.xl),

          ..._buildExerciseContent(),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseContent() {
    return [
      TextBubbleWidget(
        text: widget.exerciseData.targetText,
        audioUrl: widget.exerciseData.audioUrl,
      ),
      const SizedBox(height: DesignSpacing.xl),

      GestureDetector(
        onTap: () {},
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
      ),
    ];
  }
}
