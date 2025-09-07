class TextUtils {
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

  /// Determines if text is mostly Amharic characters
  static bool isAmharic(String text, {double threshold = 0.8}) {
    if (text.isEmpty) return false;

    final runes = text.runes;
    int total = 0;
    int amharicCount = 0;

    for (final rune in runes) {
      // skip spaces and control chars
      if (rune == 0x20 || rune == 0x0A || rune == 0x0D || rune == 0x09)
        continue;

      total++;

      // Ethiopic block: U+1200–U+137C
      if (rune >= 0x1200 && rune <= 0x137C) {
        amharicCount++;
      }
    }

    if (total == 0) return false;
    return amharicCount / total >= threshold;
  }

  /// Normalizes Amharic text by converging similar sounding letters
  static String normalizeAmharic(String text) {
    if (text.isEmpty) return text;

    String normalized = text;

    // H sounds: ሀ, ኀ -> ሐ
    final h1 = ["ሐ", "ሑ", "ሒ", "ሓ", "ሔ", "ሕ", "ሖ", "ሗ"];
    final h2 = ["ሀ", "ሁ", "ሂ", "ሃ", "ሄ", "ህ", "ሆ", "ሗ", "ሗ"];
    final h3 = ["ኀ", "ኁ", "ኂ", "ኃ", "ኄ", "ኅ", "ኆ", "ኇ", "ኋ"];

    // S sounds: ሠ -> ሰ
    final s1 = ["ሰ", "ሱ", "ሲ", "ሳ", "ሴ", "ስ", "ሶ", "ሷ"];
    final s2 = ["ሠ", "ሡ", "ሢ", "ሣ", "ሤ", "ሥ", "ሦ", "ሧ"];

    // Q sounds: ቐ -> ቀ
    final q1 = ["ቀ", "ቁ", "ቂ", "ቃ", "ቄ", "ቅ", "ቆ", "ቈ", "ቊ", "ቋ", "ቌ", "ቍ"];
    final q2 = ["ቐ", "ቑ", "ቒ", "ቓ", "ቔ", "ቕ", "ቖ", "ቘ", "ቚ", "ቛ", "ቜ", "ቝ"];

    // A sounds: ዐ -> አ
    final a1 = ["አ", "ኡ", "ኢ", "ኣ", "ኤ", "እ", "ኦ"];
    final a2 = ["ዐ", "ዑ", "ዒ", "ዓ", "ዔ", "ዕ", "ዖ"];

    // TS sounds: ፀ -> ጸ
    final ts1 = ["ጸ", "ጹ", "ጺ", "ጻ", "ጼ", "ጽ", "ጾ", "ጿ"];
    final ts2 = ["ፀ", "ፁ", "ፂ", "ፃ", "ፄ", "ፅ", "ፆ", "ጿ"];

    // Apply normalizations
    normalized = _replaceCharacters(normalized, h2, h1);
    normalized = _replaceCharacters(normalized, h3, h1);
    normalized = _replaceCharacters(normalized, s2, s1);
    normalized = _replaceCharacters(normalized, q2, q1);
    normalized = _replaceCharacters(normalized, a2, a1);
    normalized = _replaceCharacters(normalized, ts2, ts1);

    normalized = normalized.replaceAll('ሓ', 'ሐ');
    normalized = normalized.replaceAll('ኣ', 'አ');

    return normalized;
  }

  /// Helper method to replace characters from one list with corresponding characters from another
  static String _replaceCharacters(
    String text,
    List<String> from,
    List<String> to,
  ) {
    String result = text;
    for (int i = 0; i < from.length && i < to.length; i++) {
      result = result.replaceAll(from[i], to[i]);
    }
    return result;
  }

  /// Calculate similarity percentage based on Levenshtein distance
  static double calculateSimilarity(String answer, String correct) {
    if (answer.isEmpty && correct.isEmpty) return 100.0;
    if (answer.isEmpty || correct.isEmpty) return 0.0;

    // Normalize Amharic text instead of using lowercase
    final str1 = normalizeAmharic(answer);
    final str2 = normalizeAmharic(correct);

    final distance = levenshteinDistance(str1, str2);
    final maxLength = [
      str1.length,
      str2.length,
    ].reduce((a, b) => a > b ? a : b);
    return ((maxLength - distance) / maxLength) * 100;
  }
}
