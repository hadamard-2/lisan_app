import 'dart:math';
import 'package:flutter/material.dart';

import 'package:lisan_app/design/theme.dart';

import 'package:lisan_app/models/lesson_node.dart';
import 'package:lisan_app/models/lesson_type.dart';
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
import 'package:lisan_app/pages/exercise/speaking_exercise.dart';
import 'package:lisan_app/pages/exercise/translation_exercise.dart';
import 'package:lisan_app/pages/exercise/complete_sentence_exercise.dart';

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

  // Exercise data
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
  void initState() {
    super.initState();

    handlers = {};
    for (var exercise in exerciseData) {
      handlers[exercise['id']] = ExerciseHandlerFactory.createHandler(exercise);
    }
  }

  Widget renderLessonTemplate() {
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
    const double amplitude = -110.0;
    const double frequency = pi / 3;
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

  Widget _buildTreasureChest(int globalIndex, bool previousCompleted) {
    final offset = _getLessonOffset(globalIndex);
    final asset = previousCompleted
        ? 'assets/images/treasure_chest_open.png'
        : 'assets/images/treasure_chest_closed.png';

    final image = Image.asset(asset, width: 90, height: 90);

    return Transform.translate(
      offset: Offset(offset, 0),
      child: previousCompleted ? image : Opacity(opacity: 0.65, child: image),
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
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text("Starting: ${lesson.title}"),
      //     backgroundColor: DesignColors.primary,
      //   ),
      // );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => renderLessonTemplate()),
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

        // Add treasure chest after every 2nd lesson in each unit
        if (lessonIndex != 0 && lessonIndex % 2 == 0) {
          // Determine if the previous lesson was completed
          bool previousCompleted =
              unit.lessons[lessonIndex - 1].type == LessonType.completed;
          pathWidgets.add(
            _buildTreasureChest(globalLessonIndex, previousCompleted),
          );
          pathWidgets.add(const SizedBox(height: 27));
          globalLessonIndex++; // Increment for treasure chest position
        }

        pathWidgets.add(
          _buildLessonNode(lesson, globalLessonIndex, unit.color),
        );

        if (lessonIndex < unit.lessons.length - 1) {
          pathWidgets.add(const SizedBox(height: 32));
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
