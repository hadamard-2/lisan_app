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
            promptText: data['source_text'],
            promptAudioUrl: data['source_audio'] as String?,
            blocks: List<String>.from(data['blocks'] ?? []),
            correctAnswer: data['correct_answers'],
          )
        : TranslationExerciseData.freeText(
            id: json['id'],
            type: json['type'],
            subtype: json['subtype'],
            instruction: json['instruction'],
            promptText: data['source_text'],
            promptAudioUrl: data['source_audio'] as String?,
            correctAnswer: data['correct_answers'],
          );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'source_text': promptText,
      'correct_answers': correctAnswer,
    };
    if (promptAudioUrl != null) data['source_audio'] = promptAudioUrl;
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
