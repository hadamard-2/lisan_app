import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class ListeningFidelChoiceExerciseContent extends StatefulWidget {
  final String audioAssetPath;
  final List<String> options;
  final String correctAnswer;

  const ListeningFidelChoiceExerciseContent({
    super.key,
    required this.audioAssetPath,
    required this.options,
    required this.correctAnswer,
  });

  factory ListeningFidelChoiceExerciseContent.fromJson(
    Map<String, dynamic> json,
  ) {
    return ListeningFidelChoiceExerciseContent(
      audioAssetPath: json['audio_asset_path'] as String,
      options: List<String>.from(json['options'] as List),
      correctAnswer: json['correct_answer'] as String,
    );
  }

  @override
  State<ListeningFidelChoiceExerciseContent> createState() =>
      _ListeningFidelChoiceExerciseContentState();
}

class _ListeningFidelChoiceExerciseContentState
    extends State<ListeningFidelChoiceExerciseContent> {
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
                'What do you hear?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: DesignSpacing.xl),

              // Audio button
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: DesignColors.primary,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.volume_up_rounded,
                      size: 60,
                      color: DesignColors.backgroundDark,
                    ),
                  ),
                ),
              ),

              SizedBox(height: DesignSpacing.xxl),

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
                              fontSize: 52,
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
