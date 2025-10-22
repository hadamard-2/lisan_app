import 'dart:math';
import 'dart:convert';

const List<List<Map<String, String>>> amharicAlphabet = [
  [
    {'geez': 'ሀ', 'roman': 'ha'},
    {'geez': 'ሁ', 'roman': 'hu'},
    {'geez': 'ሂ', 'roman': 'hi'},
    {'geez': 'ሃ', 'roman': 'haa'},
    {'geez': 'ሄ', 'roman': 'hie'},
    {'geez': 'ህ', 'roman': 'h'},
    {'geez': 'ሆ', 'roman': 'ho'},
  ],
  [
    {'geez': 'ለ', 'roman': 'le'},
    {'geez': 'ሉ', 'roman': 'lu'},
    {'geez': 'ሊ', 'roman': 'li'},
    {'geez': 'ላ', 'roman': 'la'},
    {'geez': 'ሌ', 'roman': 'lie'},
    {'geez': 'ል', 'roman': 'l'},
    {'geez': 'ሎ', 'roman': 'lo'},
  ],
  [
    {'geez': 'ሐ', 'roman': 'ha'},
    {'geez': 'ሑ', 'roman': 'hu'},
    {'geez': 'ሒ', 'roman': 'hi'},
    {'geez': 'ሓ', 'roman': 'haa'},
    {'geez': 'ሔ', 'roman': 'hie'},
    {'geez': 'ሕ', 'roman': 'h'},
    {'geez': 'ሖ', 'roman': 'ho'},
  ],
  [
    {'geez': 'መ', 'roman': 'me'},
    {'geez': 'ሙ', 'roman': 'mu'},
    {'geez': 'ሚ', 'roman': 'mi'},
    {'geez': 'ማ', 'roman': 'ma'},
    {'geez': 'ሜ', 'roman': 'mie'},
    {'geez': 'ም', 'roman': 'm'},
    {'geez': 'ሞ', 'roman': 'mo'},
  ],
  [
    {'geez': 'ሠ', 'roman': 'se'},
    {'geez': 'ሡ', 'roman': 'su'},
    {'geez': 'ሢ', 'roman': 'si'},
    {'geez': 'ሣ', 'roman': 'sa'},
    {'geez': 'ሤ', 'roman': 'sie'},
    {'geez': 'ሥ', 'roman': 's'},
    {'geez': 'ሦ', 'roman': 'so'},
  ],
  [
    {'geez': 'ረ', 'roman': 're'},
    {'geez': 'ሩ', 'roman': 'ru'},
    {'geez': 'ሪ', 'roman': 'ri'},
    {'geez': 'ራ', 'roman': 'ra'},
    {'geez': 'ሬ', 'roman': 'rie'},
    {'geez': 'ር', 'roman': 'r'},
    {'geez': 'ሮ', 'roman': 'ro'},
  ],
  [
    {'geez': 'ሰ', 'roman': 'se'},
    {'geez': 'ሱ', 'roman': 'su'},
    {'geez': 'ሲ', 'roman': 'si'},
    {'geez': 'ሳ', 'roman': 'sa'},
    {'geez': 'ሴ', 'roman': 'sie'},
    {'geez': 'ስ', 'roman': 's'},
    {'geez': 'ሶ', 'roman': 'so'},
  ],
  [
    {'geez': 'ሸ', 'roman': 'she'},
    {'geez': 'ሹ', 'roman': 'shu'},
    {'geez': 'ሺ', 'roman': 'shi'},
    {'geez': 'ሻ', 'roman': 'sha'},
    {'geez': 'ሼ', 'roman': 'shie'},
    {'geez': 'ሽ', 'roman': 'sh'},
    {'geez': 'ሾ', 'roman': 'sho'},
  ],
  [
    {'geez': 'ቀ', 'roman': 'Qe'},
    {'geez': 'ቁ', 'roman': 'Qu'},
    {'geez': 'ቂ', 'roman': 'Qi'},
    {'geez': 'ቃ', 'roman': 'Qa'},
    {'geez': 'ቄ', 'roman': 'Qie'},
    {'geez': 'ቅ', 'roman': 'Q'},
    {'geez': 'ቆ', 'roman': 'Qo'},
  ],
  [
    {'geez': 'በ', 'roman': 'be'},
    {'geez': 'ቡ', 'roman': 'bu'},
    {'geez': 'ቢ', 'roman': 'bi'},
    {'geez': 'ባ', 'roman': 'ba'},
    {'geez': 'ቤ', 'roman': 'bie'},
    {'geez': 'ብ', 'roman': 'b'},
    {'geez': 'ቦ', 'roman': 'bo'},
  ],
  [
    {'geez': 'ተ', 'roman': 'te'},
    {'geez': 'ቱ', 'roman': 'tu'},
    {'geez': 'ቲ', 'roman': 'ti'},
    {'geez': 'ታ', 'roman': 'ta'},
    {'geez': 'ቴ', 'roman': 'tie'},
    {'geez': 'ት', 'roman': 't'},
    {'geez': 'ቶ', 'roman': 'to'},
  ],
  [
    {'geez': 'ቸ', 'roman': 'che'},
    {'geez': 'ቹ', 'roman': 'chu'},
    {'geez': 'ቺ', 'roman': 'chi'},
    {'geez': 'ቻ', 'roman': 'cha'},
    {'geez': 'ቼ', 'roman': 'chie'},
    {'geez': 'ች', 'roman': 'ch'},
    {'geez': 'ቾ', 'roman': 'cho'},
  ],
  [
    {'geez': 'ኀ', 'roman': 'ha'},
    {'geez': 'ኁ', 'roman': 'hu'},
    {'geez': 'ኂ', 'roman': 'hi'},
    {'geez': 'ኃ', 'roman': 'ha'},
    {'geez': 'ኄ', 'roman': 'hie'},
    {'geez': 'ኅ', 'roman': 'h'},
    {'geez': 'ኆ', 'roman': 'ho'},
  ],
  [
    {'geez': 'ነ', 'roman': 'ne'},
    {'geez': 'ኑ', 'roman': 'nu'},
    {'geez': 'ኒ', 'roman': 'ni'},
    {'geez': 'ና', 'roman': 'na'},
    {'geez': 'ኔ', 'roman': 'nie'},
    {'geez': 'ን', 'roman': 'n'},
    {'geez': 'ኖ', 'roman': 'no'},
  ],
  [
    {'geez': 'ኘ', 'roman': 'nye'},
    {'geez': 'ኙ', 'roman': 'nyu'},
    {'geez': 'ኚ', 'roman': 'nyi'},
    {'geez': 'ኛ', 'roman': 'nya'},
    {'geez': 'ኜ', 'roman': 'nyie'},
    {'geez': 'ኝ', 'roman': 'ny'},
    {'geez': 'ኞ', 'roman': 'nyo'},
  ],
  [
    {'geez': 'አ', 'roman': 'a'},
    {'geez': 'ኡ', 'roman': 'u'},
    {'geez': 'ኢ', 'roman': 'i'},
    {'geez': 'ኣ', 'roman': 'aa'},
    {'geez': 'ኤ', 'roman': 'ie'},
    {'geez': 'እ', 'roman': '(e)'},
    {'geez': 'ኦ', 'roman': 'o'},
  ],
  [
    {'geez': 'ከ', 'roman': 'ke'},
    {'geez': 'ኩ', 'roman': 'ku'},
    {'geez': 'ኪ', 'roman': 'ki'},
    {'geez': 'ካ', 'roman': 'ka'},
    {'geez': 'ኬ', 'roman': 'kie'},
    {'geez': 'ክ', 'roman': 'k'},
    {'geez': 'ኮ', 'roman': 'ko'},
  ],
  [
    {'geez': 'ኸ', 'roman': 'He'},
    {'geez': 'ኹ', 'roman': 'Hu'},
    {'geez': 'ኺ', 'roman': 'Hi'},
    {'geez': 'ኻ', 'roman': 'Ha'},
    {'geez': 'ኼ', 'roman': 'Hie'},
    {'geez': 'ኽ', 'roman': 'H'},
    {'geez': 'ኾ', 'roman': 'Ho'},
  ],
  [
    {'geez': 'ወ', 'roman': 'we'},
    {'geez': 'ዉ', 'roman': 'wu'},
    {'geez': 'ዊ', 'roman': 'wi'},
    {'geez': 'ዋ', 'roman': 'wa'},
    {'geez': 'ዌ', 'roman': 'wie'},
    {'geez': 'ው', 'roman': 'w'},
    {'geez': 'ዎ', 'roman': 'wo'},
  ],
  [
    {'geez': 'ዐ', 'roman': 'a'},
    {'geez': 'ዑ', 'roman': 'u'},
    {'geez': 'ዒ', 'roman': 'i'},
    {'geez': 'ዓ', 'roman': 'a'},
    {'geez': 'ዔ', 'roman': 'ie'},
    {'geez': 'ዕ', 'roman': '(e)'},
    {'geez': 'ዖ', 'roman': 'o'},
  ],
  [
    {'geez': 'ዘ', 'roman': 'ze'},
    {'geez': 'ዙ', 'roman': 'zu'},
    {'geez': 'ዚ', 'roman': 'zi'},
    {'geez': 'ዛ', 'roman': 'za'},
    {'geez': 'ዜ', 'roman': 'zie'},
    {'geez': 'ዝ', 'roman': 'z'},
    {'geez': 'ዞ', 'roman': 'zo'},
  ],
  [
    {'geez': 'ዠ', 'roman': 'zhe'},
    {'geez': 'ዡ', 'roman': 'zhu'},
    {'geez': 'ዢ', 'roman': 'zhi'},
    {'geez': 'ዣ', 'roman': 'zha'},
    {'geez': 'ዤ', 'roman': 'zhie'},
    {'geez': 'ዥ', 'roman': 'zh'},
    {'geez': 'ዦ', 'roman': 'zho'},
  ],
  [
    {'geez': 'የ', 'roman': 'ye'},
    {'geez': 'ዩ', 'roman': 'yu'},
    {'geez': 'ዪ', 'roman': 'yi'},
    {'geez': 'ያ', 'roman': 'ya'},
    {'geez': 'ዬ', 'roman': 'yie'},
    {'geez': 'ይ', 'roman': 'y'},
    {'geez': 'ዮ', 'roman': 'yo'},
  ],
  [
    {'geez': 'ደ', 'roman': 'de'},
    {'geez': 'ዱ', 'roman': 'du'},
    {'geez': 'ዲ', 'roman': 'di'},
    {'geez': 'ዳ', 'roman': 'da'},
    {'geez': 'ዴ', 'roman': 'die'},
    {'geez': 'ድ', 'roman': 'd'},
    {'geez': 'ዶ', 'roman': 'do'},
  ],
  [
    {'geez': 'ጀ', 'roman': 'je'},
    {'geez': 'ጁ', 'roman': 'ju'},
    {'geez': 'ጂ', 'roman': 'ji'},
    {'geez': 'ጃ', 'roman': 'ja'},
    {'geez': 'ጄ', 'roman': 'jie'},
    {'geez': 'ጅ', 'roman': 'j'},
    {'geez': 'ጆ', 'roman': 'jo'},
  ],
  [
    {'geez': 'ገ', 'roman': 'ge'},
    {'geez': 'ጉ', 'roman': 'gu'},
    {'geez': 'ጊ', 'roman': 'gi'},
    {'geez': 'ጋ', 'roman': 'ga'},
    {'geez': 'ጌ', 'roman': 'gie'},
    {'geez': 'ግ', 'roman': 'g'},
    {'geez': 'ጎ', 'roman': 'go'},
  ],
  [
    {'geez': 'ጠ', 'roman': 'Te'},
    {'geez': 'ጡ', 'roman': 'Tu'},
    {'geez': 'ጢ', 'roman': 'Ti'},
    {'geez': 'ጣ', 'roman': 'Ta'},
    {'geez': 'ጤ', 'roman': 'Tie'},
    {'geez': 'ጥ', 'roman': 'T'},
    {'geez': 'ጦ', 'roman': 'To'},
  ],
  [
    {'geez': 'ጨ', 'roman': 'CHe'},
    {'geez': 'ጩ', 'roman': 'CHu'},
    {'geez': 'ጪ', 'roman': 'CHi'},
    {'geez': 'ጫ', 'roman': 'CHa'},
    {'geez': 'ጬ', 'roman': 'CHie'},
    {'geez': 'ጭ', 'roman': 'CH'},
    {'geez': 'ጮ', 'roman': 'CHo'},
  ],
  [
    {'geez': 'ጰ', 'roman': 'Pe'},
    {'geez': 'ጱ', 'roman': 'Pu'},
    {'geez': 'ጲ', 'roman': 'Pi'},
    {'geez': 'ጳ', 'roman': 'Pa'},
    {'geez': 'ጴ', 'roman': 'Pie'},
    {'geez': 'ጵ', 'roman': 'P'},
    {'geez': 'ጶ', 'roman': 'Po'},
  ],
  [
    {'geez': 'ጸ', 'roman': 'tse'},
    {'geez': 'ጹ', 'roman': 'tsu'},
    {'geez': 'ጺ', 'roman': 'tsi'},
    {'geez': 'ጻ', 'roman': 'tsa'},
    {'geez': 'ጼ', 'roman': 'tsie'},
    {'geez': 'ጽ', 'roman': 'ts'},
    {'geez': 'ጾ', 'roman': 'tso'},
  ],
  [
    {'geez': 'ፀ', 'roman': 'tse'},
    {'geez': 'ፁ', 'roman': 'tsu'},
    {'geez': 'ፂ', 'roman': 'tsi'},
    {'geez': 'ፃ', 'roman': 'tsa'},
    {'geez': 'ፄ', 'roman': 'tsie'},
    {'geez': 'ፅ', 'roman': 'ts'},
    {'geez': 'ፆ', 'roman': 'tso'},
  ],
  [
    {'geez': 'ፈ', 'roman': 'fe'},
    {'geez': 'ፉ', 'roman': 'fu'},
    {'geez': 'ፊ', 'roman': 'fi'},
    {'geez': 'ፋ', 'roman': 'fa'},
    {'geez': 'ፌ', 'roman': 'fie'},
    {'geez': 'ፍ', 'roman': 'f'},
    {'geez': 'ፎ', 'roman': 'fo'},
  ],
  [
    {'geez': 'ፐ', 'roman': 'pe'},
    {'geez': 'ፑ', 'roman': 'pu'},
    {'geez': 'ፒ', 'roman': 'pi'},
    {'geez': 'ፓ', 'roman': 'pa'},
    {'geez': 'ፔ', 'roman': 'pie'},
    {'geez': 'ፕ', 'roman': 'p'},
    {'geez': 'ፖ', 'roman': 'po'},
  ],
];

