import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lisan_app/pages/exercise/lesson_template.dart';
import 'package:lisan_app/pages/exercise/lesson_completion_page.dart';
import 'package:lisan_app/pages/exercise/translation_exercise.dart';
import 'package:lisan_app/pages/exercise/complete_sentence_exercise.dart';

import 'package:lisan_app/root_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Track answers for each exercise
  Map<int, dynamic> exerciseAnswers = {};

  // Exercise data
  final List<Map<String, dynamic>> exerciseData = [
        {
      "id": "tr_002",
      "type": "translation",
      "subtype": "block_build",
      "instruction": "Build the French translation from the blocks",
      "data": {
        "source_text": "They are different now.",
        "source_lang": "en",
        "target_lang": "fr",
        "blocks": ["Ils", "sont", "différents", "maintenant"],
        "correct_sequences": [
          ["Ils", "sont", "différents", "maintenant"],
        ],
      },
    },
    // {
    //   "id": "cs_001",
    //   "type": "complete_sentence",
    //   "subtype": "given_start",
    //   "instruction": "Complete the sentence",
    //   "data": {
    //     "provided_text": "Yesterday I went to",
    //     "correct_answers": [
    //       "Yesterday I went to the store",
    //       "Yesterday I went to school",
    //       "Yesterday I went to work",
    //       "Yesterday I went to the park",
    //     ],
    //   },
    // },
    // {
    //   "id": "cs_002",
    //   "type": "complete_sentence",
    //   "subtype": "given_end",
    //   "instruction": "Complete the beginning of this sentence",
    //   "data": {
    //     "provided_text": "is my favorite food",
    //     "correct_answers": [
    //       "Pizza is my favorite food",
    //       "Pasta is my favorite food",
    //       "Rice is my favorite food",
    //     ],
    //   },
    // },
    // {
    //   "id": "cs_003",
    //   "type": "complete_sentence",
    //   "subtype": "select_from_blocks",
    //   "instruction": "Fill in the blanks using the word blocks",
    //   "data": {
    //     "display_with_blanks": "The ____ is ____ in the sky",
    //     "blocks": ["sun", "shining", "moon", "bright", "bird", "flying"],
    //     "correct_answers": [
    //       "The sun is shining in the sky",
    //       "The moon is bright in the sky",
    //       "The bird is flying in the sky",
    //     ],
    //   },
    // },
  ];

  bool validateAnswer(int index) {
    final exercise = exerciseData[index];
    final userAnswer = exerciseAnswers[index];

    if (exercise['type'] == 'translation') {
      return userAnswer == true;
    } else if (exercise['type'] == 'complete_sentence') {
      if (userAnswer == null || userAnswer.toString().trim().isEmpty) {
        return false;
      }
      final correctAnswers =
          exercise['data']['correct_answers'] as List<dynamic>;
      final userAnswerLower = userAnswer.toString().toLowerCase().trim();
      return correctAnswers.any(
        (correctAnswer) =>
            correctAnswer.toString().toLowerCase().trim() == userAnswerLower,
      );
    }
    return false;
  }

  void _onTranslationAnswerChanged(int exerciseIndex, bool isCorrect) {
    setState(() {
      exerciseAnswers[exerciseIndex] = isCorrect;
    });
  }

  void _onCompleteSentenceAnswerChanged(int exerciseIndex, String answer) {
    setState(() {
      exerciseAnswers[exerciseIndex] = answer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lisan - Learn Amharic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFF1CC06),
          secondary: Color(0xFFF1CC06),
          surface: Color(0xFF1E2127),
          onPrimary: Color(0xFF14161B),
          onSecondary: Color(0xFF14161B),
          onSurface: Color(0xFFE4E4E7),
          error: Colors.red,
        ),
        scaffoldBackgroundColor: const Color(0xFF14161B),
        textTheme: GoogleFonts.rubikTextTheme(ThemeData.dark().textTheme),
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),

      home: LessonTemplate(
        exercises: exerciseData.asMap().entries.map((entry) {
          final index = entry.key;
          final exercise = entry.value;

          if (exercise['type'] == 'translation') {
            return TranslationExercise(
              exerciseData: exercise,
              onAnswerChanged: (isCorrect) =>
                  _onTranslationAnswerChanged(index, isCorrect),
            );
          } else if (exercise['type'] == 'complete_sentence') {
            return CompleteSentenceExercise(
              exerciseData: CompleteSentenceExerciseData(
                id: exercise['id'],
                type: exercise['type'],
                subtype: exercise['subtype'],
                instruction: exercise['instruction'],
                data: exercise['data'],
              ),
              onAnswerChanged: (answer) =>
                  _onCompleteSentenceAnswerChanged(index, answer),
            );
          }

          return Center(child: Text('Unknown exercise type'));
        }).toList(),

        onLessonCompletion: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LessonCompletionPage()),
        ),

        validateAnswer: (index) {
          final exercise = exerciseData[index];
          final userAnswer = exerciseAnswers[index];

          if (exercise['type'] == 'translation') {
            return userAnswer == true;
          } else if (exercise['type'] == 'complete_sentence') {
            if (userAnswer == null || userAnswer.toString().trim().isEmpty) {
              return false;
            }

            final correctAnswers =
                exercise['data']['correct_answers'] as List<dynamic>;
            final userAnswerLower = userAnswer.toString().toLowerCase().trim();

            return correctAnswers.any(
              (correctAnswer) =>
                  correctAnswer.toString().toLowerCase().trim() ==
                  userAnswerLower,
            );
          }

          return false;
        },

        getFeedbackMessage: (index) {
          final exercise = exerciseData[index];
          final userAnswer = exerciseAnswers[index];

          if (exercise['type'] == 'translation') {
            final isCorrect = userAnswer == true;
            if (isCorrect) {
              return 'Excellent! Your translation is correct.';
            } else {
              if (exercise['subtype'] == 'block_build') {
                return 'Try rearranging the blocks. Pay attention to word order.';
              } else {
                return 'Check your spelling and grammar. Try again!';
              }
            }
          } else if (exercise['type'] == 'complete_sentence') {
            if (validateAnswer(index)) {
              return 'Great job! Your sentence completion is correct.';
            } else {
              if (exercise['subtype'] == 'given_start') {
                return 'Think about what would naturally follow this beginning.';
              } else if (exercise['subtype'] == 'given_end') {
                return 'Consider what would make sense before this ending.';
              } else {
                return 'Try different word combinations to complete the sentence.';
              }
            }
          }

          return 'Try again!';
        },

        getCorrectAnswer: (index) {
          final exercise = exerciseData[index];

          if (exercise['type'] == 'translation') {
            final data = exercise['data'] as Map<String, dynamic>;
            if (exercise['subtype'] == 'free_text') {
              final correctAnswers = data['correct_answers'] as List<dynamic>;
              return correctAnswers.first.toString();
            } else {
              final correctSequences =
                  data['correct_sequences'] as List<dynamic>;
              final correctSequence = correctSequences.first as List<dynamic>;
              return correctSequence.join(' ');
            }
          } else if (exercise['type'] == 'complete_sentence') {
            final data = exercise['data'] as Map<String, dynamic>;
            final correctAnswers = data['correct_answers'] as List<dynamic>;
            return correctAnswers.first.toString();
          }

          return 'No correct answer available';
        },

        onExerciseRequeued: (exerciseIndex) {
          print('Exercise requeued for additional practice');
          setState(() {
            exerciseAnswers.remove(exerciseIndex);
          });
        },
      ),
    );
  }
}
