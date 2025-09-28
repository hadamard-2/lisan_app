import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/available_block.dart';
import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/instruction_text.dart';
import 'package:lisan_app/pages/exercise/partial_block_build_widget.dart';
import 'package:lisan_app/pages/exercise/partial_free_text_widget.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';

class CompleteSentenceExercise extends ExerciseWidget {
  @override
  final CompleteSentenceExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const CompleteSentenceExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  }) : super(exerciseData: exerciseData);

  @override
  CompleteSentenceExercise copyWith({
    CompleteSentenceExerciseData? exerciseData,
    Function(String)? onAnswerChanged,
    bool? isRequeued,
    Key? key,
  }) {
    return CompleteSentenceExercise(
      key: key ?? this.key,
      exerciseData: exerciseData ?? this.exerciseData,
      onAnswerChanged: onAnswerChanged ?? this.onAnswerChanged,
      isRequeued: isRequeued ?? this.isRequeued,
    );
  }

  @override
  State<CompleteSentenceExercise> createState() =>
      _CompleteSentenceExerciseState();
}

class _CompleteSentenceExerciseState extends State<CompleteSentenceExercise> {
  String currentAnswer = '';

  void _updateAnswer(String answer) {
    setState(() {
      currentAnswer = answer;
    });
    widget.onAnswerChanged(answer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isRequeued) PreviousMistakeIndicator(),

          InstructionText(instruction: widget.exerciseData.instruction),
          SizedBox(height: DesignSpacing.xxl),

          // Exercise content based on subtype
          _renderExerciseContent(),
        ],
      ),
    );
  }

  Widget _renderExerciseContent() {
    switch (widget.exerciseData.subtype) {
      case 'partial_free_text':
        return PartialFreeTextExerciseContent(
          data: widget.exerciseData,
          onAnswerChanged: _updateAnswer,
        );
      case 'partial_block_build':
        return PartialBlockBuildExerciseContent(
          data: widget.exerciseData,
          onAnswerChanged: _updateAnswer,
        );
      default:
        throw Exception('Unknown exercise subtype');
    }
  }
}

class PartialFreeTextExerciseContent extends StatefulWidget {
  final CompleteSentenceExerciseData data;
  final Function(String) onAnswerChanged;

  const PartialFreeTextExerciseContent({
    super.key,
    required this.data,
    required this.onAnswerChanged,
  });

  @override
  State<PartialFreeTextExerciseContent> createState() =>
      _PartialFreeTextExerciseContentState();
}

class _PartialFreeTextExerciseContentState
    extends State<PartialFreeTextExerciseContent> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onAnswerChanged(_buildFullAnswer());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _buildFullAnswer() {
    final providedText = widget.data.displayText;
    final userInput = _controller.text;

    if (!providedText.contains('____')) {
      throw Exception('Could not find blanks when building sentence widgets');
    }

    return providedText.replaceAll('____', userInput);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: DesignSpacing.xl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBubbleWidget(text: widget.data.referenceText),
        PartialFreeTextWidget(
          partialText: widget.data.displayText,
          textEditingController: _controller,
        ),
      ],
    );
  }
}

// Select from blocks subtype widget
class PartialBlockBuildExerciseContent extends StatefulWidget {
  final CompleteSentenceExerciseData data;
  final Function(String) onAnswerChanged;

  const PartialBlockBuildExerciseContent({
    super.key,
    required this.data,
    required this.onAnswerChanged,
  });
  @override
  State<PartialBlockBuildExerciseContent> createState() =>
      _PartialBlockBuildExerciseContentState();
}

class _PartialBlockBuildExerciseContentState
    extends State<PartialBlockBuildExerciseContent> {
  List<String?> selectedBlocks = [];
  List<AvailableBlock> availableBlocks = [];

  @override
  void initState() {
    super.initState();
    _initializeAvailableBlocks();

    // Initialize selectedBlocks with nulls based on the number of blanks
    String displayText = widget.data.displayText;
    int blankCount = displayText
        .split(' ')
        .where((elem) => elem == '____')
        .length;
    selectedBlocks = List<String?>.filled(blankCount, null);
  }

  void _initializeAvailableBlocks() {
    widget.data.blocks!.shuffle();

    availableBlocks = widget.data.blocks!.map<AvailableBlock>((block) {
      return AvailableBlock(text: block);
    }).toList();
  }

  void _selectBlock(String block) {
    setState(() {
      // Find the first null position in selectedBlocks
      int? firstNullIndex;
      for (int i = 0; i < selectedBlocks.length; i++) {
        if (selectedBlocks[i] == null) {
          firstNullIndex = i;
          break;
        }
      }

      // If there's a null position, place the block there
      if (firstNullIndex != null) {
        selectedBlocks[firstNullIndex] = block;

        // Mark the block as selected in availableBlocks
        for (var availableBlock in availableBlocks) {
          if (availableBlock.text == block) {
            availableBlock.isSelected = true;
            break;
          }
        }
      }
    });
    _updateAnswer();
  }

  void _deselectBlock(int index) {
    setState(() {
      String? block = selectedBlocks[index];
      if (block != null) {
        selectedBlocks[index] = null;

        // Mark the block as not selected in availableBlocks
        for (var availableBlock in availableBlocks) {
          if (availableBlock.text == block) {
            availableBlock.isSelected = false;
            break;
          }
        }
      }
    });
    _updateAnswer();
  }

  void _updateAnswer() {
    String displayText = widget.data.displayText;
    List<String> parts = displayText.split('____');
    String fullAnswer = '';

    for (int i = 0; i < parts.length; i++) {
      fullAnswer += parts[i];
      if (i < selectedBlocks.length && selectedBlocks[i] != null) {
        fullAnswer += selectedBlocks[i]!;
      }
    }

    widget.onAnswerChanged(fullAnswer.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: DesignSpacing.xl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBubbleWidget(text: widget.data.referenceText),
        PartialBlockBuildWidget(
          textWithBlanks: widget.data.displayText,
          selectedBlocks: selectedBlocks,
          availableBlocks: availableBlocks,
          onSelectedBlockTap: _deselectBlock,
          onAvailableBlockTap: _selectBlock,
        ),
      ],
    );
  }
}