// Helper function to get a random fidel from the entire alphabet
Map<String, String> getRandomFidel() {
  final random = Random();
  final familyIndex = random.nextInt(amharicAlphabet.length);
  final fidelIndex = random.nextInt(amharicAlphabet[familyIndex].length);
  return amharicAlphabet[familyIndex][fidelIndex];
}

// Helper function to get random fidels (excluding a specific one)
List<Map<String, String>> getRandomFidels(
  int count, {
  Map<String, String>? exclude,
}) {
  final random = Random();
  final selected = <Map<String, String>>[];
  final allFidels = amharicAlphabet.expand((family) => family).toList();

  while (selected.length < count) {
    final fidel = allFidels[random.nextInt(allFidels.length)];

    // Skip if it's the excluded one or already selected
    if (exclude != null && fidel['geez'] == exclude['geez']) continue;
    if (selected.any((f) => f['geez'] == fidel['geez'])) continue;

    selected.add(fidel);
  }

  return selected;
}

// 1. Trace Fidel Exercise
Map<String, dynamic> generateTraceFidelChoiceExerciseData() {
  final fidel = getRandomFidel();

  final exercise = {
    'type': 'trace_fidel',
    'character': fidel['geez'],
  };

  return exercise;
}

// 2. Fidel-Pronunciation Choice Exercise
// Show a Ge'ez character, user picks the correct pronunciation
Map<String, dynamic> generateFidelPronunciationChoiceExerciseData() {
  final correctFidel = getRandomFidel();
  final distractors = getRandomFidels(2, exclude: correctFidel);

  final options = [
    correctFidel['roman'],
    ...distractors.map((f) => f['roman']),
  ];

  // Shuffle options
  options.shuffle();

  final exercise = {
    'type': 'fidel_pronunciation_choice',
    'character': correctFidel['geez'],
    'options': options,
    'correct_answer': correctFidel['roman'],
  };

  return exercise;
}

