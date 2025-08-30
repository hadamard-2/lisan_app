import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';

class TranslationHandler implements ExerciseHandler {
  final TranslationExerciseData exerciseData;

  TranslationHandler(this.exerciseData);

  @override
  ExerciseResult validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = userAnswer == true;

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
