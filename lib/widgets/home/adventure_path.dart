import 'dart:math';
// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:lisan_app/design/theme.dart';

import 'package:lisan_app/models/lesson_node.dart';
import 'package:lisan_app/models/lesson_type.dart';
import 'package:lisan_app/models/match_pairs_exercise_data.dart';
import 'package:lisan_app/models/picture_multiple_choice_exercise_data.dart';
import 'package:lisan_app/models/unit_data.dart';

import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';

import 'package:lisan_app/exercise_handlers/exercise_handler_factory.dart';

import 'package:lisan_app/pages/exercise/fill_in_blank_exercise.dart';
import 'package:lisan_app/pages/exercise/lesson_template.dart';
import 'package:lisan_app/pages/exercise/lesson_completion_page.dart';
import 'package:lisan_app/pages/exercise/listening_exercise.dart';
import 'package:lisan_app/pages/exercise/match_pairs_lesson_template.dart';
import 'package:lisan_app/pages/exercise/picture_multiple_choice_exercise.dart';
import 'package:lisan_app/pages/exercise/speaking_exercise.dart';
import 'package:lisan_app/pages/exercise/translation_exercise.dart';
import 'package:lisan_app/pages/exercise/complete_sentence_exercise.dart';
// import 'package:lisan_app/services/auth_service.dart';

class AdventurePath extends StatefulWidget {
  final List<UnitData> units;
  final Animation<double> pathAnimation;
  final AnimationController pulseController;

  const AdventurePath({
    super.key,
    required this.units,
    required this.pathAnimation,
    required this.pulseController,
  });

  @override
  State<AdventurePath> createState() => _AdventurePathState();
}

class _AdventurePathState extends State<AdventurePath> {
  // Track answers for each exercise
  Map<String, dynamic> exerciseAnswers = {};
  Map<String, ExerciseResult?> exerciseResults = {};
  late Map<String, ExerciseHandler> handlers;

  // late final Dio _dio;

  // // Exercise data - now fetched from API
  // // List<Map<String, dynamic>>? exerciseData;
  // bool isLoading = true;

  // // Hardcoded lesson ID for now - replace with dynamic value from lesson tap
  // final String lessonId = 'dde8b8c5-cd62-4c34-b970-70f2b4218b85';

  final List<Map<String, dynamic>> exerciseData = [
    // --- Direct Translation ---
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
    // --- Picture Multiple Choice ---
    {
      "id": "pc_001",
      "type": "picture_multiple_choice",
      "subtype": "block_build",
      "instruction": "Select the correct image",
      "data": {
        "prompt_text": "በሬ",
        "options": [
          {
            'id': 0,
            'image_url': 'assets/images/picture_choice (1).png',
            'label': 'Cat',
          },
          {
            'id': 1,
            'image_url': 'assets/images/picture_choice (2).png',
            'label': 'Ox',
          },
          {
            'id': 2,
            'image_url': 'assets/images/picture_choice (3).png',
            'label': 'Dog',
          },
          {
            'id': 3,
            'image_url': 'assets/images/picture_choice (4).png',
            'label': 'Sheep',
          },
        ],
        "correct_option_id": 1,
      },
    },
  ];

