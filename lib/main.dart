import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/exercise_handlers/exercise_handler_factory.dart';
import 'package:lisan_app/models/complete_sentence_data.dart';
import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';

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
  late List<ExerciseHandler> handlers;

  @override
  void initState() {
    super.initState();
    handlers = exerciseData.map(ExerciseHandlerFactory.createHandler).toList();
  }

  // Exercise data
  final List<Map<String, dynamic>> exerciseData = [
    // {
    //   "id": "tr_001",
    //   "type": "translation",
    //   "subtype": "block_build",
    //   "instruction": "Translate this sentence",
    //   "data": {
    //     "source_text": "The cat is sleeping under the table.",
    //     "source_lang": "en",
    //     "target_lang": "fr",
    //     "blocks": ["dort", "sous", "Le", "la", "table", "chat"],
    //     "correct_answers": ["Le chat dort sous la table"],
    //   },
    // },
    // {
    //   "id": "tr_002",
    //   "type": "translation",
    //   "subtype": "free_text",
    //   "instruction": "Translate this sentence",
    //   "data": {
    //     "source_text": "They are different now.",
    //     "source_lang": "en",
    //     "target_lang": "fr",
    //     "blocks": ["différents", "sont", "Ils", "maintenant"],
    //     "correct_answers": ["Ils sont différents maintenant"],
    //   },
    // },
    {
      "id": "cs_001",
      "type": "complete_sentence",
      "subtype": "given_start",
      "instruction": "Complete the sentence",
      "data": {
        "target_sentence": "Hier je suis allé au magasin",
        "provided_text": "Yesterday I went to",
        "correct_answers": ["Yesterday I went to the store"],
      },
    },
    {
      "id": "cs_002",
      "type": "complete_sentence",
      "subtype": "given_end",
      "instruction": "Complete the sentence",
      "data": {
        "target_sentence": "La pizza est ma nourriture préférée",
        "provided_text": "is my favorite food",
        "correct_answers": ["Pizza is my favorite food"],
      },
    },
    {
      "id": "cs_003",
      "type": "complete_sentence",
      "subtype": "select_from_blocks",
      "instruction": "Complete the sentence",
      "data": {
        "target_sentence": "Le soleil brille dans le ciel",
        "display_with_blanks": "The ____ is ____ in the sky",
        "blocks": ["sun", "shining", "moon", "bright", "bird", "flying"],
        "correct_answers": ["The sun is shining in the sky"],
      },
    },
  ];

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

          switch (exercise['type']) {
            case 'translation':
              return TranslationExercise(
                key: ValueKey(exercise['id']),
                exerciseData: TranslationExerciseData.fromJson(exercise),
                onAnswerChanged: (isCorrect) =>
                    _onTranslationAnswerChanged(index, isCorrect),
              );
            case 'complete_sentence':
              return CompleteSentenceExercise(
                key: ValueKey(exercise['id']),
                exerciseData: CompleteSentenceExerciseData.fromJson(exercise),
                onAnswerChanged: (answer) =>
                    _onCompleteSentenceAnswerChanged(index, answer),
              );
            default:
              return Center(child: Text('Unknown exercise type'));
          }
        }).toList(),

        onLessonCompletion: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LessonCompletionPage()),
        ),

        validateAnswer: (index) {
          final result = handlers[index].validateAndGetFeedback(
            exerciseAnswers[index],
          );
          return result.isCorrect;
        },

        getFeedbackMessage: (index) {
          final result = handlers[index].validateAndGetFeedback(
            exerciseAnswers[index],
          );
          return result.feedbackMessage;
        },

        getCorrectAnswer: (index) {
          final result = handlers[index].validateAndGetFeedback(
            exerciseAnswers[index],
          );
          return result.correctAnswer;
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
