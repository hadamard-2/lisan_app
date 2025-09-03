import 'package:lisan_app/models/exercise_data.dart';

class CompleteSentenceExerciseData extends ExerciseData {
  final String targetSentence;
  String? providedText; // for partial_free_text subtype
  String? displayWithBlanks; // for partial_build_block subtype
  List<String>? blocks; // for partial_build_block subtype
  final List<String> correctAnswers;

  CompleteSentenceExerciseData.partialFreeText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.targetSentence,
    required this.providedText,
    required this.correctAnswers,
  });

  CompleteSentenceExerciseData.partialBlockBuild({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.targetSentence,
    required this.displayWithBlanks,
    required this.blocks,
    required this.correctAnswers,
  });

  factory CompleteSentenceExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final subtype = json['subtype'];
    if (subtype == 'partial_free_text') {
      return CompleteSentenceExerciseData.partialFreeText(
        id: json['id'],
        type: json['type'],
        subtype: subtype,
        instruction: json['instruction'],
        targetSentence: data['target_sentence'],
        providedText: data['provided_text'],
        correctAnswers: List<String>.from(data['correct_answers']),
      );
    } else if (subtype == 'partial_block_build') {
      return CompleteSentenceExerciseData.partialBlockBuild(
        id: json['id'],
        type: json['type'],
        subtype: subtype,
        instruction: json['instruction'],
        targetSentence: data['target_sentence'],
        displayWithBlanks: data['display_with_blanks'],
        blocks: List<String>.from(data['blocks'] ?? []),
        correctAnswers: List<String>.from(data['correct_answers']),
      );
    } else {
      throw UnsupportedError('Unknown subtype: $subtype');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'target_sentence': targetSentence,
      'correct_answers': correctAnswers,
    };
    if (providedText != null) data['provided_text'] = providedText;
    if (displayWithBlanks != null) {
      data['display_with_blanks'] = displayWithBlanks;
    }
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