  final List<Map<String, dynamic>> matchPairsExerciseData = [
    // --- Match Pairs ---
    {
      "id": "mp_lesson_001",
      "type": "matching_pairs",
      "subtype": "audio_text",
      "instruction": "Tap the matching pairs",
      "data": {
        "left_items": [
          {
            "id": "audio_1",
            "audio_url": "assets/mp_lesson_voices/mp_001_1.mp3",
          },
          {
            "id": "audio_2",
            "audio_url": "assets/mp_lesson_voices/mp_001_2.mp3",
          },
          {
            "id": "audio_3",
            "audio_url": "assets/mp_lesson_voices/mp_001_3.mp3",
          },
          {
            "id": "audio_4",
            "audio_url": "assets/mp_lesson_voices/mp_001_4.mp3",
          },
          {
            "id": "audio_5",
            "audio_url": "assets/mp_lesson_voices/mp_001_5.mp3",
          },
          {
            "id": "audio_6",
            "audio_url": "assets/mp_lesson_voices/mp_001_6.mp3",
          },
          {
            "id": "audio_7",
            "audio_url": "assets/mp_lesson_voices/mp_001_7.mp3",
          },
          {
            "id": "audio_8",
            "audio_url": "assets/mp_lesson_voices/mp_001_8.mp3",
          },
          {
            "id": "audio_9",
            "audio_url": "assets/mp_lesson_voices/mp_001_9.mp3",
          },
          {
            "id": "audio_10",
            "audio_url": "assets/mp_lesson_voices/mp_001_10.mp3",
          },
          {
            "id": "audio_11",
            "audio_url": "assets/mp_lesson_voices/mp_001_11.mp3",
          },
          {
            "id": "audio_12",
            "audio_url": "assets/mp_lesson_voices/mp_001_12.mp3",
          },
          {
            "id": "audio_13",
            "audio_url": "assets/mp_lesson_voices/mp_001_13.mp3",
          },
          {
            "id": "audio_14",
            "audio_url": "assets/mp_lesson_voices/mp_001_14.mp3",
          },
          {
            "id": "audio_15",
            "audio_url": "assets/mp_lesson_voices/mp_001_15.mp3",
          },
          {
            "id": "audio_16",
            "audio_url": "assets/mp_lesson_voices/mp_001_16.mp3",
          },
          {
            "id": "audio_17",
            "audio_url": "assets/mp_lesson_voices/mp_001_17.mp3",
          },
          {
            "id": "audio_18",
            "audio_url": "assets/mp_lesson_voices/mp_001_18.mp3",
          },
          {
            "id": "audio_19",
            "audio_url": "assets/mp_lesson_voices/mp_001_19.mp3",
          },
          {
            "id": "audio_20",
            "audio_url": "assets/mp_lesson_voices/mp_001_20.mp3",
          },
        ],
        "right_items": [
          {"id": "text_a", "text": "Chair"},
          {"id": "text_b", "text": "Table"},
          {"id": "text_c", "text": "Water"},
          {"id": "text_d", "text": "House"},
          {"id": "text_e", "text": "Milk"},
          {"id": "text_f", "text": "Book"},
          {"id": "text_g", "text": "Pencil"},
          {"id": "text_h", "text": "Door"},
          {"id": "text_i", "text": "Window"},
          {"id": "text_j", "text": "Bed"},
          {"id": "text_k", "text": "Food"},
          {"id": "text_l", "text": "Coffee"},
          {"id": "text_m", "text": "Tea"},
          {"id": "text_n", "text": "Car"},
          {"id": "text_o", "text": "Road"},
          {"id": "text_p", "text": "Tree"},
          {"id": "text_q", "text": "Flower"},
          {"id": "text_r", "text": "Sky"},
          {"id": "text_s", "text": "Sun"},
          {"id": "text_t", "text": "Moon"},
        ],
        "correct_pairs": [
          {"left_id": "audio_1", "right_id": "text_a"},
          {"left_id": "audio_2", "right_id": "text_b"},
          {"left_id": "audio_3", "right_id": "text_c"},
          {"left_id": "audio_4", "right_id": "text_d"},
          {"left_id": "audio_5", "right_id": "text_e"},
          {"left_id": "audio_6", "right_id": "text_f"},
          {"left_id": "audio_7", "right_id": "text_g"},
          {"left_id": "audio_8", "right_id": "text_h"},
          {"left_id": "audio_9", "right_id": "text_i"},
          {"left_id": "audio_10", "right_id": "text_j"},
          {"left_id": "audio_11", "right_id": "text_k"},
          {"left_id": "audio_12", "right_id": "text_l"},
          {"left_id": "audio_13", "right_id": "text_m"},
          {"left_id": "audio_14", "right_id": "text_n"},
          {"left_id": "audio_15", "right_id": "text_o"},
          {"left_id": "audio_16", "right_id": "text_p"},
          {"left_id": "audio_17", "right_id": "text_q"},
          {"left_id": "audio_18", "right_id": "text_r"},
          {"left_id": "audio_19", "right_id": "text_s"},
          {"left_id": "audio_20", "right_id": "text_t"},
        ],
      },
    },
    {
      "id": "mp_lesson_002",
      "type": "matching_pairs",
      "subtype": "text_text",
      "instruction": "Tap the matching pairs",
      "data": {
        "left_items": [
          {"id": "amharic_1", "text": "ቤት"},
          {"id": "amharic_2", "text": "ውሃ"},
          {"id": "amharic_3", "text": "ወተት"},
          {"id": "amharic_4", "text": "መጽሐፍ"},
          {"id": "amharic_5", "text": "ወንበር"},
          {"id": "amharic_6", "text": "ጠረጴዛ"},
          {"id": "amharic_7", "text": "እርሳስ"},
          {"id": "amharic_8", "text": "በር"},
          {"id": "amharic_9", "text": "መስኮት"},
          {"id": "amharic_10", "text": "አልጋ"},
          {"id": "amharic_11", "text": "ምግብ"},
          {"id": "amharic_12", "text": "ቡና"},
          {"id": "amharic_13", "text": "ሻይ"},
          {"id": "amharic_14", "text": "መኪና"},
          {"id": "amharic_15", "text": "መንገድ"},
          {"id": "amharic_16", "text": "ዛፍ"},
          {"id": "amharic_17", "text": "አበባ"},
          {"id": "amharic_18", "text": "ሰማይ"},
          {"id": "amharic_19", "text": "ፀሐይ"},
          {"id": "amharic_20", "text": "ጨረቃ"},
        ],
        "right_items": [
          {"id": "english_a", "text": "Pencil"},
          {"id": "english_b", "text": "House"},
          {"id": "english_c", "text": "Sun"},
          {"id": "english_d", "text": "Water"},
          {"id": "english_e", "text": "Car"},
          {"id": "english_f", "text": "Book"},
          {"id": "english_g", "text": "Chair"},
          {"id": "english_h", "text": "Road"},
          {"id": "english_i", "text": "Milk"},
          {"id": "english_j", "text": "Bed"},
          {"id": "english_k", "text": "Moon"},
          {"id": "english_l", "text": "Food"},
          {"id": "english_m", "text": "Window"},
          {"id": "english_n", "text": "Sky"},
          {"id": "english_o", "text": "Tea"},
          {"id": "english_p", "text": "Table"},
          {"id": "english_q", "text": "Coffee"},
          {"id": "english_r", "text": "Door"},
          {"id": "english_s", "text": "Flower"},
          {"id": "english_t", "text": "Tree"},
        ],
        "correct_pairs": [
          {"left_id": "amharic_1", "right_id": "english_b"},
          {"left_id": "amharic_2", "right_id": "english_d"},
          {"left_id": "amharic_3", "right_id": "english_i"},
          {"left_id": "amharic_4", "right_id": "english_f"},
          {"left_id": "amharic_5", "right_id": "english_g"},
          {"left_id": "amharic_6", "right_id": "english_p"},
          {"left_id": "amharic_7", "right_id": "english_a"},
          {"left_id": "amharic_8", "right_id": "english_r"},
          {"left_id": "amharic_9", "right_id": "english_m"},
          {"left_id": "amharic_10", "right_id": "english_j"},
          {"left_id": "amharic_11", "right_id": "english_l"},
          {"left_id": "amharic_12", "right_id": "english_q"},
          {"left_id": "amharic_13", "right_id": "english_o"},
          {"left_id": "amharic_14", "right_id": "english_e"},
          {"left_id": "amharic_15", "right_id": "english_h"},
          {"left_id": "amharic_16", "right_id": "english_t"},
          {"left_id": "amharic_17", "right_id": "english_s"},
          {"left_id": "amharic_18", "right_id": "english_n"},
          {"left_id": "amharic_19", "right_id": "english_c"},
          {"left_id": "amharic_20", "right_id": "english_k"},
        ],
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

  void _onPictureChoiceAnswerChanged(String exerciseId, int answer) {
    setState(() {
      exerciseAnswers[exerciseId] = answer;
    });
  }

  @override
  void initState() {
    super.initState();
    // _dio = Dio(
    //   BaseOptions(
    //     connectTimeout: const Duration(seconds: 30),
    //     receiveTimeout: const Duration(seconds: 30),
    //   ),
    // );
    // _fetchExerciseData();

    handlers = {};
    for (var exercise in exerciseData) {
      handlers[exercise['id']] = ExerciseHandlerFactory.createHandler(exercise);
    }
  }

  // Future<void> _fetchExerciseData() async {
  //   final String url =
  //       'http://insect-famous-ghastly.ngrok-free.app/api/lesson-service/exercises/lesson?lesson_id=$lessonId';
  //   final String? token = await AuthService.getAccessToken();

  //   try {
  //     final response = await _dio.post(
  //       url,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = response.data; // already decoded JSON
  //       setState(() {
  //         exerciseData = data.map((e) => e as Map<String, dynamic>).toList();
  //         isLoading = false;
  //         handlers = {};
  //         for (var exercise in exerciseData!) {
  //           handlers[exercise['id']] = ExerciseHandlerFactory.createHandler(
  //             exercise,
  //           );
  //         }
  //       });
  //     } else {
  //       // Handle error
  //       setState(() {
  //         exerciseData = [];
  //         isLoading = false;
  //       });
  //       print('Failed to load exercises: ${response.statusCode}');
  //     }
  //   } on DioException catch (e) {
  //     setState(() {
  //       exerciseData = [];
  //       isLoading = false;
  //     });
  //     print('Error fetching exercises: ${e.message}');
  //   }
  // }

  Widget renderMatchPairsLessonTemplate() {
    return MatchPairsLessonTemplate(
      exerciseData: MatchPairsExerciseData.fromJson(matchPairsExerciseData[0]),
      onLessonCompletion: (context, stats) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonCompletionPage(stats: stats),
        ),
      ),
      onExit: () => Navigator.pop(context),
      hearts: 5,
      itemsPerRound: 5,
    );
  }

  Widget renderLessonTemplate() {
    // if (isLoading || exerciseData == null) {
    //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
    // }

    return LessonTemplate(
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
          case 'picture_multiple_choice':
            return PictureMultipleChoiceExercise(
              key: ValueKey(exercise['id']),
              exerciseData: PictureMultipleChoiceExerciseData.fromJson(
                exercise,
              ),
              onAnswerChanged: (answer) =>
                  _onPictureChoiceAnswerChanged(exerciseId, answer),
            );
          default:
            throw Exception('Unknown exercise type');
        }
      }).toList(),

