import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';

class TranslationExercise extends ExerciseWidget {
  @override
  final TranslationExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const TranslationExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  }) : super(exerciseData: exerciseData);

  @override
  State<TranslationExercise> createState() => _TranslationExerciseState();

  @override
  ExerciseWidget copyWith({
    TranslationExerciseData? exerciseData,
    Function(String)? onAnswerChanged,
    bool? isRequeued,
    Key? key,
  }) {
    return TranslationExercise(
      key: key ?? this.key,
      exerciseData: exerciseData ?? this.exerciseData,
      onAnswerChanged: onAnswerChanged ?? this.onAnswerChanged,
      isRequeued: isRequeued ?? this.isRequeued,
    );
  }
}

class _TranslationExerciseState extends State<TranslationExercise> {
  @override
  Widget build(BuildContext context) {
    final subtype = widget.exerciseData.subtype;
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

          // Render appropriate subtype
          if (subtype == 'block_build')
            BlockBuildWidget(
              exerciseData: widget.exerciseData,
              onAnswerChanged: widget.onAnswerChanged,
            )
          else
            FreeTextWidget(
              exerciseData: widget.exerciseData,
              onAnswerChanged: widget.onAnswerChanged,
            ),
        ],
      ),
    );
  }
}

class BlockBuildWidget extends StatefulWidget {
  final TranslationExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;
  const BlockBuildWidget({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });
  @override
  State<BlockBuildWidget> createState() => _BlockBuildWidgetState();
}

class _BlockBuildWidgetState extends State<BlockBuildWidget>
    with TickerProviderStateMixin {
  List<String> selectedBlocks = [];
  List<AvailableBlock> availableBlocks = [];
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    final data = widget.exerciseData;
    data.blocks!.shuffle();

    // Initialize available blocks as AvailableBlock objects
    availableBlocks = (data.blocks ?? [])
        .map<AvailableBlock>((block) => AvailableBlock(text: block.toString()))
        .toList();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectBlock(String block) {
    setState(() {
      // Add block to selected blocks
      selectedBlocks.add(block);

      // Mark the block as selected in availableBlocks
      for (var availableBlock in availableBlocks) {
        if (availableBlock.text == block) {
          availableBlock.isSelected = true;
          break;
        }
      }
    });
    _animationController.forward().then((_) => _animationController.reset());
    _checkAndSubmitAnswer();
  }

  void _deselectBlock(String block, int index) {
    setState(() {
      // Remove block from selected blocks
      selectedBlocks.removeAt(index);

      // Mark the block as not selected in availableBlocks
      for (var availableBlock in availableBlocks) {
        if (availableBlock.text == block) {
          availableBlock.isSelected = false;
          break;
        }
      }
    });
    _checkAndSubmitAnswer();
  }

  void _checkAndSubmitAnswer() {
    if (widget.exerciseData.blocks != null) {
      widget.onAnswerChanged(selectedBlocks.join(' ')); // Pass raw answer
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.exerciseData;
    final sourceText = data.sourceText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source text bubble
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.volume_up_rounded,
                color: DesignColors.primary,
                size: 21,
              ),
              const SizedBox(width: DesignSpacing.md),
              Expanded(
                child: Text(
                  sourceText,
                  style: const TextStyle(
                    color: DesignColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DesignSpacing.xl),

        // Selected blocks area
        Container(
          width: double.infinity,
          height: 160,
          padding: const EdgeInsets.all(DesignSpacing.md),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: selectedBlocks.isEmpty
              ? const Center(
                  child: Text(
                    'Tap blocks below to build your translation',
                    style: TextStyle(
                      color: DesignColors.textTertiary,
                      fontSize: 14,
                    ),
                  ),
                )
              : Wrap(
                  spacing: DesignSpacing.sm,
                  runSpacing: DesignSpacing.sm,
                  children: selectedBlocks.asMap().entries.map((entry) {
                    final index = entry.key;
                    final block = entry.value;
                    return AnimatedScale(
                      scale: 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: GestureDetector(
                        onTap: () => _deselectBlock(block, index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DesignSpacing.md,
                            vertical: DesignSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: DesignColors.primary.withAlpha(
                              (0.2 * 255).toInt(),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            block,
                            style: const TextStyle(
                              color: DesignColors.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: DesignSpacing.xl),

        // Available blocks
        Wrap(
          spacing: DesignSpacing.sm,
          runSpacing: DesignSpacing.sm,
          children: availableBlocks.map((block) {
            return AnimatedScale(
              scale: 1.0,
              duration: const Duration(milliseconds: 200),
              child: GestureDetector(
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
                        : Colors.transparent,
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
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          block.text,
                          style: const TextStyle(
                            color: DesignColors.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class AvailableBlock {
  final String text;
  bool isSelected;

  AvailableBlock({required this.text, this.isSelected = false});
}

class FreeTextWidget extends StatefulWidget {
  final TranslationExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const FreeTextWidget({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<FreeTextWidget> createState() => _FreeTextWidgetState();
}

class _FreeTextWidgetState extends State<FreeTextWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_submitAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    final userInput = _controller.text.trim();
    if (userInput.isNotEmpty) {
      widget.onAnswerChanged(userInput); // Pass raw answer
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Source text bubble
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Text(
            widget.exerciseData.sourceText,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: DesignSpacing.xl),

        // Text input area
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 8,
            style: const TextStyle(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              hintText: 'Type your translation here...',
              hintStyle: TextStyle(
                color: DesignColors.textTertiary,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(DesignSpacing.lg),
            ),
          ),
        ),
      ],
    );
  }
}
