import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class PronunciationFidelChoiceExerciseContent extends StatefulWidget {
  final String pronunciation;
  final List<String> options;
  final String correctAnswer;

  const PronunciationFidelChoiceExerciseContent({
    super.key,
    required this.pronunciation,
    required this.options,
    required this.correctAnswer,
  });

  factory PronunciationFidelChoiceExerciseContent.fromJson(
    Map<String, dynamic> json,
  ) {
    return PronunciationFidelChoiceExerciseContent(
      pronunciation: json['pronunciation'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as String,
    );
  }

  @override
  State<PronunciationFidelChoiceExerciseContent> createState() =>
      _PronunciationFidelChoiceExerciseContentState();
}

class _PronunciationFidelChoiceExerciseContentState
    extends State<PronunciationFidelChoiceExerciseContent> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: DesignColors.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: DesignColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(DesignSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select the correct character for "${widget.pronunciation}"',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: DesignSpacing.xxxl),

              // Character options grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: DesignSpacing.md,
                    mainAxisSpacing: DesignSpacing.md,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: widget.options.length,
                  itemBuilder: (context, index) {
                    final character = widget.options[index];
                    final isSelected = selectedAnswer == character;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAnswer = character;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: DesignColors.backgroundCard,
                          border: Border.all(
                            color: isSelected
                                ? DesignColors.textSecondary
                                : DesignColors.backgroundBorder,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Center(
                          child: Text(
                            character,
                            style: TextStyle(
                              fontFamily: 'Neteru',
                              color: DesignColors.textPrimary,
                              fontSize: 60,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: DesignSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
