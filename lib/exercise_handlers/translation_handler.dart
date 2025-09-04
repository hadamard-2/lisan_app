import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/translation_exercise_data.dart';
import 'package:lisan_app/utils/text_similarity.dart';

class TranslationHandler implements ExerciseHandler {
  final TranslationExerciseData exerciseData;

  TranslationHandler(this.exerciseData);

  @override
  Future<ExerciseResult> validateAndGetFeedback(dynamic userAnswer) {
    final trimmedAnswer = userAnswer.toString().trim();
    
    // Check similarity with the correct answer
    final similarityPercentage = TextSimilarity.calculateSimilarity(
      trimmedAnswer, 
      exerciseData.correctAnswer,
    );

    if (similarityPercentage >= 0.9) {
      return Future.value(ExerciseResult(
        isCorrect: true,
        feedbackMessage: 'Excellent! Your translation is correct.',
        correctAnswer: exerciseData.correctAnswer,
      ));
    }

    // Default feedback for incorrect answers
    return Future.value(ExerciseResult(
      isCorrect: false,
      feedbackMessage: trimmedAnswer.isEmpty 
          ? 'Please provide a translation.' 
          : 'Not quite right. Try again!',
      correctAnswer: exerciseData.correctAnswer,
    ));
  }
}