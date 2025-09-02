import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/pages/exercise/previous_mistake_indicator.dart';
import 'dart:math';

import 'package:lisan_app/widgets/exercise/text_bubble_widget.dart';

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
        return OmitWordChoose(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'omit_word_type':
        return GivenTextWidget(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'free_text':
        return FreeTextWidget(
          exerciseData: widget.exerciseData,
          onAnswerChanged: widget.onAnswerChanged,
        );
      case 'block_build':
        return BlockBuildWidget(
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

enum PlaybackSpeed { slow, normal }

class BlockBuildWidget extends StatefulWidget {
  final ListeningExerciseData exerciseData;
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
  PlaybackSpeed speed = PlaybackSpeed.normal;

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
    final audioUrl = data.audioUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Voice playback
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: DesignColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DesignColors.backgroundBorder),
              ),
              padding: const EdgeInsets.all(DesignSpacing.sm),
              child: IconButton(
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: DesignColors.primary,
                  size: 36,
                ),
                onPressed: () {
                  print('Playing voice');
                },
              ),
            ),
            const SizedBox(width: DesignSpacing.md),
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: DesignSpacing.sm,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = PlaybackSpeed.slow;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speed == PlaybackSpeed.slow
                            ? DesignColors.primary.withAlpha(30)
                            : Colors.transparent,
                        border: Border.all(
                          color: speed == PlaybackSpeed.slow
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Slow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: speed == PlaybackSpeed.slow
                              ? DesignColors.primary
                              : DesignColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = PlaybackSpeed.normal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speed == PlaybackSpeed.normal
                            ? DesignColors.primary.withAlpha(30)
                            : Colors.transparent,
                        border: Border.all(
                          color: speed == PlaybackSpeed.normal
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Normal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: speed == PlaybackSpeed.normal
                              ? DesignColors.primary
                              : DesignColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                    'Tap blocks below to build your sentence',
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
  final ListeningExerciseData exerciseData;
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
  PlaybackSpeed speed = PlaybackSpeed.slow;

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Voice playback
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: DesignColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DesignColors.backgroundBorder),
              ),
              padding: const EdgeInsets.all(DesignSpacing.sm),
              child: IconButton(
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: DesignColors.primary,
                  size: 36,
                ),
                onPressed: () {
                  print('Playing voice');
                },
              ),
            ),
            const SizedBox(width: DesignSpacing.md),
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: DesignSpacing.sm,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = PlaybackSpeed.slow;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speed == PlaybackSpeed.slow
                            ? DesignColors.primary.withAlpha(30)
                            : Colors.transparent,
                        border: Border.all(
                          color: speed == PlaybackSpeed.slow
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Slow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: speed == PlaybackSpeed.slow
                              ? DesignColors.primary
                              : DesignColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = PlaybackSpeed.normal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speed == PlaybackSpeed.normal
                            ? DesignColors.primary.withAlpha(30)
                            : Colors.transparent,
                        border: Border.all(
                          color: speed == PlaybackSpeed.normal
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Normal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: speed == PlaybackSpeed.normal
                              ? DesignColors.primary
                              : DesignColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
              hintText: 'Type your sentence here...',
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

class GivenTextWidget extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const GivenTextWidget({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<GivenTextWidget> createState() => _GivenTextWidgetState();
}

class _GivenTextWidgetState extends State<GivenTextWidget> {
  late TextEditingController _controller;
  PlaybackSpeed speed = PlaybackSpeed.normal;

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

    // Find the position of the blank (represented by ____) in the provided text
    if (providedText.contains('____')) {
      return providedText.replaceAll('____', userInput);
    }

    // Fallback for backward compatibility with start/end positioning
    return widget.exerciseData.subtype == 'given_start'
        ? '$providedText $userInput'
        : '$userInput $providedText';
  }

  List<Widget> _buildSentenceWidgets() {
    final providedText = widget.exerciseData.displayText!;

    // Check if the provided text contains a blank marker
    if (providedText.contains('____')) {
      return _buildSentenceWithInlineBlank(providedText);
    }

    throw Exception('Could not find blanks when building sentence widgets');
  }

  List<Widget> _buildSentenceWithInlineBlank(String providedText) {
    final parts = providedText.split('____');
    final widgets = <Widget>[];

    for (int i = 0; i < parts.length; i++) {
      // Add text part before the blank
      if (parts[i].isNotEmpty) {
        widgets.add(
          Text(
            parts[i],
            style: GoogleFonts.notoSansEthiopic(
              color: DesignColors.textPrimary,
              fontSize: 16,
            ),
          ),
        );
      }

      // Add text field for the blank (except after the last part)
      if (i < parts.length - 1) {
        widgets.add(
          SizedBox(
            width: 80, // Adjustable width
            child: TextField(
              controller: _controller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DesignColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.only(top: 12, bottom: 10),
                isDense: true,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: DesignColors.backgroundBorder),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: DesignColors.primary),
                ),
              ),
            ),
          ),
        );
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: DesignColors.backgroundCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: DesignColors.backgroundBorder),
              ),
              padding: const EdgeInsets.all(DesignSpacing.sm),
              child: IconButton(
                splashColor: Colors.transparent,
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: DesignColors.primary,
                  size: 36,
                ),
                onPressed: () {
                  print('Playing voice');
                },
              ),
            ),
            const SizedBox(width: DesignSpacing.md),
            SizedBox(
              width: 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: DesignSpacing.sm,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = PlaybackSpeed.slow;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speed == PlaybackSpeed.slow
                            ? DesignColors.primary.withAlpha(30)
                            : Colors.transparent,
                        border: Border.all(
                          color: speed == PlaybackSpeed.slow
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Slow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: speed == PlaybackSpeed.slow
                              ? DesignColors.primary
                              : DesignColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        speed = PlaybackSpeed.normal;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: speed == PlaybackSpeed.normal
                            ? DesignColors.primary.withAlpha(30)
                            : Colors.transparent,
                        border: Border.all(
                          color: speed == PlaybackSpeed.normal
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Normal',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: speed == PlaybackSpeed.normal
                              ? DesignColors.primary
                              : DesignColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: DesignSpacing.xl),

        // Sentence with inline text field
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.lg),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: _buildSentenceWidgets(),
          ),
        ),
      ],
    );
  }
}

class OmitWordChoose extends StatefulWidget {
  final ListeningExerciseData exerciseData;
  final Function(String answer) onAnswerChanged;

  const OmitWordChoose({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<OmitWordChoose> createState() => _OmitWordChooseState();
}

class _OmitWordChooseState extends State<OmitWordChoose> {
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
