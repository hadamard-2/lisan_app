import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/instruction_text.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/text_choices_widget.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';

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

  @override
  void initState() {
    super.initState();
    widget.exerciseData.options.shuffle();
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
          const SizedBox(height: DesignSpacing.lg),

          ..._buildExerciseContent(options),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseContent(List<Map<String, dynamic>> options) {
    return [
      TextBubbleWidget(text: widget.exerciseData.displayText),
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
