import 'package:lisan_app/models/exercise_data.dart';

class FillInBlankExerciseData extends ExerciseData {
  final String sentenceWithPlaceholders;
  final List<String> options;
  final List<String> correctAnswers;

  FillInBlankExerciseData({
    required super.id,
    required super.type,
    required super.instruction,
    required this.sentenceWithPlaceholders,
    required this.options,
    required this.correctAnswers,
  }) : super(subtype: null);

  factory FillInBlankExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return FillInBlankExerciseData(
      id: json['id'],
      type: json['type'],
      instruction: json['instruction'],
      sentenceWithPlaceholders: data['sentence_with_placeholders'],
      options: List<String>.from(data['options']),
      correctAnswers: List<String>.from(data['correct_answers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'instruction': instruction,
      'data': {
        'sentence_with_placeholders': sentenceWithPlaceholders,
        'options': options,
        'correct_answers': correctAnswers,
      },
    };
  }
}
