import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';

class SpeakingHandler implements ExerciseHandler {
  final SpeakingExerciseData exerciseData;

  SpeakingHandler(this.exerciseData);

  @override
  ExerciseResult validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = _validate(userAnswer);

    return ExerciseResult(
      isCorrect: isCorrect,
      feedbackMessage: isCorrect
          ? 'Great pronunciation! You spoke clearly.'
          : 'Try speaking more clearly. Listen to the reference audio again.',
      correctAnswer: exerciseData.targetText,
    );
  }

  bool _validate(dynamic userAnswer) {
    if (userAnswer == null) return false;

    // userAnswer is transcribed text to compare
    if (userAnswer is String) {
      final targetText = exerciseData.targetText;
      return _normalizeText(userAnswer) == _normalizeText(targetText);
    }

    return false;
  }

  String _normalizeText(String text) {
    return text.toLowerCase().trim().replaceAll(RegExp(r'[^\w\s]'), '');
  }
}