// 3. Pronunciation-Fidel Choice Exercise
// Show a romanization, user picks the correct Ge'ez character
Map<String, dynamic> generatePronunciationFidelChoiceExerciseData() {
  final correctFidel = getRandomFidel();
  final distractors = getRandomFidels(3, exclude: correctFidel);

  final options = [correctFidel['geez'], ...distractors.map((f) => f['geez'])];

  // Shuffle options
  options.shuffle();

  final exercise = {
    'type': 'pronunciation_fidel_choice',
    'pronunciation': correctFidel['roman'],
    'options': options,
    'correct_answer': correctFidel['geez'],
  };

  return exercise;
}

// 4. Listening Fidel Choice Exercise
// User hears audio, picks the correct Ge'ez character
Map<String, dynamic> generateListeningFidelChoiceExerciseData() {
  final correctFidel = getRandomFidel();
  final distractors = getRandomFidels(3, exclude: correctFidel);

  final options = [correctFidel['geez'], ...distractors.map((f) => f['geez'])];

  // Shuffle options
  options.shuffle();

  final exercise = {
    'type': 'listening_fidel_choice',
    'audio_asset_path': 'assets/fidel_audio/${correctFidel['geez']}.mp3',
    'options': options,
    'correct_answer': correctFidel['geez'],
  };

  return exercise;
}

