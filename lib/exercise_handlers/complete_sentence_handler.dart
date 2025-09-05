import 'package:lisan_app/models/complete_sentence_exercise_data.dart';
import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/utils/text_similarity.dart';

class CompleteSentenceHandler implements ExerciseHandler {
  final CompleteSentenceExerciseData exerciseData;

  CompleteSentenceHandler(this.exerciseData);

  @override
  Future<ExerciseResult> validateAndGetFeedback(dynamic userAnswer) {
    final trimmedAnswer = userAnswer.toString().trim();

    // Check similarity with the correct answer
    final similarity = TextSimilarity.calculateSimilarity(
      trimmedAnswer,
      exerciseData.correctAnswer,
    );

    if (similarity >= 90) {
      return Future.value(ExerciseResult(
        isCorrect: true,
        feedbackMessage: 'Great job!',
        correctAnswer: exerciseData.correctAnswer,
      ));
    }

    // Default feedback for incorrect answers
    return Future.value(ExerciseResult(
      isCorrect: false,
      feedbackMessage: trimmedAnswer.isEmpty
          ? 'Please complete the sentence.'
          : 'Not quite right. Try again!',
      correctAnswer: exerciseData.correctAnswer,
    ));
  }
}
