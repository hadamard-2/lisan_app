import 'package:lisan_app/models/exercise_data.dart';

class MatchPairsExerciseData extends ExerciseData {
  final List<MatchItem> leftItems;
  final List<MatchItem> rightItems;
  final List<CorrectPair> correctPairs;

  MatchPairsExerciseData({
    required super.id,
    required super.type,
    required super.subtype,
    required super.instruction,
    required this.leftItems,
    required this.rightItems,
    required this.correctPairs,
  });

  factory MatchPairsExerciseData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return MatchPairsExerciseData(
      id: json['id'],
      type: json['type'],
      subtype: json['subtype'],
      instruction: json['instruction'],
      leftItems: (data['left_items'] as List)
          .map((item) => MatchItem.fromJson(item))
          .toList(),
      rightItems: (data['right_items'] as List)
          .map((item) => MatchItem.fromJson(item))
          .toList(),
      correctPairs: (data['correct_pairs'] as List)
          .map((pair) => CorrectPair.fromJson(pair))
          .toList(),
    );
  }
}

class MatchItem {
  final String id;
  final String? text;
  final String? audioUrl;

  MatchItem({required this.id, this.text, this.audioUrl});

  factory MatchItem.fromJson(Map<String, dynamic> json) {
    return MatchItem(
      id: json['id'],
      text: json['text'],
      audioUrl: json['audio_url'],
    );
  }
}

class CorrectPair {
  final String leftId;
  final String rightId;

  CorrectPair({required this.leftId, required this.rightId});

  factory CorrectPair.fromJson(Map<String, dynamic> json) {
    return CorrectPair(leftId: json['left_id'], rightId: json['right_id']);
  }
}
