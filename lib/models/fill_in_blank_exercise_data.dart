import 'package:lisan_app/models/exercise_data.dart';

class FillInBlankExerciseData extends ExerciseData {
  final String displayText;
  final List<Map<String, dynamic>> options;
  final int correctOptionId;

  FillInBlankExerciseData({
    required super.id,
    required super.type,
    required super.instruction,
    required this.displayText,
    required this.options,
    required this.correctOptionId,
  }) : super(subtype: null);

  factory FillInBlankExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return FillInBlankExerciseData(
      id: json['id'],
      type: json['type'],
      instruction: json['instruction'],
      displayText: data['display_text'],
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
        'display_text': displayText,
        'options': options,
        'correct_option_id': correctOptionId,
      },
    };
  }
}
