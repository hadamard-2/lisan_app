import 'package:lisan_app/exercise_handlers/translation_handler.dart';
import 'package:lisan_app/exercise_handlers/complete_sentence_handler.dart';
import 'package:lisan_app/exercise_handlers/fill_in_blank_handler.dart';
import 'package:lisan_app/exercise_handlers/speaking_handler.dart';
import 'package:lisan_app/exercise_handlers/listening_handler.dart';

import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';
import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';

class ExerciseHandlerFactory {
  static ExerciseHandler createHandler(Map<String, dynamic> exercise) {
    switch (exercise['type']) {
      case 'translation':
        return TranslationHandler(TranslationExerciseData.fromJson(exercise));
      case 'complete_sentence':
        return CompleteSentenceHandler(CompleteSentenceExerciseData.fromJson(exercise));
      case 'fill_in_blank':
        return FillInBlankHandler(FillInBlankExerciseData.fromJson(exercise));
      case 'speaking':
        return SpeakingHandler(SpeakingExerciseData.fromJson(exercise));
      case 'listening':
        return ListeningHandler(ListeningExerciseData.fromJson(exercise));
      default:
        throw Exception('Unknown exercise type: ${exercise['type']}');
    }
  }
}
