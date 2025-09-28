import 'package:lisan_app/models/exercise_data.dart';

class PictureMultipleChoiceExerciseData extends ExerciseData {
  final String promptText;
  final String? audioUrl;
  final List<Map<String, dynamic>> options;
  final int correctOptionId;

  PictureMultipleChoiceExerciseData({
    required super.id,
    required super.type,
    required super.instruction,
    required this.promptText,
    this.audioUrl,
    required this.options,
    required this.correctOptionId,
  }) : super(subtype: null);

  factory PictureMultipleChoiceExerciseData.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = json['data'] as Map<String, dynamic>;
    return PictureMultipleChoiceExerciseData(
      id: json['id'],
      type: json['type'],
      instruction: json['instruction'],
      promptText: data['prompt_text'],
      audioUrl: data['audio_url'],
      options: List<Map<String, dynamic>>.from(data['options']),
      correctOptionId: data['correct_option_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'instruction': instruction,
      'data': {
        'prompt_text': promptText,
        'audio_url': audioUrl,
        'options': options,
        'correct_option_id': correctOptionId,
      },
    };
  }
}
