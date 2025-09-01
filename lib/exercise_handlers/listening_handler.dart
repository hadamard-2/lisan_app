import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';

class ListeningHandler implements ExerciseHandler {
  final ListeningExerciseData exerciseData;

  ListeningHandler(this.exerciseData);

  @override
  ExerciseResult validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = _validate(userAnswer);

    return ExerciseResult(
      isCorrect: isCorrect,
      feedbackMessage: _getFeedbackMessage(isCorrect),
      correctAnswer: _getCorrectAnswer(),
    );
  }

  bool _validate(dynamic userAnswer) {
    if (userAnswer == null) return false;

    final subtype = exerciseData.subtype;

    switch (subtype) {
      case 'omit_word_choose':
        return _validateOptionSelection(userAnswer);

      case 'omit_word_type':
        return _validateTypedWord(userAnswer);

      case 'free_text':
        return _validateTypedSentence(userAnswer);

      case 'block_build':
        return _validateBlockSequence(userAnswer);

      default:
        return false;
    }
  }

  bool _validateOptionSelection(dynamic userAnswer) {
    final correctOptionId = exerciseData.correctOptionId;
    return userAnswer == correctOptionId;
  }

  bool _validateTypedWord(dynamic userAnswer) {
    final correctAnswers = exerciseData.correctAnswers;
    final userAnswerNormalized = userAnswer.toString().toLowerCase().trim();

    return correctAnswers!.any(
      (correct) =>
          correct.toString().toLowerCase().trim() == userAnswerNormalized,
    );
  }

  bool _validateTypedSentence(dynamic userAnswer) {
    final correctAnswers = exerciseData.correctAnswers;
    final userAnswerNormalized = userAnswer.toString().toLowerCase().trim();

    return correctAnswers!.any(
      (correct) =>
          correct.toString().toLowerCase().trim() == userAnswerNormalized,
    );
  }

  bool _validateBlockSequence(dynamic userAnswer) {
    if (userAnswer is! List) return false;

    final correctAnswer = exerciseData.correctAnswers!.first;
    final userSequence = userAnswer.join(' ').toLowerCase().trim();
    return userSequence == correctAnswer.toLowerCase().trim();
  }

  String _getFeedbackMessage(bool isCorrect) {
    if (isCorrect) {
      return 'Perfect! You understood the audio correctly.';
    }

    final subtype = exerciseData.subtype;
    switch (subtype) {
      case 'omit_word_choose':
        return 'Listen again and choose the word that fits best.';
      case 'omit_word_type':
        return 'Try typing exactly what you heard.';
      case 'free_text':
        return 'Try typing exactly what you heard.';
      case 'block_build':
        return 'Rearrange the blocks to match what you heard.';
      default:
        return 'Listen carefully and try again.';
    }
  }

  String _getCorrectAnswer() {
    final subtype = exerciseData.subtype;

    switch (subtype) {
      case 'omit_word_choose':
        final correctOptionId = exerciseData.correctOptionId;
        final options = exerciseData.options as List;
        final correctOption = options.firstWhere((opt) => opt['id'] == correctOptionId);
        return correctOption['text'];

      case 'omit_word_type':
      case 'free_text':
        final correctAnswers = exerciseData.correctAnswers;
        return correctAnswers!.first;

      case 'block_build':
        final correctAnswer = exerciseData.correctAnswers!.first;
        return correctAnswer;

      default:
        return 'No correct answer available';
    }
  }
}