import 'package:lisan_app/models/exercise_data.dart';

class CompleteSentenceExerciseData extends ExerciseData {
  final String referenceText;
  String displayText; // for partial_free_text subtype
  List<String>? blocks; // for partial_build_block subtype
  final String correctAnswer;

  CompleteSentenceExerciseData.partialFreeText({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.referenceText,
    required this.displayText,
    required this.correctAnswer,
  });

  CompleteSentenceExerciseData.partialBlockBuild({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.referenceText,
    required this.displayText,
    required this.blocks,
    required this.correctAnswer,
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
        referenceText: data['reference_text'],
        displayText: data['display_text'],
        correctAnswer: data['correct_answer'],
      );
    } else if (subtype == 'partial_block_build') {
      return CompleteSentenceExerciseData.partialBlockBuild(
        id: json['id'],
        type: json['type'],
        subtype: subtype,
        instruction: json['instruction'],
        referenceText: data['reference_text'],
        displayText: data['display_text'],
        blocks: List<String>.from(data['blocks'] ?? []),
        correctAnswer: data['correct_answer'],
      );
    } else {
      throw UnsupportedError('Unknown subtype: $subtype');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'reference_text': referenceText,
      'display_text': displayText,
      'correct_answer': correctAnswer,
    };
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
