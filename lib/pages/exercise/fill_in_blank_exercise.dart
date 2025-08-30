import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/fill_in_blank_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';

class FillInBlankExercise extends ExerciseWidget {
  final FillInBlankExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const FillInBlankExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  });

  @override
  State<FillInBlankExercise> createState() => _FillInBlankExerciseState();

  @override
  ExerciseWidget copyWith({
    FillInBlankExerciseData? exerciseData,
    Function(String)? onAnswerChanged,
    bool? isRequeued,
    Key? key,
  }) {
    return FillInBlankExercise(
      key: key ?? this.key,
      exerciseData: exerciseData ?? this.exerciseData,
      onAnswerChanged: onAnswerChanged ?? this.onAnswerChanged,
      isRequeued: isRequeued ?? this.isRequeued,
    );
  }
}

class _FillInBlankExerciseState extends State<FillInBlankExercise> {
  int _selectedOptionIndex = -1;

  @override
  Widget build(BuildContext context) {
    final instruction = widget.exerciseData.instruction;
    final options = widget.exerciseData.options;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isRequeued)
            Row(
              children: [
                Icon(Icons.repeat_rounded, color: Colors.orange),
                SizedBox(width: DesignSpacing.sm),
                Text(
                  'PREVIOUS MISTAKE',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: DesignSpacing.xxxl),
              ],
            ),

          // Instruction text
          Text(
            instruction,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: DesignSpacing.lg),

          ..._buildExerciseContent(options),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseContent(List<String> options) {
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(DesignSpacing.lg),
        decoration: BoxDecoration(
          color: DesignColors.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignColors.backgroundBorder),
        ),
        child: Text(
          widget.exerciseData.sentenceWithPlaceholders,
          style: const TextStyle(color: DesignColors.textPrimary, fontSize: 16),
        ),
      ),
      const SizedBox(height: DesignSpacing.xxxl * 2),

      // Choices
      ListView.builder(
        shrinkWrap: true,
        itemCount: options.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedOptionIndex = index;
              });

              widget.onAnswerChanged(options[index]);
            },
            child: Container(
              width: double.infinity,
              height: 60,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(DesignSpacing.md),
              margin: const EdgeInsets.only(bottom: DesignSpacing.sm),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedOptionIndex == index
                      ? DesignColors.primary
                      : DesignColors.backgroundBorder,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                options[index],
                style: const TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}
