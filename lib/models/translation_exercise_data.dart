import 'package:lisan_app/models/exercise_data.dart';

class TranslationExerciseData extends ExerciseData {
  String sourceText;
  String? sourceAudio;
  String sourceLang;
  String targetLang;
  List<String>? blocks; // for block build subtype
  List<String> correctAnswers;

  TranslationExerciseData.blockBuild({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.sourceText,
    this.sourceAudio,
    required this.sourceLang,
    required this.targetLang,
    required this.blocks,
    required this.correctAnswers,
  });

  TranslationExerciseData.freeText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.sourceText,
    this.sourceAudio,
    required this.sourceLang,
    required this.targetLang,
    required this.correctAnswers,
  });

  factory TranslationExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return json['subtype'] == 'block_build'
        ? TranslationExerciseData.blockBuild(
            id: json['id'],
            type: json['type'],
            subtype: json['subtype'],
            instruction: json['instruction'],
            sourceText: data['source_text'],
            sourceAudio: data['source_audio'] as String?,
            sourceLang: data['source_lang'],
            targetLang: data['target_lang'],
            blocks: List<String>.from(data['blocks'] ?? []),
            correctAnswers: List<String>.from(data['correct_answers']),
          )
        : TranslationExerciseData.freeText(
            id: json['id'],
            type: json['type'],
            subtype: json['subtype'],
            instruction: json['instruction'],
            sourceText: data['source_text'],
            sourceAudio: data['source_audio'] as String?,
            sourceLang: data['source_lang'],
            targetLang: data['target_lang'],
            correctAnswers: List<String>.from(data['correct_answers']),
          );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'source_text': sourceText,
      'source_lang': sourceLang,
      'target_lang': targetLang,
      'correct_answers': correctAnswers,
    };
    if (sourceAudio != null) data['source_audio'] = sourceAudio;
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