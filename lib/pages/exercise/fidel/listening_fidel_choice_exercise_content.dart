import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class ListeningFidelChoiceExerciseContent extends StatefulWidget {
  const ListeningFidelChoiceExerciseContent({super.key});

  @override
  State<ListeningFidelChoiceExerciseContent> createState() =>
      _ListeningFidelChoiceExerciseContentState();
}

class _ListeningFidelChoiceExerciseContentState
    extends State<ListeningFidelChoiceExerciseContent> {
  String? selectedAnswer;

  final List<String> characterOptions = ['ሁ', 'ላ', 'ር', 'መ'];

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
