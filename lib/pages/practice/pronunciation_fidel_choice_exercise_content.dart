import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class PronunciationFidelChoiceExerciseContent extends StatefulWidget {
  const PronunciationFidelChoiceExerciseContent({super.key});

  @override
  State<PronunciationFidelChoiceExerciseContent> createState() =>
      _PronunciationFidelChoiceExerciseContentState();
}

class _PronunciationFidelChoiceExerciseContentState
    extends State<PronunciationFidelChoiceExerciseContent> {
  String? selectedAnswer;

  final List<String> characterOptions = ['ሁ', 'ሱ', 'ባ', 'ር'];

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
                'Select the correct character for "su"',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                  itemCount: characterOptions.length,
                  itemBuilder: (context, index) {
                    final character = characterOptions[index];
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
                              fontSize: 86,
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