List<Map<String, dynamic>> generateFidelLesson() {
  // Generate 2 exercises of each type
  final exercises = [
    // TraceFidelChoiceExercise
    generateTraceFidelChoiceExerciseData(),
    generateTraceFidelChoiceExerciseData(),
    // FidelPronunciationChoiceExercise
    generateFidelPronunciationChoiceExerciseData(),
    generateFidelPronunciationChoiceExerciseData(),
    // PronunciationFidelChoiceExercise
    generatePronunciationFidelChoiceExerciseData(),
    generatePronunciationFidelChoiceExerciseData(),
    // ListeningFidelChoiceExercise
    generateListeningFidelChoiceExerciseData(),
    generateListeningFidelChoiceExerciseData(),
  ];
  
  // Shuffle the exercises to randomize the order
  exercises.shuffle();
  
  return exercises;
}

void main() {
  // Build a list of exercises
  final exercises = [
    {
      'title': 'Trace Fidel',
      'data': generateTraceFidelChoiceExerciseData(),
    },
    {
      'title': 'Fidel-Pronunciation Choice',
      'data': generateFidelPronunciationChoiceExerciseData(),
    },
    {
      'title': 'Pronunciation-Fidel Choice',
      'data': generatePronunciationFidelChoiceExerciseData(),
    },
    {
      'title': 'Listening Fidel Choice',
      'data': generateListeningFidelChoiceExerciseData(),
    },
  ];

  // Print the list by iterating on it
  for (final exercise in exercises) {
    print('=== ${exercise['title']} ===');
    print(JsonEncoder.withIndent('  ').convert(exercise['data']!));
    print('');
  }
}
