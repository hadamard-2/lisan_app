import 'package:lisan_app/models/exercise_data.dart';

class ListeningExerciseData extends ExerciseData {
  final String audioUrl;
  final String? displayText;
  final List<Map<String, dynamic>>?
  options; // For omit_word_choose: each map has 'id', 'audio_url', 'text'
  final int? correctOptionId; // For omit_word_choose
  final List<String>?
  correctAnswers; // For omit_word_type, free_text, block_build
  final List<String>? blocks; // For block_build
  final List<Map<String, dynamic>>?
  pairs; // For matching_audio_text: each map has 'left_id', 'left_audio', 'right_id', 'right_text'

  ListeningExerciseData.omitWordChoose({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.audioUrl,
    required this.displayText,
    required this.options,
    required this.correctOptionId,
  }) : correctAnswers = null,
       blocks = null,
       pairs = null;

  ListeningExerciseData.omitWordType({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.audioUrl,
    required this.displayText,
    required this.correctAnswers,
  }) : options = null,
       correctOptionId = null,
       blocks = null,
       pairs = null;

  ListeningExerciseData.freeText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.audioUrl,
    required this.correctAnswers,
  }) : displayText = null,
       options = null,
       correctOptionId = null,
       blocks = null,
       pairs = null;

  ListeningExerciseData.blockBuild({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.audioUrl,
    required this.blocks,
    required this.correctAnswers,
  }) : displayText = null,
       options = null,
       correctOptionId = null,
       pairs = null;

  ListeningExerciseData.matchingAudioText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.pairs,
  }) : audioUrl = '',
       displayText = null,
       options = null,
       correctOptionId = null,
       correctAnswers = null,
       blocks = null;

  factory ListeningExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final subtype = json['subtype'];
    switch (subtype) {
      case 'omit_word_choose':
        return ListeningExerciseData.omitWordChoose(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          audioUrl: data['audio_url'],
          displayText: data['display_text'],
          options: List<Map<String, dynamic>>.from(data['options']),
          correctOptionId: data['correct_option_id'],
        );
      case 'omit_word_type':
        return ListeningExerciseData.omitWordType(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          audioUrl: data['audio_url'],
          displayText: data['display_text'],
          correctAnswers: List<String>.from(data['correct_answers']),
        );
      case 'free_text':
        return ListeningExerciseData.freeText(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          audioUrl: data['audio_url'],
          correctAnswers: List<String>.from(data['correct_answers']),
        );
      case 'block_build':
        return ListeningExerciseData.blockBuild(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          audioUrl: data['audio_url'],
          blocks: List<String>.from(data['blocks']),
          correctAnswers: List<String>.from(data['correct_answers']),
        );
      case 'matching_audio_text':
        return ListeningExerciseData.matchingAudioText(
          id: json['id'],
          type: json['type'],
          subtype: json['subtype'],
          instruction: json['instruction'],
          pairs: List<Map<String, dynamic>>.from(data['pairs']),
        );
      default:
        throw UnsupportedError('Unknown subtype: $subtype');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'audio_url': audioUrl};
    if (displayText != null) data['display_text'] = displayText;
    if (options != null) data['options'] = options;
    if (correctOptionId != null) data['correct_option_id'] = correctOptionId;
    if (correctAnswers != null) data['correct_answers'] = correctAnswers;
    if (blocks != null) data['blocks'] = blocks;
    if (pairs != null) data['pairs'] = pairs;
    return {
      'id': id,
      'type': type,
      'subtype': subtype,
      'instruction': instruction,
      'data': data,
    };
  }
}
