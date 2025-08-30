import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/models/exercise_result.dart';

class CompleteSentenceHandler implements ExerciseHandler {
  final CompleteSentenceExerciseData exerciseData;

  CompleteSentenceHandler(this.exerciseData);

  @override
  ExerciseResult validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = _validate(userAnswer);

    return ExerciseResult(
      isCorrect: isCorrect,
      feedbackMessage: isCorrect
          ? 'Great job!'
          : 'Mistakes are lessons in disguise.',
      correctAnswer: _getCorrectAnswer(),
    );
  }

  bool _validate(dynamic userAnswer) {
    if (userAnswer == null || userAnswer.toString().trim().isEmpty) {
      return false;
    }

    final correctAnswers = exerciseData.correctAnswers;
    final userAnswerLower = userAnswer.toString().toLowerCase().trim();

    print(correctAnswers);
    print(userAnswerLower);

    return correctAnswers.any(
      (correctAnswer) =>
          correctAnswer.toString().toLowerCase().trim() == userAnswerLower,
    );
  }

  String _getCorrectAnswer() => exerciseData.correctAnswers.first;
}
