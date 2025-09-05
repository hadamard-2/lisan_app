bool isMostlyAmharic(String text, {double threshold = 0.8}) {
  if (text.isEmpty) return false;

  final runes = text.runes;
  int total = 0;
  int amharicCount = 0;

  for (final rune in runes) {
    // skip spaces and control chars
    if (rune == 0x20 || rune == 0x0A || rune == 0x0D || rune == 0x09) continue;

    total++;

    // Ethiopic block: U+1200–U+137C
    if (rune >= 0x1200 && rune <= 0x137C) {
      amharicCount++;
    }
  }

  if (total == 0) return false;
  return amharicCount / total >= threshold;
}
