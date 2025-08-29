import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/complete_sentence_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';

class CompleteSentenceExercise extends ExerciseWidget {
  final CompleteSentenceExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const CompleteSentenceExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  });

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
          if (widget.isRequeued)
            Row(
              children: [
                Icon(Icons.repeat_rounded, color: Colors.orange),
                SizedBox(width: DesignSpacing.sm),
                Text(
                  'PREVIOUS MISTAKE',
                  style: const TextStyle(
                    color: Colors.orange, // Or any suitable color
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: DesignSpacing.xxxl),
              ],
            ),

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
      case 'given_start':
        return GivenStartWidget(
          data: widget.exerciseData,
          onAnswerChanged: _updateAnswer,
        );
      case 'given_end':
        return GivenEndWidget(
          data: widget.exerciseData,
          onAnswerChanged: _updateAnswer,
        );
      case 'select_from_blocks':
        return SelectFromBlocksWidget(
          data: widget.exerciseData,
          onAnswerChanged: _updateAnswer,
        );
      default:
        return const Center(
          child: Text(
            'Unknown exercise subtype',
            style: TextStyle(color: DesignColors.error),
          ),
        );
    }
  }
}

// NOTE - GivenStartWiget & GivenEndWidget can be merged together
// Given start subtype widget
class GivenStartWidget extends StatefulWidget {
  final CompleteSentenceExerciseData data;
  final Function(String) onAnswerChanged;

  const GivenStartWidget({
    super.key,
    required this.data,
    required this.onAnswerChanged,
  });

  @override
  State<GivenStartWidget> createState() => _GivenStartWidgetState();
}

class _GivenStartWidgetState extends State<GivenStartWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final fullAnswer = '${widget.data.providedText} ${_controller.text}';
      widget.onAnswerChanged(fullAnswer);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Text(
            widget.data.targetSentence,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: DesignSpacing.xl),

        // Sentence with inline text field
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // Provided text
              Text(
                widget.data.providedText!,
                style: const TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 16,
                ),
              ),

              // Inline text field for the blank
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DesignColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 4, bottom: 12),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Given end subtype widget
class GivenEndWidget extends StatefulWidget {
  final CompleteSentenceExerciseData data;
  final Function(String) onAnswerChanged;

  const GivenEndWidget({
    super.key,
    required this.data,
    required this.onAnswerChanged,
  });

  @override
  State<GivenEndWidget> createState() => _GivenEndWidgetState();
}

class _GivenEndWidgetState extends State<GivenEndWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      final fullAnswer = '${_controller.text} ${widget.data.providedText}';
      widget.onAnswerChanged(fullAnswer);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Text(
            widget.data.targetSentence,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: DesignSpacing.xl),

        // Sentence with inline text field
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(DesignSpacing.md),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // Inline text field for the blank
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DesignColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 4, bottom: 12),
                    isDense: true,
                  ),
                ),
              ),

              // Provided text
              Text(
                widget.data.providedText!,
                style: const TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Select from blocks subtype widget
class SelectFromBlocksWidget extends StatefulWidget {
  final CompleteSentenceExerciseData data;
  final Function(String) onAnswerChanged;

  const SelectFromBlocksWidget({
    super.key,
    required this.data,
    required this.onAnswerChanged,
  });
  @override
  State<SelectFromBlocksWidget> createState() => _SelectFromBlocksWidgetState();
}

class _SelectFromBlocksWidgetState extends State<SelectFromBlocksWidget> {
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
        // Character illustration placeholder
        Container(
          height: 120,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.pets, color: DesignColors.primary, size: 60),
          ),
        ),
        // Sentence with blanks and selected words
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
                    fontWeight: FontWeight.w600,
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
