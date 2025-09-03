import 'package:lisan_app/models/exercise_data.dart';

class TranslationExerciseData extends ExerciseData {
  String promptText;
  String? promptAudioUrl;
  List<String>? blocks; // for block build subtype
  String correctAnswer;

  TranslationExerciseData.blockBuild({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.promptText,
    this.promptAudioUrl,
    required this.blocks,
    required this.correctAnswer,
  });

  TranslationExerciseData.freeText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.promptText,
    this.promptAudioUrl,
    required this.correctAnswer,
  });

  factory TranslationExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return json['subtype'] == 'block_build'
        ? TranslationExerciseData.blockBuild(
            id: json['id'],
            type: json['type'],
            subtype: json['subtype'],
            instruction: json['instruction'],
            promptText: data['promptText'],
            promptAudioUrl: data['prompt_audio_url'] as String?,
            blocks: List<String>.from(data['blocks'] ?? []),
            correctAnswer: data['correct_answer'],
          )
        : TranslationExerciseData.freeText(
            id: json['id'],
            type: json['type'],
            subtype: json['subtype'],
            instruction: json['instruction'],
            promptText: data['promptText'],
            promptAudioUrl: data['prompt_audio_url'] as String?,
            correctAnswer: data['correct_answer'],
          );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'promptText': promptText,
      'correct_answer': correctAnswer,
    };
    if (promptAudioUrl != null) data['prompt_audio_url'] = promptAudioUrl;
    if (blocks != null) data['blocks'] = blocks;
    return {
      'id': id,
      'type': type,
      'subtype': subtype,
      'instruction': instruction,
      'data': data,
    };
  }
}
