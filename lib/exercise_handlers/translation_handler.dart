import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';

class TranslationHandler implements ExerciseHandler {
  final TranslationExerciseData exerciseData;

  TranslationHandler(this.exerciseData);

  // will need to use levenshtein distance here (and other similar places)
  @override
  ExerciseResult validateAndGetFeedback(dynamic userAnswer) {
    final trimmedAnswer = userAnswer.trim();
    final isCorrect = exerciseData.correctAnswers.any(
      (answer) => answer.toLowerCase() == trimmedAnswer.toLowerCase(),
    );

    return ExerciseResult(
      isCorrect: isCorrect,
      feedbackMessage: isCorrect
          ? 'Excellent! Your translation is correct.'
          : 'Mistakes are lessons in disguise.',
      correctAnswer: _getCorrectAnswer(),
    );
  }

  String _getCorrectAnswer() => exerciseData.correctAnswers.first;
}
