import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Word Tile Model
class WordTile {
  final String word;
  final int originalIndex;
  bool isUsed;
  bool isCorrect;

  WordTile({
    required this.word,
    required this.originalIndex,
    this.isUsed = false,
    this.isCorrect = false,
  });
}

// Sentence Slot Model
class SentenceSlot {
  final int position;
  WordTile? placedWord;
  bool isCorrect;

  SentenceSlot({
    required this.position,
    this.placedWord,
    this.isCorrect = false,
  });
}

// Build-the-Sentence Exercise Page
class BuildSentenceExercisePage extends StatefulWidget {
  final String targetSentenceEnglish;
  final List<String> correctWordsOrder;
  final List<String> wordBank; // Includes correct words + distractors
  final int currentExercise;
  final int totalExercises;
  final int initialHearts;
  final bool isAmharicSentence;

  const BuildSentenceExercisePage({
    Key? key,
    required this.targetSentenceEnglish,
    required this.correctWordsOrder,
    required this.wordBank,
    this.currentExercise = 1,
    this.totalExercises = 10,
    this.initialHearts = 5,
    this.isAmharicSentence = true,
  }) : super(key: key);

  @override
  State<BuildSentenceExercisePage> createState() =>
      _BuildSentenceExercisePageState();
}

class _BuildSentenceExercisePageState extends State<BuildSentenceExercisePage>
    with TickerProviderStateMixin {
  // Controllers and Animations
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late AnimationController _successController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _successAnimation;

  // State Management
  List<WordTile> _availableWords = [];
  List<SentenceSlot> _sentenceSlots = [];
  bool _isChecking = false;
  bool _showAnswer = false;
  bool _isCorrect = false;
  int _hearts = 5;
  bool _isDragMode = true;
  // WordTile? _draggedWord;

  @override
  void initState() {
    super.initState();
    _hearts = widget.initialHearts;
    _initializeExercise();
    _setupAnimations();
  }

  void _initializeExercise() {
    // Create word tiles (shuffle the word bank)
    List<String> shuffledWords = List.from(widget.wordBank)..shuffle();
    _availableWords = shuffledWords.asMap().entries.map((entry) {
      return WordTile(word: entry.value, originalIndex: entry.key);
    }).toList();

    // Create sentence slots
    _sentenceSlots = List.generate(
      widget.correctWordsOrder.length,
      (index) => SentenceSlot(position: index),
    );
  }

  void _setupAnimations() {
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _successController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _successAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _successController, curve: Curves.bounceOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _fadeController.dispose();
    _successController.dispose();
    super.dispose();
  }

  // Check if sentence is complete
  bool _isSentenceComplete() {
    return _sentenceSlots.every((slot) => slot.placedWord != null);
  }

  // Check if sentence is correct
  bool _isSentenceCorrect() {
    for (int i = 0; i < _sentenceSlots.length; i++) {
      if (_sentenceSlots[i].placedWord?.word != widget.correctWordsOrder[i]) {
        return false;
      }
    }
    return true;
  }

  // Handle word placement
  void _placeWord(WordTile word, int slotIndex) {
    setState(() {
      // Remove word from previous slot if it was placed somewhere
      for (var slot in _sentenceSlots) {
        if (slot.placedWord == word) {
          slot.placedWord = null;
          break;
        }
      }

      // If slot is occupied, return the word to available words
      if (_sentenceSlots[slotIndex].placedWord != null) {
        _sentenceSlots[slotIndex].placedWord!.isUsed = false;
      }

      // Place the word in the new slot
      _sentenceSlots[slotIndex].placedWord = word;
      word.isUsed = true;
    });
  }

  // Handle word removal from slot
  void _removeWordFromSlot(int slotIndex) {
    setState(() {
      if (_sentenceSlots[slotIndex].placedWord != null) {
        _sentenceSlots[slotIndex].placedWord!.isUsed = false;
        _sentenceSlots[slotIndex].placedWord = null;
      }
    });
  }

  // Check answer
  void _checkAnswer() async {
    if (!_isSentenceComplete()) return;

    setState(() {
      _isChecking = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    bool isCorrect = _isSentenceCorrect();

    setState(() {
      _isChecking = false;
      _isCorrect = isCorrect;
      _showAnswer = true;

      // Mark each slot as correct or incorrect
      for (int i = 0; i < _sentenceSlots.length; i++) {
        _sentenceSlots[i].isCorrect =
            _sentenceSlots[i].placedWord?.word == widget.correctWordsOrder[i];
      }

      if (!isCorrect) {
        _hearts = (_hearts - 1).clamp(0, widget.initialHearts);
        _shakeController.forward().then((_) => _shakeController.reset());
      } else {
        _successController.forward();
      }
    });

    // Haptic feedback
    if (isCorrect) {
      HapticFeedback.heavyImpact();
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  void _continue() {
    Navigator.pop(context, {'isCorrect': _isCorrect, 'hearts': _hearts});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14161B),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header Section
              _buildHeader(),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Instruction
                      _buildInstruction(),

                      const SizedBox(height: 32),

                      // Construction zone
                      _buildConstructionZone(),

                      const SizedBox(height: 40),

                      // Mode toggle
                      _buildModeToggle(),

                      const SizedBox(height: 24),

                      // Word bank
                      _buildWordBank(),

                      const SizedBox(height: 32),

                      // Answer feedback
                      if (_showAnswer) _buildAnswerFeedback(),
                    ],
                  ),
                ),
              ),

              // Bottom section
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Exit button
          IconButton(
            onPressed: () => _showExitDialog(),
            icon: const Icon(Icons.close, color: Colors.white, size: 24),
          ),

          const SizedBox(width: 16),

          // Progress bar
          Expanded(child: _buildProgressBar()),

          const SizedBox(width: 16),

          // Hearts
          _buildHearts(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    double progress = widget.currentExercise / widget.totalExercises;
    return Container(
      height: 12,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D33),
        borderRadius: BorderRadius.circular(6),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF1CC06)),
        ),
      ),
    );
  }

  Widget _buildHearts() {
    return Row(
      children: List.generate(widget.initialHearts, (index) {
        bool isActive = index < _hearts;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(
            isActive ? Icons.favorite : Icons.favorite_border,
            color: isActive ? Colors.red : const Color(0xFF888888),
            size: 20,
          ),
        );
      }),
    );
  }

  Widget _buildInstruction() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2127),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2D33)),
      ),
      child: Column(
        children: [
          const Text(
            'Build this sentence:',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFB0B0B0),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.targetSentenceEnglish,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          // Audio button for target pronunciation
          if (widget.isAmharicSentence) ...[
            const SizedBox(height: 12),
            IconButton(
              onPressed: _playTargetAudio,
              icon: const Icon(Icons.volume_up, color: Color(0xFFF1CC06)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConstructionZone() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2127),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _showAnswer
                    ? (_isCorrect ? Colors.green : Colors.red)
                    : const Color(0xFF2A2D33),
                width: _showAnswer ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your sentence:',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFB0B0B0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),

                // Sentence slots
                Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: _sentenceSlots.asMap().entries.map((entry) {
                    int index = entry.key;
                    SentenceSlot slot = entry.value;
                    return _buildSentenceSlot(slot, index);
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSentenceSlot(SentenceSlot slot, int index) {
    bool hasWord = slot.placedWord != null;
    Color borderColor = const Color(0xFF2A2D33);
    Color backgroundColor = const Color(0xFF14161B);

    if (_showAnswer) {
      if (hasWord) {
        borderColor = slot.isCorrect ? Colors.green : Colors.red;
        backgroundColor = slot.isCorrect
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1);
      }
    }

    return DragTarget<WordTile>(
      onWillAccept: (data) => _isDragMode,
      onAccept: (data) {
        if (!_showAnswer) {
          _placeWord(data, index);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: hasWord ? () => _removeWordFromSlot(index) : null,
          child: Container(
            height: 50,
            constraints: const BoxConstraints(minWidth: 80),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: candidateData.isNotEmpty
                    ? const Color(0xFFF1CC06)
                    : borderColor,
                width: candidateData.isNotEmpty ? 2 : 1,
                style: hasWord ? BorderStyle.solid : BorderStyle.none,
              ),
            ),
            child: Center(
              child: hasWord
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            slot.placedWord!.word,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: _showAnswer && !slot.isCorrect
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                        if (!_showAnswer) ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.close,
                            size: 16,
                            color: Color(0xFF888888),
                          ),
                        ],
                      ],
                    )
                  : Container(
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2D33),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E2127),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2D33)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModeButton('Drag', Icons.pan_tool, _isDragMode),
              _buildModeButton('Tap', Icons.touch_app, !_isDragMode),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildModeButton(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isDragMode = label == 'Drag';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF1CC06) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? const Color(0xFF14161B)
                  : const Color(0xFFB0B0B0),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF14161B)
                    : const Color(0xFFB0B0B0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordBank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Word Bank:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableWords
              .map((word) => _buildWordTile(word))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWordTile(WordTile word) {
    if (_isDragMode) {
      return _buildDraggableWordTile(word);
    } else {
      return _buildTappableWordTile(word);
    }
  }

  Widget _buildDraggableWordTile(WordTile word) {
    return Draggable<WordTile>(
      data: word,
      feedback: Material(
        color: Colors.transparent,
        child: _buildWordTileContent(word, isDragging: true),
      ),
      childWhenDragging: _buildWordTileContent(word, isBeingDragged: true),
      child: _buildWordTileContent(word),
    );
  }

  Widget _buildTappableWordTile(WordTile word) {
    return GestureDetector(
      onTap: () => _handleWordTileTap(word),
      child: _buildWordTileContent(word),
    );
  }

  Widget _buildWordTileContent(
    WordTile word, {
    bool isDragging = false,
    bool isBeingDragged = false,
  }) {
    double opacity = word.isUsed ? (isBeingDragged ? 0.3 : 0.5) : 1.0;
    Color backgroundColor = isDragging
        ? const Color(0xFFF1CC06)
        : (word.isUsed ? const Color(0xFF2A2D33) : const Color(0xFF1E2127));
    Color textColor = isDragging
        ? const Color(0xFF14161B)
        : (word.isUsed ? const Color(0xFF888888) : Colors.white);
    Color borderColor = word.isUsed
        ? const Color(0xFF2A2D33)
        : const Color(0xFF2A2D33);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: isDragging
              ? [
                  BoxShadow(
                    color: const Color(0xFFF1CC06).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          word.word,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  void _handleWordTileTap(WordTile word) {
    if (_showAnswer || word.isUsed) return;

    // Find first empty slot
    int emptySlotIndex = _sentenceSlots.indexWhere(
      (slot) => slot.placedWord == null,
    );
    if (emptySlotIndex != -1) {
      _placeWord(word, emptySlotIndex);
    }
  }

  Widget _buildAnswerFeedback() {
    return ScaleTransition(
      scale: _successAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isCorrect
              ? Colors.green.withOpacity(0.1)
              : Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isCorrect ? Colors.green : Colors.red,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isCorrect ? 'Perfect!' : 'Not quite right',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isCorrect ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            if (!_isCorrect) ...[
              const SizedBox(height: 12),
              Text(
                'Correct order: ${widget.correctWordsOrder.join(' ')}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFB0B0B0),
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Hint button
          if (!_showAnswer && !_isSentenceComplete())
            TextButton.icon(
              onPressed: _showHint,
              icon: const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFFF1CC06),
              ),
              label: const Text(
                'Hint',
                style: TextStyle(color: Color(0xFFF1CC06)),
              ),
            ),

          const SizedBox(height: 16),

          // Main action button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _showAnswer
                  ? _continue
                  : (_isSentenceComplete() ? _checkAnswer : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1CC06),
                foregroundColor: const Color(0xFF14161B),
                elevation: 8,
                shadowColor: const Color(0xFFF1CC06).withAlpha(76),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xFF2A2D33),
                disabledForegroundColor: const Color(0xFF888888),
              ),
              child: _isChecking
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Color(0xFF14161B),
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _showAnswer ? 'CONTINUE' : 'CHECK',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHint() {
    // Find the first empty slot and highlight the correct word
    int emptySlotIndex = _sentenceSlots.indexWhere(
      (slot) => slot.placedWord == null,
    );
    if (emptySlotIndex != -1) {
      String correctWord = widget.correctWordsOrder[emptySlotIndex];

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1E2127),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Hint',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'The next word starts with "${correctWord[0]}"',
            style: const TextStyle(color: Color(0xFFB0B0B0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Got it!',
                style: TextStyle(color: Color(0xFFF1CC06)),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _playTargetAudio() {
    HapticFeedback.lightImpact();
    // Audio playback functionality would go here
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2127),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Exit Exercise?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Your progress will be lost if you exit now.',
            style: TextStyle(color: Color(0xFFB0B0B0)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFB0B0B0)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Exit exercise
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Exit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
