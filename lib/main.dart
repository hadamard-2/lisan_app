import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:lisan_app/exercise_handlers/exercise_handler_factory.dart';

import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';
import 'package:lisan_app/pages/auth/login_page.dart';

import 'package:lisan_app/pages/exercise/fill_in_blank_exercise.dart';

import 'package:lisan_app/pages/exercise/lesson_template.dart';
import 'package:lisan_app/pages/exercise/lesson_completion_page.dart';
import 'package:lisan_app/pages/exercise/listening_exercise.dart';
import 'package:lisan_app/pages/exercise/speaking_exercise.dart';
import 'package:lisan_app/pages/exercise/translation_exercise.dart';
import 'package:lisan_app/pages/exercise/complete_sentence_exercise.dart';
import 'package:lisan_app/pages/home_page.dart';

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
  Map<String, ExerciseResult?> exerciseResults = {};
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
    // // --- Direct Translation ---
    {
      "id": "tr_001",
      "type": "translation",
      "subtype": "block_build",
      "instruction": "Translate this sentence",
      "data": {
        "prompt_text": "ወንድሜ ከእህቴ ይረዝማል",
        "prompt_audio_url": "assets/sample_voices/tr_001.wav",
        "blocks": ["taller", "than", "My", "brother", "sister", "my", "is"],
        "correct_answer": "My brother is taller than my sister",
      },
    },
    {
      "id": "tr_002",
      "type": "translation",
      "subtype": "free_text",
      "instruction": "Translate this sentence",
      "data": {
        "prompt_text": "I love to read books.",
        "correct_answer": "መጽሐፍ ማንበብ እወዳለሁ።",
      },
    },

    // --- Complete Sentence ---
    {
      "id": "cs_001",
      "type": "complete_sentence",
      "subtype": "partial_free_text",
      "instruction": "Complete the sentence",
      "data": {
        "reference_text": "She is a doctor.",
        "display_text": "እሷ ____ ናት።",
        "correct_answer": "እሷ ሀኪም ናት።",
      },
    },
    {
      "id": "cs_002",
      "type": "complete_sentence",
      "subtype": "partial_block_build",
      "instruction": "Complete the sentence",
      "data": {
        "reference_text": "This beautiful flower smells good.",
        "display_text": "ይህ ____ አበባ ጥሩ ____ አለው።",
        "blocks": ["ቆንጆ", "መዓዛ", "ቀለም"],
        "correct_answer": "ይህ ቆንጆ አበባ ጥሩ መዓዛ አለው",
      },
    },

    // --- Fill in Blank ---
    {
      "id": "fb_001",
      "type": "fill_in_blank",
      "instruction": "Choose the correct word for the blank.",
      "data": {
        "display_text": "እኔ ____ እጠጣለሁ።",
        "options": [
          {"id": 0, "text": "ውሃ"},
          {"id": 1, "text": "ሽንኩርት"},
          {"id": 2, "text": "ወንበር"},
        ],
        "correct_option_id": 0,
      },
    },
    {
      "id": "fb_002",
      "type": "fill_in_blank",
      "instruction": "Select the pair that best fits the blanks.",
      "data": {
        "display_text": "____ ከገበያ ____ ገዛች።",
        "options": [
          {"id": 0, "text": "እሱ ... ቦርሳ"},
          {"id": 1, "text": "እሷ ... አትክልት"},
          {"id": 2, "text": "እነሱ ... ወተት"},
        ],
        "correct_option_id": 1,
      },
    },

    // --- Speaking ---
    {
      "id": "sp_001",
      "type": "speaking",
      "instruction": "Speak this sentence aloud",
      "data": {
        "prompt_text": "ሰላም እንዴት ነህ?",
        "prompt_audio_url": "assets/sample_voices/sp_001.wav",
        "correct_answer": "ሰላም እንዴት ነህ?",
      },
    },

    // --- Listening ---
    {
      "id": "ls_001",
      "type": "listening",
      "subtype": "choose_missing",
      "instruction": "Listen and choose the correct missing word.",
      "data": {
        "prompt_audio_url": "assets/sample_voices/ls_001.wav",
        "display_text": "እሷ ____ ትወዳለች።",
        "options": [
          {
            "id": 0,
            "option_audio_url": "assets/sample_voices/ls_001_1.wav",
            "text": "ቡና",
          },
          {
            "id": 1,
            "option_audio_url": "assets/sample_voices/ls_001_2.wav",
            "text": "ቃና",
          },
        ],
        "correct_option_id": 0,
      },
    },
    {
      "id": "ls_002",
      "type": "listening",
      "subtype": "type_missing",
      "instruction": "Listen and type the missing word.",
      "data": {
        "prompt_audio_url": "assets/sample_voices/ls_002.wav",
        "display_text": "ዛሬ በጣም ____ ነው።",
        "correct_answer": "ሞቃታማ",
      },
    },
    {
      "id": "ls_003",
      "type": "listening",
      "subtype": "free_text",
      "instruction": "Type what you hear",
      "data": {
        "prompt_audio_url": "assets/sample_voices/ls_003.wav",
        "correct_answer": "የት ነው ያለኸው አሁን?",
      },
    },
    {
      "id": "ls_004",
      "type": "listening",
      "subtype": "block_build",
      "instruction": "Tap what you hear",
      "data": {
        "prompt_audio_url": "assets/sample_voices/ls_004.wav",
        "blocks": ["እየሄድኩ", "ትምህርት", "ነው", "ቤት"],
        "correct_answer": "ትምህርት ቤት እየሄድኩ ነው",
      },
    },
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

      // home: LessonTemplate(
      //   exercises: exerciseData.asMap().entries.map((entry) {
      //     final exercise = entry.value;
      //     final exerciseId = exercise['id'];

      //     switch (exercise['type']) {
      //       case 'translation':
      //         return TranslationExercise(
      //           key: ValueKey(exercise['id']),
      //           exerciseData: TranslationExerciseData.fromJson(exercise),
      //           onAnswerChanged: (answer) =>
      //               _onTranslationAnswerChanged(exerciseId, answer),
      //         );
      //       case 'complete_sentence':
      //         return CompleteSentenceExercise(
      //           key: ValueKey(exercise['id']),
      //           exerciseData: CompleteSentenceExerciseData.fromJson(exercise),
      //           onAnswerChanged: (answer) =>
      //               _onCompleteSentenceAnswerChanged(exerciseId, answer),
      //         );
      //       case 'fill_in_blank':
      //         return FillInBlankExercise(
      //           key: ValueKey(exercise['id']),
      //           exerciseData: FillInBlankExerciseData.fromJson(exercise),
      //           onAnswerChanged: (answer) =>
      //               _onFillInBlankAnswerChanged(exerciseId, answer),
      //         );
      //       case 'speaking':
      //         return SpeakingExercise(
      //           key: ValueKey(exercise['id']),
      //           exerciseData: SpeakingExerciseData.fromJson(exercise),
      //           onAnswerChanged: (answer) =>
      //               _onSpeakingAnswerChanged(exerciseId, answer),
      //         );
      //       case 'listening':
      //         return ListeningExercise(
      //           key: ValueKey(exercise['id']),
      //           exerciseData: ListeningExerciseData.fromJson(exercise),
      //           onAnswerChanged: (answer) =>
      //               _onListeningAnswerChanged(exerciseId, answer),
      //         );
      //       default:
      //         throw Exception('Unknown exercise type');
      //     }
      //   }).toList(),

      //   onLessonCompletion: (context, stats) => Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => LessonCompletionPage(stats: stats)),
      //   ),

      //   validateAnswer: (String id) async {
      //     // Only call once and cache the result
      //     if (exerciseResults[id] == null) {
      //       exerciseResults[id] = await handlers[id]!.validateAndGetFeedback(
      //         exerciseAnswers[id],
      //       );
      //     }
      //     return exerciseResults[id]!.isCorrect;
      //   },

      //   getFeedbackMessage: (String id) async {
      //     // Use cached result
      //     if (exerciseResults[id] == null) {
      //       exerciseResults[id] = await handlers[id]!.validateAndGetFeedback(
      //         exerciseAnswers[id],
      //       );
      //     }
      //     return exerciseResults[id]!.feedbackMessage;
      //   },

      //   getCorrectAnswer: (String id) async {
      //     // Use cached result
      //     if (exerciseResults[id] == null) {
      //       exerciseResults[id] = await handlers[id]!.validateAndGetFeedback(
      //         exerciseAnswers[id],
      //       );
      //     }
      //     return exerciseResults[id]!.correctAnswer;
      //   },

      //   onExerciseRequeued: (String id) {
      //     print('Exercise requeued for additional practice');
      //     setState(() {
      //       exerciseAnswers.remove(id);
      //       exerciseResults.remove(id); // Clear cached result
      //     });
      //   },
      // ),
      home: LoginPage(),
    );
  }
}
