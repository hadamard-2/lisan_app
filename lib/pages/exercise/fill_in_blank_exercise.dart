import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/widgets/exercise/instruction_text.dart';
import 'package:lisan_app/widgets/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/text_choices_widget.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';
import 'dart:math';

class FillInBlankExercise extends ExerciseWidget {
  @override
  final FillInBlankExerciseData exerciseData;
  final Function(int) onAnswerChanged;

  const FillInBlankExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  }) : super(exerciseData: exerciseData);

  @override
  State<FillInBlankExercise> createState() => _FillInBlankExerciseState();

  @override
  ExerciseWidget copyWith({
    FillInBlankExerciseData? exerciseData,
    Function(int)? onAnswerChanged,
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
  late final String _illustrationPath;

  @override
  void initState() {
    super.initState();
    widget.exerciseData.options.shuffle();

    final random = Random();
    final number = random.nextBool() ? '1' : '2';
    final gender = random.nextBool() ? 'male' : 'female';
    _illustrationPath = 'assets/illustrations/normal_${number}_$gender.png';
  }

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
          if (widget.isRequeued) PreviousMistakeIndicator(),

          InstructionText(instruction: instruction),
          const SizedBox(height: DesignSpacing.xxl),

          ..._buildExerciseContent(options),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseContent(List<Map<String, dynamic>> options) {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(_illustrationPath, fit: BoxFit.contain),
            ),
          ),
          SizedBox(width: DesignSpacing.md),
          // Text Bubble
          Expanded(
            child: TextBubbleWidget(text: widget.exerciseData.displayText),
          ),
        ],
      ),
      const SizedBox(height: DesignSpacing.xxxl * 2),
      TextChoicesWidget(
        options: options,
        selectedOptionIndex: _selectedOptionIndex,
        onOptionSelect: (index) {
          setState(() {
            _selectedOptionIndex = index;
          });

          widget.onAnswerChanged(options[index]['id']);
        },
      ),
    ];
  }
}
