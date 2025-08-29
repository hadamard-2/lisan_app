import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class TranslationExercise extends StatefulWidget {
  final Map<String, dynamic> exerciseData;
  final Function(bool isCorrect) onAnswerChanged;

  const TranslationExercise({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });

  @override
  State<TranslationExercise> createState() => _TranslationExerciseState();
}

class _TranslationExerciseState extends State<TranslationExercise> {
  @override
  Widget build(BuildContext context) {
    final subtype = widget.exerciseData['subtype'] ?? 'free_text';
    final instruction = widget.exerciseData['instruction'] ?? '';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(DesignSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
  final Map<String, dynamic> exerciseData;
  final Function(bool isCorrect) onAnswerChanged;
  const BlockBuildWidget({
    super.key,
    required this.exerciseData,
    required this.onAnswerChanged,
  });
  @override
  State<BlockBuildWidget> createState() => _BlockBuildWidgetState();
}

class _BlockBuildWidgetState extends State<BlockBuildWidget> with TickerProviderStateMixin {
  List<String> selectedBlocks = [];
  List<AvailableBlock> availableBlocks = [];
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    final data = widget.exerciseData['data'] as Map<String, dynamic>;
    
    // Initialize available blocks as AvailableBlock objects
    availableBlocks = (data['blocks'] as List<dynamic>? ?? [])
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
    _validateAnswer();
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
    _validateAnswer();
  }
  
  void _validateAnswer() {
    final data = widget.exerciseData['data'] as Map<String, dynamic>;
    final correctSequences = data['correct_sequences'] as List<dynamic>?;
    
    if (correctSequences != null && selectedBlocks.isNotEmpty) {
      final isCorrect = correctSequences.any((sequence) {
        final correctSeq = List<String>.from(sequence);
        return _listEquals(selectedBlocks, correctSeq);
      });
      
      if (selectedBlocks.length == (data['blocks'] as List).length) {
        widget.onAnswerChanged(isCorrect);
      }
    }
  }
  
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
  
  @override
  Widget build(BuildContext context) {
    final data = widget.exerciseData['data'] as Map<String, dynamic>;
    final sourceText = data['source_text'] ?? '';
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
                Icons.volume_up,
                color: DesignColors.primary,
                size: 20,
              ),
              const SizedBox(width: DesignSpacing.sm),
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
          constraints: const BoxConstraints(minHeight: 80),
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
                            color: DesignColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            block,
                            style: const TextStyle(
                              color: DesignColors.backgroundDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
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
                        ? DesignColors.backgroundCard.withOpacity(0.5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: block.isSelected 
                          ? DesignColors.backgroundBorder.withOpacity(0.5)
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
  
  AvailableBlock({
    required this.text,
    this.isSelected = false,
  });
}

class FreeTextWidget extends StatefulWidget {
  final Map<String, dynamic> exerciseData;
  final Function(bool isCorrect) onAnswerChanged;

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
    _controller.addListener(_validateAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateAnswer() {
    final data = widget.exerciseData['data'] as Map<String, dynamic>;
    final correctAnswers = List<String>.from(data['correct_answers'] ?? []);
    final userInput = _controller.text.trim();
    
    final isCorrect = correctAnswers.any((answer) => 
      answer.toLowerCase() == userInput.toLowerCase()
    );
    
    if (userInput.isNotEmpty) {
      widget.onAnswerChanged(isCorrect);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.exerciseData['data'] as Map<String, dynamic>;
    final sourceText = data['source_text'] ?? '';

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
            sourceText,
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