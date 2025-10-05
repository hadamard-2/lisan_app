import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/picture_multiple_choice_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/widgets/exercise/instruction_text.dart';
import 'package:lisan_app/widgets/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/picture_choices_widget.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';

class PictureMultipleChoiceExercise extends ExerciseWidget {
  @override
  final PictureMultipleChoiceExerciseData exerciseData;
  final Function(int) onAnswerChanged;

  const PictureMultipleChoiceExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  }) : super(exerciseData: exerciseData);

  @override
  State<PictureMultipleChoiceExercise> createState() =>
      _PictureMultipleChoiceExerciseState();

  @override
  ExerciseWidget copyWith({
    PictureMultipleChoiceExerciseData? exerciseData,
    Function(int)? onAnswerChanged,
    bool? isRequeued,
    Key? key,
  }) {
    return PictureMultipleChoiceExercise(
      key: key ?? this.key,
      exerciseData: exerciseData ?? this.exerciseData,
      onAnswerChanged: onAnswerChanged ?? this.onAnswerChanged,
      isRequeued: isRequeued ?? this.isRequeued,
    );
  }
}

class _PictureMultipleChoiceExerciseState
    extends State<PictureMultipleChoiceExercise> {
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
          if (widget.isRequeued) const PreviousMistakeIndicator(),

          InstructionText(instruction: instruction),
          const SizedBox(height: DesignSpacing.xl),

          ..._buildExerciseContent(options),
        ],
      ),
    );
  }

  List<Widget> _buildExerciseContent(List<Map<String, dynamic>> options) {
    return [
      TextBubbleWidget(
        text: widget.exerciseData.promptText,
        audioUrl: widget.exerciseData.audioUrl,
      ),
      const SizedBox(height: DesignSpacing.xl),
      PictureChoicesWidget(
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
