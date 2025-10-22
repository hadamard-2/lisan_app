import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:just_audio/just_audio.dart';

class FidelPracticePage extends StatelessWidget {
  const FidelPracticePage({super.key});

  // Amharic alphabet data
  static const List<List<Map<String, String>>> amharicAlphabet = [
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
      {'geez': 'ቀ', 'roman': 'ke'},
      {'geez': 'ቁ', 'roman': 'ku'},
      {'geez': 'ቂ', 'roman': 'ki'},
      {'geez': 'ቃ', 'roman': 'ka'},
      {'geez': 'ቄ', 'roman': 'kie'},
      {'geez': 'ቅ', 'roman': 'k'},
      {'geez': 'ቆ', 'roman': 'ko'},
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
      {'geez': 'ኸ', 'roman': 'he'},
      {'geez': 'ኹ', 'roman': 'hu'},
      {'geez': 'ኺ', 'roman': 'hi'},
      {'geez': 'ኻ', 'roman': 'ha'},
      {'geez': 'ኼ', 'roman': 'hie'},
      {'geez': 'ኽ', 'roman': 'h'},
      {'geez': 'ኾ', 'roman': 'ho'},
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
      {'geez': 'ጠ', 'roman': 'te'},
      {'geez': 'ጡ', 'roman': 'tu'},
      {'geez': 'ጢ', 'roman': 'ti'},
      {'geez': 'ጣ', 'roman': 'ta'},
      {'geez': 'ጤ', 'roman': 'tie'},
      {'geez': 'ጥ', 'roman': 't'},
      {'geez': 'ጦ', 'roman': 'to'},
    ],
    [
      {'geez': 'ጨ', 'roman': 'che'},
      {'geez': 'ጩ', 'roman': 'chu'},
      {'geez': 'ጪ', 'roman': 'chi'},
      {'geez': 'ጫ', 'roman': 'cha'},
      {'geez': 'ጬ', 'roman': 'chie'},
      {'geez': 'ጭ', 'roman': 'ch'},
      {'geez': 'ጮ', 'roman': 'cho'},
    ],
    [
      {'geez': 'ጰ', 'roman': 'pe'},
      {'geez': 'ጱ', 'roman': 'pu'},
      {'geez': 'ጲ', 'roman': 'pi'},
      {'geez': 'ጳ', 'roman': 'pa'},
      {'geez': 'ጴ', 'roman': 'pie'},
      {'geez': 'ጵ', 'roman': 'p'},
      {'geez': 'ጶ', 'roman': 'po'},
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DesignColors.backgroundDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: DesignColors.textPrimary,
            size: 32,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: DesignColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DesignSpacing.sm,
            horizontal: DesignSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              const Text(
                "Let's learn Amharic alphabet!",
                style: TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: DesignSpacing.sm),
              const Text(
                'Get to know the beautiful Ge\'ez script',
                style: TextStyle(
                  color: DesignColors.textSecondary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: DesignSpacing.xl),

              // Learn Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignColors.primary,
                    foregroundColor: DesignColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'LEARN THE CHARACTERS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DesignSpacing.lg),

              // Character Grid - 7 columns for Amharic
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: DesignSpacing.sm,
                    mainAxisSpacing: DesignSpacing.md,
                  ),
                  itemCount: amharicAlphabet.expand((row) => row).length,
                  itemBuilder: (context, index) {
                    final allCharacters = amharicAlphabet
                        .expand((row) => row)
                        .toList();
                    return AmharicCell(character: allCharacters[index]);
                  },
                ),
              ),
              const SizedBox(height: DesignSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

class AmharicCell extends StatefulWidget {
  final Map<String, String> character;

  const AmharicCell({super.key, required this.character});

  @override
  State<AmharicCell> createState() => _AmharicCellState();
}

class _AmharicCellState extends State<AmharicCell> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_isPlaying) return;

    try {
      setState(() => _isPlaying = true);
      await _audioPlayer.setAsset(
        'assets/fidel_audio/${widget.character['geez']}.mp3',
      );
      await _audioPlayer.play();
      await _audioPlayer.positionStream.firstWhere(
        (position) => position >= (_audioPlayer.duration ?? Duration.zero),
      );
      setState(() => _isPlaying = false);
    } catch (e) {
      print('Error playing audio: $e');
      setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _playAudio,
      child: Container(
        decoration: BoxDecoration(
          color: _isPlaying
              ? DesignColors.primary.withValues(alpha: 0.2)
              : DesignColors.backgroundCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _isPlaying
                ? DesignColors.primary
                : DesignColors.backgroundBorder,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.character['geez']!,
              style: const TextStyle(
                fontFamily: 'Neteru',
                color: DesignColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.character['roman']!,
              style: const TextStyle(
                color: DesignColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
