import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
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

          // Instruction text
          Text(
            widget.exerciseData.instruction,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: DesignSpacing.xl),

          // Exercise content based on subtype
          _buildExerciseContent(),
        ],
      ),
    );
  }

  Widget _buildExerciseContent() {
    switch (widget.exerciseData.subtype) {
      case 'partial_free_text':
        return PartialFreeTextExerciseContent(
          data: widget.exerciseData,
          onAnswerChanged: _updateAnswer,
        );
      case 'block_build':
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
    final providedText = widget.data.providedText!;
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
        TextBubbleWidget(text: widget.data.targetSentence),
        PartialFreeTextWidget(
          partialText: widget.data.providedText!,
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
    String displayText = widget.data.displayWithBlanks!;
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
    String displayText = widget.data.displayWithBlanks!;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextBubbleWidget(text: widget.data.targetSentence),
        const SizedBox(height: DesignSpacing.xl),

        // Selected word blocks
        SizedBox(
          height: 200,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(DesignSpacing.md),
            decoration: BoxDecoration(
              color: DesignColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DesignColors.backgroundBorder),
            ),
            child: _buildSentenceWithBlanks(),
          ),
        ),
        const SizedBox(height: DesignSpacing.md),
        // Available word blocks
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.md),
          child: Wrap(
            spacing: DesignSpacing.sm,
            runSpacing: DesignSpacing.sm,
            children: availableBlocks.map((block) {
              return GestureDetector(
                onTap: block.isSelected ? null : () => _selectBlock(block.text),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSpacing.md,
                    vertical: DesignSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: block.isSelected
                        ? DesignColors.backgroundCard.withAlpha(
                            (0.5 * 255).toInt(),
                          )
                        : DesignColors.backgroundCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: block.isSelected
                          ? DesignColors.backgroundBorder.withAlpha(
                              (0.5 * 255).toInt(),
                            )
                          : DesignColors.backgroundBorder,
                    ),
                  ),
                  child: block.isSelected
                      ? Text(
                          block.text,
                          style: TextStyle(
                            color: DesignColors.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          block.text,
                          style: const TextStyle(
                            color: DesignColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSentenceWithBlanks() {
    String displayText = widget.data.displayWithBlanks!;
    List<String> parts = displayText.split('____');
    List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      // Add text part
      if (parts[i].isNotEmpty) {
        widgets.add(
          Text(
            parts[i],
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        );
      }

      // Add blank or selected word
      if (i < parts.length - 1) {
        if (i < selectedBlocks.length && selectedBlocks[i] != null) {
          widgets.add(
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSpacing.sm,
                vertical: DesignSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: DesignColors.primary.withAlpha((0.2 * 255).toInt()),
                borderRadius: BorderRadius.circular(4),
              ),
              child: GestureDetector(
                onTap: () => _deselectBlock(i),
                child: Text(
                  selectedBlocks[i]!,
                  style: const TextStyle(
                    color: DesignColors.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        } else {
          widgets.add(
            Container(
              width: 50,
              height: 2,
              color: DesignColors.textTertiary,
              margin: const EdgeInsets.only(top: 12, left: 5, right: 5),
            ),
          );
        }
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: widgets,
    );
  }
}

class AvailableBlock {
  final String text;
  bool isSelected;

  AvailableBlock({required this.text, this.isSelected = false});
}
