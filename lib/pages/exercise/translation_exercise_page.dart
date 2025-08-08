import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Translation Exercise Page
class TranslationExercisePage extends StatefulWidget {
  final String sourceText;
  final String correctAnswer;
  final bool isAmharicToEnglish;
  final List<String>? wordBank; // Optional word bank for beginners
  final int currentExercise;
  final int totalExercises;
  final int initialHearts;

  const TranslationExercisePage({
    super.key,
    required this.sourceText,
    required this.correctAnswer,
    this.isAmharicToEnglish = false,
    this.wordBank,
    this.currentExercise = 1,
    this.totalExercises = 10,
    this.initialHearts = 5,
  });

  @override
  State<TranslationExercisePage> createState() =>
      _TranslationExercisePageState();
}

class _TranslationExercisePageState extends State<TranslationExercisePage>
    with TickerProviderStateMixin {
  // Controllers and Animation
  final TextEditingController _textController = TextEditingController();
  late AnimationController _shakeController;
  late AnimationController _fadeController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _fadeAnimation;

  // State Management
  bool _isChecking = false;
  bool _showAnswer = false;
  bool _isCorrect = false;
  int _hearts = 5;
  bool _useWordBank = false;
  // bool _showAmharicKeyboard = false;
  final List<String> _selectedWords = [];
  String _userAnswer = '';

  @override
  void initState() {
    super.initState();
    _hearts = widget.initialHearts;
    _useWordBank = widget.wordBank != null;

    // Initialize animations
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _shakeController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Check answer logic
  void _checkAnswer() async {
    setState(() {
      _isChecking = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));

    String userInput = _useWordBank
        ? _selectedWords.join(' ')
        : _textController.text.trim();
    bool isCorrect = _isAnswerCorrect(userInput);

    setState(() {
      _isChecking = false;
      _isCorrect = isCorrect;
      _showAnswer = true;
      _userAnswer = userInput;

      if (!isCorrect) {
        _hearts = (_hearts - 1).clamp(0, widget.initialHearts);
        _shakeController.forward().then((_) => _shakeController.reset());
      }
    });
  }

  bool _isAnswerCorrect(String userInput) {
    // Simple check - in production, this would be more sophisticated
    String normalized = userInput.toLowerCase().trim();
    String correct = widget.correctAnswer.toLowerCase().trim();
    return normalized == correct;
  }

  void _continue() {
    // Navigate to next exercise or show results
    Navigator.pop(context, {'isCorrect': _isCorrect, 'hearts': _hearts});
  }

  // Word bank tile tap handler
  void _onWordBankTap(String word) {
    setState(() {
      if (_selectedWords.contains(word)) {
        _selectedWords.remove(word);
      } else {
        _selectedWords.add(word);
      }
    });
  }

  // Clear selected words
  void _clearSelection() {
    setState(() {
      _selectedWords.clear();
    });
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
                      // Source text display
                      _buildSourceText(),

                      const SizedBox(height: 40),

                      // Input section
                      _buildInputSection(),

                      const SizedBox(height: 32),

                      // Word bank (if available)
                      if (_useWordBank) ...[
                        _buildWordBank(),
                        const SizedBox(height: 24),
                      ],

                      // Keyboard toggle (for Amharic input)
                      if (!widget.isAmharicToEnglish && !_useWordBank)
                        _buildKeyboardToggle(),

                      const SizedBox(height: 40),

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

  Widget _buildSourceText() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2127),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2D33)),
      ),
      child: Column(
        children: [
          // Audio button for Amharic text
          if (widget.isAmharicToEnglish)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: _playAudio,
                icon: const Icon(Icons.volume_up, color: Color(0xFFF1CC06)),
              ),
            ),

          Text(
            widget.sourceText,
            style: TextStyle(
              fontSize: widget.isAmharicToEnglish ? 20 : 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          // Romanization toggle for Amharic
          if (widget.isAmharicToEnglish) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                // Toggle romanization display
              },
              child: const Text(
                'Show romanization',
                style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    if (_useWordBank) {
      return _buildWordBankInput();
    } else {
      return _buildTextInput();
    }
  }

  Widget _buildTextInput() {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Container(
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
            child: TextField(
              controller: _textController,
              enabled: !_showAnswer,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText: widget.isAmharicToEnglish
                    ? 'Type in English...'
                    : 'Type in Amharic...',
                hintStyle: const TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: !widget.isAmharicToEnglish
                    ? IconButton(
                        onPressed: () {
                          // Voice input functionality
                        },
                        icon: const Icon(Icons.mic, color: Color(0xFFB0B0B0)),
                      )
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWordBankInput() {
    return Container(
      padding: const EdgeInsets.all(16),
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
            'Tap the words in the correct order:',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFFB0B0B0),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Selected words display
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF14161B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A2D33)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedWords
                  .map((word) => _buildSelectedWordChip(word))
                  .toList(),
            ),
          ),

          if (_selectedWords.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _clearSelection,
                child: const Text(
                  'Clear all',
                  style: TextStyle(color: Color(0xFFF1CC06), fontSize: 14),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelectedWordChip(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1CC06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        word,
        style: const TextStyle(
          color: Color(0xFF14161B),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildWordBank() {
    if (widget.wordBank == null) return const SizedBox.shrink();

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
          children: widget.wordBank!
              .map((word) => _buildWordBankTile(word))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWordBankTile(String word) {
    bool isSelected = _selectedWords.contains(word);

    return GestureDetector(
      onTap: () => _onWordBankTap(word),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2A2D33) : const Color(0xFF1E2127),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF1CC06)
                : const Color(0xFF2A2D33),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          word,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? const Color(0xFFF1CC06) : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardToggle() {
    if (widget.isAmharicToEnglish) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _useWordBank = !_useWordBank;
            });
          },
          icon: const Icon(Icons.keyboard, color: Color(0xFFF1CC06)),
          label: const Text(
            "Can't type in Amharic?",
            style: TextStyle(color: Color(0xFFF1CC06), fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerFeedback() {
    return Container(
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
                  _isCorrect ? 'Correct!' : 'Not quite right',
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
              'Correct answer: ${widget.correctAnswer}',
              style: const TextStyle(fontSize: 14, color: Color(0xFFB0B0B0)),
            ),
            if (_userAnswer.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Your answer: $_userAnswer',
                style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Hint button (when available)
          if (!_showAnswer)
            TextButton.icon(
              onPressed: () {
                // Show hint functionality
              },
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
                  : (_canCheck() ? _checkAnswer : null),
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

  bool _canCheck() {
    if (_useWordBank) {
      return _selectedWords.isNotEmpty;
    } else {
      return _textController.text.trim().isNotEmpty;
    }
  }

  void _playAudio() {
    // Audio playback functionality
    HapticFeedback.lightImpact();
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
