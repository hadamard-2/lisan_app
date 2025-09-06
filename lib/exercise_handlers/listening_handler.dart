import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/listening_exercise_data.dart';
import 'package:lisan_app/utils/text_utils.dart';

class ListeningHandler implements ExerciseHandler {
  final ListeningExerciseData exerciseData;

  ListeningHandler(this.exerciseData);

  @override
  Future<ExerciseResult> validateAndGetFeedback(dynamic userAnswer) {
    final isCorrect = _validate(userAnswer);

    return Future.value(
      ExerciseResult(
        isCorrect: isCorrect,
        feedbackMessage: _getFeedbackMessage(isCorrect),
        correctAnswer: _getCorrectAnswer(),
      ),
    );
  }

  bool _validate(dynamic userAnswer) {
    if (userAnswer == null) return false;

    final subtype = exerciseData.subtype;

    switch (subtype) {
      case 'choose_missing':
        return _validateOptionSelection(userAnswer);

      case 'type_missing':
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
    return int.tryParse(userAnswer) == correctOptionId;
  }

  bool _validateTypedWord(dynamic userAnswer) {
    if (exerciseData.correctAnswer == null) return false;

    final userText = _cleanText(userAnswer.toString());
    final correctText = _cleanText(exerciseData.correctAnswer!);

    final similarity = TextUtils.calculateSimilarity(userText, correctText);
    return similarity >= 95; // Higher threshold for single words
  }

  bool _validateTypedSentence(dynamic userAnswer) {
    if (exerciseData.correctAnswer == null) return false;

    final userText = _cleanText(userAnswer.toString());
    final correctText = _cleanText(exerciseData.correctAnswer!);

    final similarity = TextUtils.calculateSimilarity(userText, correctText);
    return similarity >= 85; // Medium threshold for sentences
  }

  bool _validateBlockSequence(dynamic userAnswer) {
    if (exerciseData.correctAnswer == null) return false;

    final userText = _cleanText(userAnswer.toString());
    final correctText = _cleanText(exerciseData.correctAnswer!);

    return userText == correctText;
  }

  /// Cleans text by removing punctuation and normalizing whitespace
  /// Preserves Amharic characters (Unicode range U+1200-U+137F)
  String _cleanText(String text) {
    return text
        .replaceAll(
          RegExp(r'[^\w\s\u1200-\u137F]'),
          '',
        ) // Remove punctuation, keep Amharic and word characters
        .replaceAll(RegExp(r'\s+'), ' ') // Normalize whitespace
        .trim();
  }

  String _getFeedbackMessage(bool isCorrect) {
    if (isCorrect) {
      return 'Perfect! You understood the audio correctly.';
    }

    final subtype = exerciseData.subtype;
    switch (subtype) {
      case 'choose_missing':
        return 'You chose the incorrect voice to complete the sentence.';
      case 'type_missing':
        return 'The word you heard was different from what you typed.';
      case 'free_text':
        return 'The sentence you heard was different from what you typed.';
      case 'block_build':
        return 'The blocks needed to be arranged differently to match the audio.';
      default:
        return 'That wasn\'t quite right.';
    }
  }

  String? _getCorrectAnswer() {
    final subtype = exerciseData.subtype;

    switch (subtype) {
      case 'type_missing':
        final fullCorrectAnswer = exerciseData.displayText!.replaceFirst(
          '____',
          exerciseData.correctAnswer!,
        );
        return fullCorrectAnswer;
      case 'free_text':
      case 'block_build':
        return exerciseData.correctAnswer!;
      default:
        return null;
    }
  }
}
