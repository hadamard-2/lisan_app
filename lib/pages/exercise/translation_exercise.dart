import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/block_build_widget.dart';
import 'package:lisan_app/widgets/exercise/free_text_widget.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';

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
            BlockBuildExerciseContent(
              exerciseData: widget.exerciseData,
              onAnswerChanged: widget.onAnswerChanged,
            )
          else
            FreeTextTranslationExerciseContent(
              exerciseData: widget.exerciseData,
              onAnswerChanged: widget.onAnswerChanged,
            ),
        ],
      ),
    );
  }
}

class BlockBuildExerciseContent extends StatefulWidget {
  final TranslationExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;
  const BlockBuildExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });
  @override
  State<BlockBuildExerciseContent> createState() =>
      _BlockBuildExerciseContentState();
}

class _BlockBuildExerciseContentState extends State<BlockBuildExerciseContent>
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

    return Column(
      spacing: DesignSpacing.xl,
      children: [
        TextBubbleWidget(text: data.sourceText, audioUrl: data.sourceAudio),
        BlockBuildWidget(
          selectedBlocks: selectedBlocks,
          availableBlocks: availableBlocks,
          onSelectedBlockTap: _deselectBlock,
          onAvailableBlockTap: _selectBlock,
        ),
      ],
    );
  }
}

class FreeTextTranslationExerciseContent extends StatefulWidget {
  final TranslationExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const FreeTextTranslationExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<FreeTextTranslationExerciseContent> createState() =>
      _FreeTextTranslationExerciseContentState();
}

class _FreeTextTranslationExerciseContentState
    extends State<FreeTextTranslationExerciseContent> {
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
        TextBubbleWidget(text: widget.exerciseData.sourceText),
        const SizedBox(height: DesignSpacing.xl),
        FreeTextWidget(
          textEditingController: _controller,
          hintText: 'Type your translation here...',
        ),
      ],
    );
  }
}
