import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lisan_app/pages/exercise/lesson_template.dart';
import 'package:lisan_app/pages/exercise/lesson_completion_page.dart';
import 'package:lisan_app/pages/exercise/translation_exercise.dart';
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
  Map<int, bool> exerciseAnswers = {};

  // Exercise data
  final List<Map<String, dynamic>> exerciseData = [
    {
      "id": "tr_001",
      "type": "translation",
      "subtype": "free_text",
      "instruction": "Translate this sentence",
      "data": {
        "source_text": "I wanted to teach you Spanish.",
        "source_lang": "en",
        "target_lang": "fr",
        "correct_answers": ["Je voulais t'apprendre l'espagnol."],
      },
    },
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
    {
      "id": "tr_003",
      "type": "translation",
      "subtype": "block_build",
      "instruction": "Arrange these words to form the correct translation",
      "data": {
        "source_text": "The cat is sleeping.",
        "source_lang": "en",
        "target_lang": "es",
        "blocks": ["El", "gato", "está", "durmiendo"],
        "correct_sequences": [
          ["El", "gato", "está", "durmiendo"],
        ],
      },
    },
  ];

  void _onAnswerChanged(int exerciseIndex, bool isCorrect) {
    setState(() {
      exerciseAnswers[exerciseIndex] = isCorrect;
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

      // home: LessonTemplate(
      //   exercises: [
      //     Center(child: Text('Exercise 1 Placeholder')),
      //     Center(child: Text('Exercise 2 Placeholder')),
      //     Center(child: Text('Exercise 3 Placeholder')),
      //   ],
      //   onLessonCompletion: (context) => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => LessonCompletionPage()),
      //   ),
      //   validateAnswer: (index) => true,
      //   getFeedbackMessage: (index) => 'Feedback for exercise $index',
      //   getCorrectAnswer: (index) => 'Correct answer for exercise $index',
      //   onExerciseRequeued: (exercise) => print('Exercise requeued: $exercise'),
      // ),
      home: LessonTemplate(
        exercises: exerciseData.asMap().entries.map((entry) {
          final index = entry.key;
          final exercise = entry.value;

          return TranslationExercise(
            exerciseData: exercise,
            onAnswerChanged: (isCorrect) => _onAnswerChanged(index, isCorrect),
          );
        }).toList(),

        onLessonCompletion: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LessonCompletionPage()),
        ),

        validateAnswer: (index) {
          // Return true if the exercise has been answered correctly
          return exerciseAnswers[index] ?? false;
        },

        getFeedbackMessage: (index) {
          final isCorrect = exerciseAnswers[index] ?? false;
          final exercise = exerciseData[index];

          if (isCorrect) {
            return 'Excellent! Your translation is correct.';
          } else {
            if (exercise['subtype'] == 'block_build') {
              return 'Try rearranging the blocks. Pay attention to word order.';
            } else {
              return 'Check your spelling and grammar. Try again!';
            }
          }
        },

        getCorrectAnswer: (index) {
          final exercise = exerciseData[index];
          final data = exercise['data'] as Map<String, dynamic>;

          if (exercise['subtype'] == 'free_text') {
            final correctAnswers = data['correct_answers'] as List<dynamic>;
            return correctAnswers.first.toString();
          } else {
            final correctSequences = data['correct_sequences'] as List<dynamic>;
            final correctSequence = correctSequences.first as List<dynamic>;
            return correctSequence.join(' ');
          }
        },

        onExerciseRequeued: (exercise) {
          // Handle when an exercise is requeued (failed and needs to be tried again)
          print('Exercise requeued for additional practice');

          // Reset the answer for this exercise so user can try again
          setState(() {
            exerciseAnswers.remove(exercise);
          });
        },
      ),
    );
  }
}
