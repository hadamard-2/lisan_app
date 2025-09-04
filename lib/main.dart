import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lisan_app/exercise_handlers/exercise_handler_factory.dart';

import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';

import 'package:lisan_app/pages/exercise/fill_in_blank_exercise.dart';

import 'package:lisan_app/pages/exercise/lesson_template.dart';
import 'package:lisan_app/pages/exercise/lesson_completion_page.dart';
import 'package:lisan_app/pages/exercise/listening_exercise.dart';
import 'package:lisan_app/pages/exercise/speaking_exercise.dart';
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
  Map<String, dynamic> exerciseAnswers = {};
  late Map<String, ExerciseHandler> handlers;

  @override
  void initState() {
    super.initState();
    handlers = {};
    for (var exercise in exerciseData) {
      handlers[exercise['id']] = ExerciseHandlerFactory.createHandler(exercise);
    }
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
    //     "source_audio": "yellow",
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
    // {
    //   "id": "cs_001",
    //   "type": "complete_sentence",
    //   "subtype": "partial_free_text",
    //   "instruction": "Complete the sentence",
    //   "data": {
    //     "target_sentence": "Hier je suis allé au magasin",
    //     "provided_text": "Yesterday I went to ____",
    //     "correct_answers": ["Yesterday I went to the store"],
    //   },
    // },
    // {
    //   "id": "cs_002",
    //   "type": "complete_sentence",
    //   "subtype": "partial_free_text",
    //   "instruction": "Complete the sentence",
    //   "data": {
    //     "target_sentence": "La pizza est ma nourriture préférée",
    //     "provided_text": "____ is my favorite food",
    //     "correct_answers": ["Pizza is my favorite food"],
    //   },
    // },
    // {
    //   "id": "cs_003",
    //   "type": "complete_sentence",
    //   "subtype": "partial_block_build",
    //   "instruction": "Complete the sentence",
    //   "data": {
    //     "target_sentence": "Le soleil brille dans le ciel",
    //     "display_with_blanks": "The ____ is ____ in the sky",
    //     "blocks": ["sun", "shining", "moon", "bright", "bird", "flying"],
    //     "correct_answers": ["The sun is shining in the sky"],
    //   },
    // },
    // {
    //   "id": "fb_001",
    //   "type": "fill_in_blank",
    //   "instruction": "Fill in the blank",
    //   "data": {
    //     "sentence_with_placeholders": "Je ____",
    //     "options": ["mange du pain", "bois de l'eau", "lis un livre"],
    //     "correct_answers": ["Je mange du pain"],
    //   },
    // },
    // {
    //   "id": "fb_002",
    //   "type": "fill_in_blank",
    //   "instruction": "Fill in the blank",
    //   "data": {
    //     "sentence_with_placeholders": "____ est allé ____",
    //     "options": [
    //       "Il ... à l'école",
    //       "Elle ... au marché",
    //       "Nous ... au parc",
    //     ],
    //     "correct_answers": ["Il est allé à l'école"],
    //   },
    // },
    {
      "id": "sp_001",
      "type": "speaking",
      "instruction": "Speak this sentence",
      "data": {
        "target_text": "ሰላም እንዴት ነህ?",
        "audio_url": "https://cdn.example.com/audio/sp_001.mp3",
        "scoring": {"min_confidence": 0.7},
        "max_record_seconds": 8,
      },
    },
    // {
    //   "id": "ls_001",
    //   "type": "listening",
    //   "subtype": "omit_word_choose",
    //   "instruction": "Listen for the missing word",
    //   "data": {
    //     "audio_url": "https://cdn.example.com/audio/ls_001.mp3",
    //     "display_text": "እሱ ____ እየጠጣ ነው።",
    //     "options": [
    //       {
    //         "id": 1,
    //         "audio_url": "https://cdn.example.com/audio/ls_001_1.mp3",
    //         "text": "ነጭ",
    //       },
    //       {
    //         "id": 2,
    //         "audio_url": "https://cdn.example.com/audio/ls_001_2.mp3",
    //         "text": "ነጋ",
    //       },
    //     ],
    //     "correct_option_id": 1,
    //   },
    // },
    // {
    //   "id": "ls_001",
    //   "type": "listening",
    //   "subtype": "omit_word_type",
    //   "instruction": "Type the missing word",
    //   "data": {
    //     "audio_url": "https://cdn.example.com/audio/ls_001.mp3",
    //     "display_text": "እሱ ____ እየጠጣ ነው።",
    //     "correct_answers": ["ነጭ"],
    //   },
    // },
    // {
    //   "id": "ls_003",
    //   "type": "listening",
    //   "subtype": "free_text",
    //   "instruction": "Type what you hear",
    //   "data": {
    //     "audio_url": "https://cdn.example.com/audio/full_sentence.mp3",
    //     "correct_answers": ["እኔ በጣም ደስ ብሎኛል"],
    //   },
    // },
    // {
    //   "id": "ls_004",
    //   "type": "listening",
    //   "subtype": "block_build",
    //   "instruction": "Tap what you hear",
    //   "data": {
    //     "audio_url": "https://cdn.example.com/audio/ls_004.mp3",
    //     "blocks": ["በጣም", "ነኝ", "ጥሩ", "እኔ"],
    //     "correct_answers": ["እኔ በጣም ጥሩ ነኝ"],
    //   },
    // },
  ];

  void _onTranslationAnswerChanged(String exerciseId, String answer) {
    setState(() {
      exerciseAnswers[exerciseId] = answer;
    });
  }

  void _onCompleteSentenceAnswerChanged(String exerciseId, String answer) {
    setState(() {
      exerciseAnswers[exerciseId] = answer;
    });
  }

  void _onFillInBlankAnswerChanged(String exerciseId, int answer) {
    setState(() {
      exerciseAnswers[exerciseId] = answer;
    });
  }

  void _onSpeakingAnswerChanged(String exerciseId, String answer) {
    setState(() {
      exerciseAnswers[exerciseId] = answer;
    });
  }

  void _onListeningAnswerChanged(String exerciseId, String answer) {
    setState(() {
      exerciseAnswers[exerciseId] = answer;
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
          final exercise = entry.value;
          final exerciseId = exercise['id'];

          switch (exercise['type']) {
            case 'translation':
              return TranslationExercise(
                key: ValueKey(exercise['id']),
                exerciseData: TranslationExerciseData.fromJson(exercise),
                onAnswerChanged: (answer) =>
                    _onTranslationAnswerChanged(exerciseId, answer),
              );
            case 'complete_sentence':
              return CompleteSentenceExercise(
                key: ValueKey(exercise['id']),
                exerciseData: CompleteSentenceExerciseData.fromJson(exercise),
                onAnswerChanged: (answer) =>
                    _onCompleteSentenceAnswerChanged(exerciseId, answer),
              );
            case 'fill_in_blank':
              return FillInBlankExercise(
                key: ValueKey(exercise['id']),
                exerciseData: FillInBlankExerciseData.fromJson(exercise),
                onAnswerChanged: (answer) =>
                    _onFillInBlankAnswerChanged(exerciseId, answer),
              );
            case 'speaking':
              return SpeakingExercise(
                key: ValueKey(exercise['id']),
                exerciseData: SpeakingExerciseData.fromJson(exercise),
                onAnswerChanged: (answer) =>
                    _onSpeakingAnswerChanged(exerciseId, answer),
              );
            case 'listening':
              return ListeningExercise(
                key: ValueKey(exercise['id']),
                exerciseData: ListeningExerciseData.fromJson(exercise),
                onAnswerChanged: (answer) =>
                    _onListeningAnswerChanged(exerciseId, answer),
              );
            default:
              throw Exception('Unknown exercise type');
          }
        }).toList(),

        onLessonCompletion: (context) => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LessonCompletionPage()),
        ),

        validateAnswer: (String id) async {
          final result = await handlers[id]!.validateAndGetFeedback(
            exerciseAnswers[id],
          );
          return result.isCorrect;
        },

        getFeedbackMessage: (String id) async {
          final result = await handlers[id]!.validateAndGetFeedback(
            exerciseAnswers[id],
          );
          return result.feedbackMessage;
        },

        getCorrectAnswer: (String id) async {
          final result = await handlers[id]!.validateAndGetFeedback(
            exerciseAnswers[id],
          );
          return result.correctAnswer;
        },

        // Updated to accept ID
        onExerciseRequeued: (String id) {
          print('Exercise requeued for additional practice');
          setState(() {
            exerciseAnswers.remove(id);
          });
        },
      ),
    );
  }
}
