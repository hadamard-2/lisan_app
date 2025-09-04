import 'package:lisan_app/models/exercise_data.dart';

class SpeakingExerciseData extends ExerciseData {
  final String promptText;
  final String promptAudioUrl;
  final String correctAnswer;

  SpeakingExerciseData({
    required super.id,
    required super.type,
    required super.instruction,
    required this.promptText,
    required this.promptAudioUrl,
    required this.correctAnswer,
  }) : super(subtype: null);

  factory SpeakingExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return SpeakingExerciseData(
      id: json['id'],
      type: json['type'],
      instruction: json['instruction'],
      promptText: data['prompt_text'],
      promptAudioUrl: data['prompt_audio_url'],
      correctAnswer: data['correct_answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'instruction': instruction,
      'data': {
        'prompt_text': promptText,
        'prompt_audio_url': promptAudioUrl,
        'correct_answer': correctAnswer,
      },
    };
  }
}
