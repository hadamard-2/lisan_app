import 'package:lisan_app/models/exercise_data.dart';

class SpeakingExerciseData extends ExerciseData {
  String targetText;
  double minConfidence;
  int maxRecordSeconds;

  SpeakingExerciseData({
    required super.id,
    required super.type,
    super.subtype,
    required super.instruction,
    required this.targetText,
    required this.minConfidence,
    required this.maxRecordSeconds,
  });

  factory SpeakingExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final scoring = data['scoring'] as Map<String, dynamic>;
    return SpeakingExerciseData(
      id: json['id'],
      type: json['type'],
      subtype: json['subtype'],
      instruction: json['instruction'],
      targetText: data['target_text'],
      minConfidence: scoring['min_confidence'],
      maxRecordSeconds: data['max_record_seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'subtype': subtype,
      'instruction': instruction,
      'data': {
        'target_text': targetText,
        'scoring': {'min_confidence': minConfidence},
        'max_record_seconds': maxRecordSeconds,
      },
    };
  }
}
