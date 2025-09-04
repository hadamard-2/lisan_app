import 'dart:io';
import 'package:dio/dio.dart';
import 'package:lisan_app/models/exercise_result.dart';
import 'package:lisan_app/models/speaking_exercise_data.dart';
import 'package:lisan_app/utils/text_similarity.dart';

class SpeakingHandler implements ExerciseHandler {
  final SpeakingExerciseData exerciseData;
  static const double similarityThreshold = 0.75;
  static const String speechToTextUrl = 'http://localhost:8000/speech-to-text';

  late final Dio _dio;

  SpeakingHandler(this.exerciseData) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  @override
  Future<ExerciseResult> validateAndGetFeedback(dynamic userAnswer) async {
    try {
      final audioFilePath = userAnswer as String;
      final transcribedText = await _transcribeAudio(audioFilePath);

      await _deleteAudioFile(audioFilePath);

      final isCorrect = await _validate(transcribedText);

      return ExerciseResult(
        isCorrect: isCorrect,
        feedbackMessage: isCorrect
            ? 'Great pronunciation! You spoke clearly.'
            : 'Try speaking more clearly. Listen to the reference audio again.',
        correctAnswer: exerciseData.correctAnswer,
      );
    } catch (e) {
      // Clean up on error
      if (userAnswer is String) {
        await _deleteAudioFile(userAnswer);
      }

      return ExerciseResult(
        isCorrect: false,
        feedbackMessage: 'Unable to process your recording. Please try again.',
        correctAnswer: exerciseData.correctAnswer,
      );
    }
  }

  Future<String> _transcribeAudio(String audioFilePath) async {
    final formData = FormData.fromMap({
      'audio_file': await MultipartFile.fromFile(
        audioFilePath,
        filename: 'recording.wav',
      ),
    });

    final response = await _dio.post(speechToTextUrl, data: formData);

    if (response.statusCode == 200) {
      return response.data['transcription'] ?? '';
    } else {
      throw Exception('Failed to transcribe audio: ${response.statusCode}');
    }
  }

  Future<bool> _validate(String transcribedText) async {
    final cleanedTranscription = _cleanText(transcribedText);
    final cleanedCorrectAnswer = _cleanText(exerciseData.correctAnswer);

    final similarity = TextSimilarity.calculateSimilarity(
      cleanedTranscription,
      cleanedCorrectAnswer,
    );

    return similarity >= (similarityThreshold * 100);
  }

  String _cleanText(String text) {
    // Keep only Amharic characters (U+1200 - U+135A)
    return text.replaceAll(RegExp(r'[^\u1200-\u135A]', unicode: true), '');
  }

  Future<void> _deleteAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Log error but don't throw - file cleanup failure shouldn't break the flow
      print('Failed to delete audio file: $e');
    }
  }
}
