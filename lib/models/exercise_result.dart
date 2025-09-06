class ExerciseResult {
  final bool isCorrect;
  final String feedbackMessage;
  final String? correctAnswer;

  ExerciseResult({
    required this.isCorrect,
    required this.feedbackMessage,
    required this.correctAnswer,
  });
}

abstract class ExerciseHandler {
  Future<ExerciseResult> validateAndGetFeedback(dynamic userAnswer);
}
