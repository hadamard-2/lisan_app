import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class FidelPronunciationChoiceExerciseContent extends StatefulWidget {
  const FidelPronunciationChoiceExerciseContent({super.key});

  @override
  State<FidelPronunciationChoiceExerciseContent> createState() =>
      _FidelPronunciationChoiceExerciseContentState();
}

class _FidelPronunciationChoiceExerciseContentState
    extends State<FidelPronunciationChoiceExerciseContent> {
  String? selectedAnswer;

  final List<String> options = ['ta', 'bi', 'hie'];

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
              // Question text
              Text(
                'What sound does this make?',
                style: TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSpacing.xxxl),

              // Character card
              Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: DesignColors.primary,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Text(
                      'ቢ',
                      style: TextStyle(
                        fontFamily: 'Neteru',
                        fontSize: 100,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: DesignSpacing.xxxl),

              // Answer options
              Row(
                children: options.map((option) {
                  final isSelected = selectedAnswer == option;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DesignSpacing.sm,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAnswer = option;
                          });
                        },
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? DesignColors.backgroundBorder
                                : DesignColors.backgroundCard,
                            border: Border.all(
                              color: isSelected
                                  ? DesignColors.textSecondary
                                  : DesignColors.backgroundBorder,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              option,
                              style: TextStyle(
                                color: DesignColors.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: DesignSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
