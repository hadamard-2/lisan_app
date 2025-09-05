import 'package:lisan_app/models/exercise_data.dart';

class ListeningExerciseData extends ExerciseData {
  final String promptAudioUrl;
  final String? displayText;
  final List<Map<String, dynamic>>?
  options; // For choose_missing: each map has 'id', 'option_prompt_audio_url', 'text'
  final int? correctOptionId; // For choose_missing
  final List<String>? blocks; // For block_build
  final String? correctAnswer; // For type_missing, free_text, block_build

  ListeningExerciseData.chooseMissing({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.promptAudioUrl,
    required this.displayText,
    required this.options,
    required this.correctOptionId,
  }) : correctAnswer = null,
       blocks = null;

  ListeningExerciseData.typeMissing({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.promptAudioUrl,
    required this.displayText,
    required this.correctAnswer,
  }) : options = null,
       correctOptionId = null,
       blocks = null;

  ListeningExerciseData.freeText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.promptAudioUrl,
    required this.correctAnswer,
  }) : displayText = null,
       options = null,
       correctOptionId = null,
       blocks = null;

  ListeningExerciseData.blockBuild({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.promptAudioUrl,
    required this.blocks,
    required this.correctAnswer,
  }) : displayText = null,
       options = null,
       correctOptionId = null;

  factory ListeningExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final subtype = json['subtype'];
    switch (subtype) {
      case 'choose_missing':
        return ListeningExerciseData.chooseMissing(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          promptAudioUrl: data['prompt_audio_url'],
          displayText: data['display_text'],
          options: List<Map<String, dynamic>>.from(data['options']),
          correctOptionId: data['correct_option_id'],
        );
      case 'type_missing':
        return ListeningExerciseData.typeMissing(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          promptAudioUrl: data['prompt_audio_url'],
          displayText: data['display_text'],
          correctAnswer: data['correct_answer'],
        );
      case 'free_text':
        return ListeningExerciseData.freeText(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          promptAudioUrl: data['prompt_audio_url'],
          correctAnswer: data['correct_answer'],
        );
      case 'block_build':
        return ListeningExerciseData.blockBuild(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          promptAudioUrl: data['prompt_audio_url'],
          blocks: List<String>.from(data['blocks']),
          correctAnswer: data['correct_answer'],
        );
      default:
        throw UnsupportedError('Unknown subtype: $subtype');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'prompt_audio_url': promptAudioUrl};
    if (displayText != null) data['display_text'] = displayText;
    if (options != null) data['options'] = options;
    if (correctOptionId != null) data['correct_option_id'] = correctOptionId;
    if (correctAnswer != null) data['correct_answer'] = correctAnswer;
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
