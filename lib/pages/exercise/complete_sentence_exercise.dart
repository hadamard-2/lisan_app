import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

// Exercise data model
class CompleteSentenceExerciseData {
  final String id;
  final String type;
  final String subtype;
  final String instruction;
  final Map<String, dynamic> data;

  CompleteSentenceExerciseData({
    required this.id,
    required this.type,
    required this.subtype,
    required this.instruction,
    required this.data,
  });
}

// Main complete sentence exercise widget
class CompleteSentenceExercise extends StatefulWidget {
  final CompleteSentenceExerciseData exerciseData;
  final Function(String) onAnswerChanged;

  const CompleteSentenceExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

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
          data: widget.exerciseData.data,
          onAnswerChanged: _updateAnswer,
        );
      case 'given_end':
        return GivenEndWidget(
          data: widget.exerciseData.data,
          onAnswerChanged: _updateAnswer,
        );
      case 'select_from_blocks':
        return SelectFromBlocksWidget(
          data: widget.exerciseData.data,
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

// Given start subtype widget
class GivenStartWidget extends StatefulWidget {
  final Map<String, dynamic> data;
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
      final fullAnswer = '${widget.data['provided_text']} ${_controller.text}';
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
            child: Icon(
              Icons.person_rounded,
              color: DesignColors.primary,
              size: 60,
            ),
          ),
        ),

        // Sentence with inline text field
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.md),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 10,
            children: [
              // Provided text
              Text(
                widget.data['provided_text'],
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
  final Map<String, dynamic> data;
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
      final fullAnswer = '${_controller.text} ${widget.data['provided_text']}';
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
            child: Icon(Icons.person, color: DesignColors.primary, size: 60),
          ),
        ),

        // Sentence with inline text field
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(DesignSpacing.md),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: DesignColors.backgroundBorder),
          ),
          child: Row(
            children: [
              // Inline text field for the blank
              SizedBox(
                width: 80, // Fixed width for the blank
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: DesignColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Provided text
              Text(
                widget.data['provided_text'],
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
  final Map<String, dynamic> data;
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
    String displayText = widget.data['display_with_blanks'];
    int blankCount = displayText
        .split(' ')
        .where((elem) => elem == '____')
        .length;
    selectedBlocks = List<String?>.filled(blankCount, null);
  }
  
  void _initializeAvailableBlocks() {
    availableBlocks = widget.data['blocks'].map<AvailableBlock>((block) {
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
    // Filter out null values when joining
    String answer = selectedBlocks.where((block) => block != null).join(' ');
    widget.onAnswerChanged(answer);
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
                        ? DesignColors.backgroundCard.withAlpha((0.5 * 255).toInt())
                        : DesignColors.backgroundCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: block.isSelected 
                          ? DesignColors.backgroundBorder.withAlpha((0.5 * 255).toInt())
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
    String displayText = widget.data['display_with_blanks'];
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
  
  AvailableBlock({
    required this.text,
    this.isSelected = false,
  });
}