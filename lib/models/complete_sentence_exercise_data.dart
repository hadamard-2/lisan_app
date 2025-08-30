import 'package:lisan_app/models/exercise_data.dart';

class CompleteSentenceExerciseData extends ExerciseData {
  final String targetSentence;
  String? providedText; // for given_start and given_end subtypes
  String? displayWithBlanks; // for select_from_blocks subtype
  List<String>? blocks; // for select_from_blocks subtype
  final List<String> correctAnswers;

  CompleteSentenceExerciseData.given({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.targetSentence,
    required this.providedText,
    required this.correctAnswers,
  });

  CompleteSentenceExerciseData.selectFromBlocks({
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
    if (subtype == 'given_start' || subtype == 'given_end') {
      return CompleteSentenceExerciseData.given(
        id: json['id'],
        type: json['type'],
        subtype: subtype,
        instruction: json['instruction'],
        targetSentence: data['target_sentence'],
        providedText: data['provided_text'],
        correctAnswers: List<String>.from(data['correct_answers']),
      );
    } else if (subtype == 'select_from_blocks') {
      return CompleteSentenceExerciseData.selectFromBlocks(
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
    if (displayWithBlanks != null)
      data['display_with_blanks'] = displayWithBlanks;
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
