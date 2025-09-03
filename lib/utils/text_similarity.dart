class TextSimilarity {
  /// Calculates the Levenshtein distance between two strings
  static int levenshteinDistance(String s1, String s2) {
    if (s1 == s2) return 0;
    if (s1.isEmpty) return s2.length;
    if (s2.isEmpty) return s1.length;

    final matrix = List.generate(
      s1.length + 1,
      (i) => List.filled(s2.length + 1, 0),
    );

    // Initialize first row and column
    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    // Fill the matrix
    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // deletion
          matrix[i][j - 1] + 1, // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// Calculate similarity percentage based on Levenshtein distance
  static double calculateSimilarity(String answer, String correct) {
    if (answer.isEmpty && correct.isEmpty) return 100.0;
    if (answer.isEmpty || correct.isEmpty) return 0.0;

    // NOTE - lowercase doesn't make any sense for Amharic, 
    // so I should instead converge similar sounding letters (fidel) in the future
    final str1 = answer.toLowerCase();
    final str2 = correct.toLowerCase();

    final distance = levenshteinDistance(str1, str2);
    final maxLength = [
      str1.length,
      str2.length,
    ].reduce((a, b) => a > b ? a : b);
    return ((maxLength - distance) / maxLength) * 100;
  }
}
