import 'package:flutter/material.dart';

import 'package:lisan_app/design/theme.dart';

import 'package:lisan_app/models/available_block.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/widgets/exercise/instruction_text.dart';
import 'package:lisan_app/widgets/exercise/partial_free_text_widget.dart';
import 'package:lisan_app/widgets/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/voice_choices_widget.dart';
import 'package:lisan_app/widgets/exercise/block_build_widget.dart';
import 'package:lisan_app/widgets/exercise/free_text_widget.dart';
import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';
import 'package:lisan_app/widgets/exercise/voice_bubble_widget.dart';

class ListeningExercise extends ExerciseWidget {
  @override
  final ListeningExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const ListeningExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
    super.isRequeued = false,
  }) : super(exerciseData: exerciseData);

  @override
  State<ListeningExercise> createState() => _ListeningExerciseState();

  @override
  ExerciseWidget copyWith({
    ListeningExerciseData? exerciseData,
    Function(String)? onAnswerChanged,
    bool? isRequeued,
    Key? key,
  }) {
    return ListeningExercise(
      key: key ?? this.key,
      exerciseData: exerciseData ?? this.exerciseData,
      onAnswerChanged: onAnswerChanged ?? this.onAnswerChanged,
      isRequeued: isRequeued ?? this.isRequeued,
    );
  }
}

class _ListeningExerciseState extends State<ListeningExercise> {
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

          InstructionText(instruction: instruction),
          const SizedBox(height: DesignSpacing.xxl),

          _renderExerciseContent(),
        ],
      ),
    );
  }

  Widget _renderExerciseContent() {
    switch (widget.exerciseData.subtype) {
      case 'choose_missing':
        return ChooseMissingExerciseContent(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'type_missing':
        return TypeMissingExerciseContent(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'free_text':
        return FreeTextListeningExerciseContent(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'block_build':
        return BlockBuildExerciseContent(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      default:
        throw Exception(
          'Unknown listening subtype: ${widget.exerciseData.subtype}',
        );
    }
  }
}

class BlockBuildExerciseContent extends StatefulWidget {
  final ListeningExerciseData exerciseData;
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
  PlaybackSpeed playbackSpeed = PlaybackSpeed.normal;

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
    return Column(
      spacing: DesignSpacing.xl,
      children: [
        VoiceBubbleWidget(
          audioUrl: widget.exerciseData.promptAudioUrl,
          playbackSpeed: playbackSpeed,
          onSpeedButtonPressed: () {
            setState(() {
              if (playbackSpeed == PlaybackSpeed.normal) {
                playbackSpeed = PlaybackSpeed.slow;
              } else {
                playbackSpeed = PlaybackSpeed.normal;
              }
            });
          },
        ),
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

class FreeTextListeningExerciseContent extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const FreeTextListeningExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<FreeTextListeningExerciseContent> createState() =>
      _FreeTextListeningExerciseContentState();
}

class _FreeTextListeningExerciseContentState
    extends State<FreeTextListeningExerciseContent> {
  final TextEditingController _controller = TextEditingController();
  PlaybackSpeed playbackSpeed = PlaybackSpeed.normal;

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
      spacing: DesignSpacing.xl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoiceBubbleWidget(
          audioUrl: widget.exerciseData.promptAudioUrl,
          playbackSpeed: playbackSpeed,
          onSpeedButtonPressed: () {
            setState(() {
              if (playbackSpeed == PlaybackSpeed.normal) {
                playbackSpeed = PlaybackSpeed.slow;
              } else {
                playbackSpeed = PlaybackSpeed.normal;
              }
            });
          },
        ),
        FreeTextWidget(
          textEditingController: _controller,
          hintText: 'Type the Amharic you hear',
        ),
      ],
    );
  }
}

class TypeMissingExerciseContent extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const TypeMissingExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<TypeMissingExerciseContent> createState() =>
      _TypeMissingExerciseContentState();
}

class _TypeMissingExerciseContentState
    extends State<TypeMissingExerciseContent> {
  late TextEditingController _controller;
  PlaybackSpeed playbackSpeed = PlaybackSpeed.normal;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onAnswerChanged(_controller.text);
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
      spacing: DesignSpacing.xl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoiceBubbleWidget(
          audioUrl: widget.exerciseData.promptAudioUrl,
          playbackSpeed: playbackSpeed,
          onSpeedButtonPressed: () {
            setState(() {
              if (playbackSpeed == PlaybackSpeed.normal) {
                playbackSpeed = PlaybackSpeed.slow;
              } else {
                playbackSpeed = PlaybackSpeed.normal;
              }
            });
          },
        ),
        PartialFreeTextWidget(
          partialText: widget.exerciseData.displayText!,
          textEditingController: _controller,
        ),
      ],
    );
  }
}

class ChooseMissingExerciseContent extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const ChooseMissingExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<ChooseMissingExerciseContent> createState() =>
      _ChooseMissingExerciseContentState();
}

class _ChooseMissingExerciseContentState
    extends State<ChooseMissingExerciseContent> {
  int _selectedOptionIndex = -1;

  @override
  void initState() {
    super.initState();
    widget.exerciseData.options!.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: DesignSpacing.xl,
      children: [
        TextBubbleWidget(
          text: widget.exerciseData.displayText!,
          audioUrl: widget.exerciseData.promptAudioUrl,
        ),

        VoiceChoicesWidget(
          options: widget.exerciseData.options!,
          selectedOptionIndex: _selectedOptionIndex,
          onOptionSelect: (index) {
            setState(() {
              _selectedOptionIndex = index;
            });

            widget.onAnswerChanged(
              widget.exerciseData.options![index]['id'].toString(),
            );
          },
        ),
      ],
    );
  }
}
