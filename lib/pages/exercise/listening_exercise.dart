import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/partial_free_text_widget.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';
import 'package:lisan_app/widgets/exercise/block_build_widget.dart';
import 'package:lisan_app/widgets/exercise/free_text_widget.dart';
import 'dart:math';

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

          _renderSubtypeWidget(),
        ],
      ),
    );
  }

  Widget _renderSubtypeWidget() {
    switch (widget.exerciseData.subtype) {
      case 'omit_word_choose':
        return OmitWordChooseExerciseContent(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'omit_word_type':
        return PartialFreeTextExerciseContent(
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
          audioUrl: widget.exerciseData.audioUrl,
          playbackSpeed: playbackSpeed,
          onPlaybackButtonPressed: () {
            print('Playing voice');
          },
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
  PlaybackSpeed playbackSpeed = PlaybackSpeed.slow;

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
    final data = widget.exerciseData;
    final audioUrl = data.audioUrl;

    return Column(
      spacing: DesignSpacing.xl,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoiceBubbleWidget(
          audioUrl: widget.exerciseData.audioUrl,
          playbackSpeed: playbackSpeed,
          onPlaybackButtonPressed: () {
            print('Playing voice');
          },
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

class PartialFreeTextExerciseContent extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const PartialFreeTextExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<PartialFreeTextExerciseContent> createState() => _PartialFreeTextExerciseContentState();
}

class _PartialFreeTextExerciseContentState extends State<PartialFreeTextExerciseContent> {
  late TextEditingController _controller;
  PlaybackSpeed playbackSpeed = PlaybackSpeed.normal;

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
    final providedText = widget.exerciseData.displayText!;
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
        VoiceBubbleWidget(
          audioUrl: widget.exerciseData.audioUrl,
          playbackSpeed: playbackSpeed,
          onPlaybackButtonPressed: () {
            print('Playing voice');
          },
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

class OmitWordChooseExerciseContent extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const OmitWordChooseExerciseContent({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<OmitWordChooseExerciseContent> createState() => _OmitWordChooseExerciseContentState();
}

class _OmitWordChooseExerciseContentState extends State<OmitWordChooseExerciseContent> {
  int _selectedOptionIndex = -1;
  List<int> randInts = [];

  @override
  void initState() {
    super.initState();

    var random = Random();
    for (int i = 0; i < 2; i++) {
      randInts.add(1 + random.nextInt(7));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextBubbleWidget(
          text: widget.exerciseData.displayText!,
          audioUrl: widget.exerciseData.audioUrl,
        ),
        const SizedBox(height: DesignSpacing.xl),

        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.exerciseData.options!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedOptionIndex = index;
                });

                widget.onAnswerChanged(
                  widget.exerciseData.options![index]['id'].toString(),
                );
              },
              child: Container(
                width: double.infinity,
                height: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(DesignSpacing.md),
                margin: const EdgeInsets.only(bottom: DesignSpacing.sm),
                decoration: BoxDecoration(
                  color: _selectedOptionIndex == index
                      ? DesignColors.primary.withAlpha((0.05 * 255).toInt())
                      : Colors.transparent,
                  border: Border.all(
                    color: _selectedOptionIndex == index
                        ? DesignColors.primary
                        : DesignColors.backgroundBorder,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    Icon(Icons.volume_up_rounded, color: DesignColors.primary),
                    Image.asset(
                      'assets/images/waveform (${randInts[index]}).png',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
