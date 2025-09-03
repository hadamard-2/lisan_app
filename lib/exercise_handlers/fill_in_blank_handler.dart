import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/fill_in_blank_exercise_data.dart';

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
    return exerciseData.correctOptionId == userAnswer;
  }

  String _getCorrectAnswer() {
    try {
      final correctOption = exerciseData.options.firstWhere(
        (option) => option['id'] == exerciseData.correctOptionId,
      );

      final correctText = correctOption['text'] ?? '';
      String result = exerciseData.displayText;

      if (correctText.contains('...')) {
        // Handle multiple blanks (e.g., "እሷ ... አትክልት")
        final parts = correctText.split(' ... ');
        for (String part in parts) {
          result = result.replaceFirst('____', part);
        }
      } else {
        // Handle single blank
        result = result.replaceFirst('____', correctText);
      }

      return result;
    } catch (e) {
      // Handle case where correct option is not found
      return exerciseData.displayText;
    }
  }
}
