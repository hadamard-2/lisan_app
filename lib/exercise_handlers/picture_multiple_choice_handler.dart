import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/picture_multiple_choice_exercise_data.dart';

class PictureMultipleChoiceHandler implements ExerciseHandler {
  final PictureMultipleChoiceExerciseData exerciseData;

  PictureMultipleChoiceHandler(this.exerciseData);

  @override
  Future<ExerciseResult> validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = _validate(userAnswer);

    return Future.value(
      ExerciseResult(
        isCorrect: isCorrect,
        feedbackMessage: isCorrect
            ? 'Great! You selected the correct image.'
            : 'That\'s not quite right. Try again.',
        correctAnswer: _getCorrectAnswer(),
      ),
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

      final correctLabel = correctOption['label'] ?? '';
      return 'The correct answer is: $correctLabel';
    } catch (e) {
      // Handle case where correct option is not found
      return 'Unable to determine correct answer';
    }
  }
}
