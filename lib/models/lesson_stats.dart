class LessonStats {
  final List<String> correctExerciseIds;
  final List<String> skippedExerciseIds;
  final int xp;
  final Duration timeTaken;
  final double accuracy;
  final int remainingHearts;

  const LessonStats({
    required this.correctExerciseIds,
    required this.skippedExerciseIds,
    required this.xp,
    required this.timeTaken,
    required this.accuracy,
    required this.remainingHearts,
  });

  String get formattedTime {
    final hours = timeTaken.inHours;
    final minutes = timeTaken.inMinutes.remainder(60);
    final seconds = timeTaken.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get formattedAccuracy {
    return '${(accuracy * 100).round()}%';
  }

  Map<String, dynamic> toJson() {
    return {
      'correctExerciseIds': correctExerciseIds,
      'skippedExerciseIds': skippedExerciseIds,
      'xp': xp,
      'timeTakenSeconds': timeTaken.inSeconds,
      'accuracy': accuracy,
      'remainingHearts': remainingHearts,
    };
  }
}
