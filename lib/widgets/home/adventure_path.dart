// import 'package:dio/dio.dart';
import 'dart:math';
import 'package:json5/json5.dart' as json5;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  List<Map<String, dynamic>> exerciseData = [];
  // List<Map<String, dynamic>> newExerciseData = [];
  List<Map<String, dynamic>> matchPairsExerciseData = [];

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

    _initializeData();
  }

  Future<void> _initializeData() async {
    exerciseData = await _loadData(
      'assets/data/exerciseData.json5',
      'exerciseData',
    );
    matchPairsExerciseData = await _loadData(
      'assets/data/matchPairsExerciseData.json5',
      'matchPairsExerciseData',
    );

    handlers = {};
    for (var exercise in exerciseData) {
      handlers[exercise['id']] = ExerciseHandlerFactory.createHandler(exercise);
    }

    // Trigger a rebuild after data is loaded
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<Map<String, dynamic>>> _loadData(
    String filePath,
    String key,
  ) async {
    try {
      final String jsonString = await rootBundle.loadString(filePath);
      final decoded = json5.json5Decode(jsonString);

      if (decoded is! Map || !decoded.containsKey(key)) {
        throw FormatException('Key "$key" not found in JSON file');
      }

      final data = decoded[key];
      if (data is! List) {
        throw FormatException('Expected a list for key "$key"');
      }

      return List<Map<String, dynamic>>.from(data);
    } on FlutterError catch (e) {
      print('Failed to load file: $filePath - ${e.message}');
      return [];
    } on FormatException catch (e) {
      print('JSON parsing error in $filePath: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error loading $filePath: $e');
      return [];
    }
  }

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
          builder: (context) => renderLessonTemplate(),
          // builder: (context) => renderMatchPairsLessonTemplate(),
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