      onLessonCompletion: (context, stats) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LessonCompletionPage(stats: stats),
        ),
      ),

      validateAnswer: (String id) async {
        // Only call once and cache the result
        if (exerciseResults[id] == null) {
          exerciseResults[id] = await handlers[id]!.validateAndGetFeedback(
            exerciseAnswers[id],
          );
        }
        return exerciseResults[id]!.isCorrect;
      },

      getFeedbackMessage: (String id) async {
        // Use cached result
        if (exerciseResults[id] == null) {
          exerciseResults[id] = await handlers[id]!.validateAndGetFeedback(
            exerciseAnswers[id],
          );
        }
        return exerciseResults[id]!.feedbackMessage;
      },

      getCorrectAnswer: (String id) async {
        // Use cached result
        if (exerciseResults[id] == null) {
          exerciseResults[id] = await handlers[id]!.validateAndGetFeedback(
            exerciseAnswers[id],
          );
        }
        return exerciseResults[id]!.correctAnswer;
      },

      onExerciseRequeued: (String id) {
        print('Exercise requeued for additional practice');
        setState(() {
          exerciseAnswers.remove(id);
          exerciseResults.remove(id); // Clear cached result
        });
      },
    );
  }

  // Mathematical positioning for smooth curves
  double _getLessonOffset(int lessonIndex) {
    const double amplitude = -120.0;
    const double frequency = 1;
    return sin(lessonIndex * frequency) * amplitude;
  }

  Widget _buildUnitDivider(UnitData unit) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: DesignColors.backgroundBorder, thickness: 2),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: unit.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            unit.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Divider(color: DesignColors.backgroundBorder, thickness: 2),
        ),
      ],
    );
  }

  // TODO - maybe add a circular progress indicator (using percent_indicator package on pub.dev)
  Widget _buildLessonNode(LessonNode lesson, int globalIndex, Color unitColor) {
    final offset = _getLessonOffset(globalIndex);

    return Transform.translate(
      offset: Offset(offset, 0),
      child: Column(
        children: [
          _buildLessonCircle(lesson, unitColor),
          const SizedBox(height: 12),
          SizedBox(
            width: 120,
            child: Text(
              lesson.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: lesson.type == LessonType.locked
                    ? DesignColors.textTertiary
                    : Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCircle(LessonNode lesson, Color unitColor) {
    final baseColor = _getLessonCircleColor(lesson.type, unitColor);
    final size = 60.0;
    final shadowFactor = (lesson.type == LessonType.completed) ? 0.15 : 0.07;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Bottom layer (shadow/depth)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _darkenColor(baseColor, shadowFactor),
          ),
        ),
        // Top layer (main button surface)
        Transform.translate(
          offset: const Offset(0, -6),
          child: Material(
            shape: const CircleBorder(),
            color: baseColor,
            child: SizedBox(
              width: size,
              height: size,
              child: InkWell(
                onTap: () => _onLessonTap(lesson),
                customBorder: const CircleBorder(),
                child: Center(child: _getLessonIcon(lesson.type)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getLessonCircleColor(LessonType type, Color unitColor) {
    switch (type) {
      case LessonType.completed:
        return unitColor;
      case LessonType.current:
      case LessonType.locked:
        return DesignColors.backgroundCard;
    }
  }

  Widget _getLessonIcon(LessonType type) {
    switch (type) {
      case LessonType.completed:
        return const Icon(Icons.check_rounded, color: Colors.white, size: 28);
      case LessonType.current:
        return Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32);
      case LessonType.locked:
        return const Icon(
          Icons.lock_rounded,
          color: DesignColors.textTertiary,
          size: 24,
        );
    }
  }

  Color _darkenColor(Color color, double factor) {
    return HSLColor.fromColor(color)
        .withLightness(
          (HSLColor.fromColor(color).lightness - factor).clamp(0.0, 1.0),
        )
        .toColor();
  }

  void _onLessonTap(LessonNode lesson) {
    if (lesson.type == LessonType.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complete previous lessons to unlock!"),
          backgroundColor: DesignColors.textTertiary,
        ),
      );
    } else if (lesson.type == LessonType.current) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // builder: (context) => renderLessonTemplate(),
          builder: (context) => renderMatchPairsLessonTemplate(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pathWidgets = [];
    int globalLessonIndex = 0;

    for (int unitIndex = 0; unitIndex < widget.units.length; unitIndex++) {
      final unit = widget.units[unitIndex];

      // Unit divider
      pathWidgets.add(_buildUnitDivider(unit));
      pathWidgets.add(const SizedBox(height: 27));

      // Unit lessons
      for (
        int lessonIndex = 0;
        lessonIndex < unit.lessons.length;
        lessonIndex++
      ) {
        final lesson = unit.lessons[lessonIndex];

        pathWidgets.add(
          _buildLessonNode(lesson, globalLessonIndex, unit.color),
        );

        if (lessonIndex < unit.lessons.length - 1) {
          pathWidgets.add(const SizedBox(height: 48));
        }

        globalLessonIndex++;
      }

      // Add spacing between units
      if (unitIndex < widget.units.length - 1) {
        pathWidgets.add(const SizedBox(height: 48));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      child: Column(children: pathWidgets),
    );
  }
}
