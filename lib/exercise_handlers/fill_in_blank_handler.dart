import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/fill_in_blank_data.dart';

class FillInBlankHandler implements ExerciseHandler {
  final FillInBlankExerciseData exerciseData;

  FillInBlankHandler(this.exerciseData);

  @override
  ExerciseResult validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = _validate(userAnswer);

    return ExerciseResult(
      isCorrect: isCorrect,
      feedbackMessage: isCorrect
          ? 'Excellent! You selected the correct word(s).'
          : 'Mistakes are lessons in disguise.',
      correctAnswer: _getCorrectAnswer(),
    );
  }

  bool _validate(dynamic userAnswer) {
    if (userAnswer.toString().isEmpty) return false;

    final userAnswerSplit = userAnswer.toString().split(' ... ');
    print('userAnswerSplit: $userAnswerSplit');

    String finalUserAnswer = exerciseData.sentenceWithPlaceholders;
    for (int i = 0; i < userAnswerSplit.length; i++) {
      finalUserAnswer = finalUserAnswer.replaceFirst(
        '____',
        userAnswerSplit[i],
      );
    }

    return exerciseData.correctAnswers.contains(finalUserAnswer);
  }

  String _getCorrectAnswer() {
    return exerciseData.correctAnswers.first;
  }
}
