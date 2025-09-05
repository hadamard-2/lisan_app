import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';

enum ExerciseState { initial, checking, correct, incorrect }

class LessonTemplate extends StatefulWidget {
  final List<Widget> exercises;
  final double? initialProgress; // Optional: override auto-calculated progress
  final int hearts;
  final bool isVoiceBased;
  final bool requeueIncorrectAnswers;
  final int maxRequeues;

  // Callbacks
  final VoidCallback? onExit;
  final Function(BuildContext context) onLessonCompletion;
  final Function(int currentIndex, int totalRemaining)? onExerciseComplete;
  final Function(String id)? onExerciseRequeued;
  final VoidCallback? onVoiceBasedExercise;

  // Per-exercise data (functions that take current exercise index)
  final Future<String?> Function(String id)? getFeedbackMessage;
  final Future<String?> Function(String id)? getCorrectAnswer;
  final Future<bool> Function(String id)? validateAnswer; // Returns true if correct

  const LessonTemplate({
    super.key,
    required this.exercises,
    required this.onLessonCompletion,
    this.initialProgress,
    this.hearts = 5,
    this.isVoiceBased = false,
    this.requeueIncorrectAnswers = true,
    this.maxRequeues = 1,
    this.onExit,
    this.onExerciseComplete,
    this.onExerciseRequeued,
    this.onVoiceBasedExercise,
    this.getFeedbackMessage,
    this.getCorrectAnswer,
    this.validateAnswer,
  });

  @override
  State<LessonTemplate> createState() => _LessonTemplateState();
}

class _LessonTemplateState extends State<LessonTemplate>
    with TickerProviderStateMixin {
  ExerciseState _exerciseState = ExerciseState.initial;
  late List<ExerciseWidget> _exerciseQueue;
  // Track how many times each exercise has been requeued
  late List<int> _requeueCount;
  int _currentExerciseIndex = 0;
  int _totalExercisesCompleted = 0;

  late AnimationController _feedbackController;
  late AnimationController _buttonController;
  late AnimationController _transitionController;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _feedbackSlideAnimation;
  late Animation<Offset> _exerciseSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize exercise queue and requeue tracking
    _exerciseQueue = List<ExerciseWidget>.from(widget.exercises);
    _requeueCount = List<int>.filled(widget.exercises.length, 0);

    // Initialize animation controllers
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _buttonAnimation = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    );
    _feedbackSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: _feedbackController, curve: Curves.easeOut),
        );
    _exerciseSlideAnimation =
        Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _transitionController,
            curve: Curves.easeInOut,
          ),
        );

    // Start with first exercise
    _transitionController.forward();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _buttonController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  double get _progress {
    if (widget.initialProgress != null) return widget.initialProgress!;
    if (_exerciseQueue.isEmpty) return 1.0;
    return _totalExercisesCompleted / _exerciseQueue.length;
  }

  ExerciseWidget get _currentExercise => _exerciseQueue[_currentExerciseIndex];

  Future<String?>? get _currentFeedbackMessage =>
      widget.getFeedbackMessage?.call(_currentExercise.exerciseData.id);

  Future<String?>? get _currentCorrectAnswer =>
      widget.getCorrectAnswer?.call(_currentExercise.exerciseData.id);

  void _handleCheck() {
    setState(() {
      _exerciseState = ExerciseState.checking;
    });

    _buttonController.forward();

    // Simulate checking delay
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        // Validate answer
        final isCorrect = await widget.validateAnswer?.call(_currentExercise.exerciseData.id) ?? true;

        setState(() {
          _exerciseState = isCorrect
              ? ExerciseState.correct
              : ExerciseState.incorrect;
        });
        _feedbackController.forward();
      }
    });
  }

  void _handleContinue() {
    _feedbackController.reverse();
    _buttonController.reverse();

    final wasCorrect = _exerciseState == ExerciseState.correct;

    // Handle incorrect answer re-queueing
    if (!wasCorrect && widget.requeueIncorrectAnswers) {
      final exerciseId = _currentExercise
          .exerciseData
          .id; // Access ID via the unified property
      // Note: Since we're using IDs, we don't need _requeueCount anymore (or track per ID if needed)
      // For simplicity, assume requeuing is allowed without a count limit per ID
      final requeuedExercise = _currentExercise.copyWith(
        isRequeued: true,
        key: UniqueKey(),
      );

      _exerciseQueue.add(requeuedExercise);
      widget.onExerciseRequeued?.call(
        exerciseId,
      ); // Pass ID instead of the widget
    }

    _totalExercisesCompleted++;

    setState(() {
      _exerciseState = ExerciseState.initial;
    });

    // Move to next exercise or complete
    _moveToNextExercise();
  }

  void _moveToNextExercise() {
    // Check if this was the last exercise
    if (_currentExerciseIndex == _exerciseQueue.length - 1) {
      // All exercises completed - trigger completion callback
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          widget.onLessonCompletion(context);
        }
      });
      return;
    }

    // Animate transition to next exercise
    _transitionController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentExerciseIndex++;
        });

        widget.onExerciseComplete?.call(
          _currentExerciseIndex,
          _exerciseQueue.length - _currentExerciseIndex - 1,
        );

        _transitionController.forward();
      }
    });
  }

  Color _getButtonColor() {
    switch (_exerciseState) {
      case ExerciseState.initial:
        return DesignColors.primary;
      case ExerciseState.checking:
        return DesignColors.backgroundBorder;
      case ExerciseState.correct:
        return DesignColors.success;
      case ExerciseState.incorrect:
        return DesignColors.error;
    }
  }

  String _getButtonText() {
    switch (_exerciseState) {
      case ExerciseState.initial:
        return 'CHECK';
      case ExerciseState.checking:
        return 'CHECKING...';
      case ExerciseState.correct:
        return _currentExerciseIndex == _exerciseQueue.length - 1
            ? 'DONE'
            : 'CONTINUE';
      case ExerciseState.incorrect:
        return 'GOT IT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Top Bar
                _buildTopBar(),

                // Main Content (Scrollable with transition animation)
                Expanded(
                  child: SlideTransition(
                    position: _exerciseSlideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(DesignSpacing.sm),
                      child: _currentExercise,
                    ),
                  ),
                ),

                // Bottom Section
                _buildBottomSection(),
              ],
            ),

            // Feedback Overlay
            _buildFeedbackOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        DesignSpacing.md,
        DesignSpacing.lg,
        DesignSpacing.lg,
        0,
      ),
      child: Row(
        spacing: DesignSpacing.md,
        children: [
          // Exit Button
          GestureDetector(
            onTap: widget.onExit,
            child: const Icon(
              Icons.close_rounded,
              color: DesignColors.textSecondary,
              size: 27,
            ),
          ),

          // Progress Bar
          Expanded(
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: DesignColors.backgroundBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),

          // Hearts Counter
          Row(
            spacing: DesignSpacing.xs,
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: DesignColors.error,
                size: 24,
              ),

              Text(
                '${widget.hearts}',
                style: const TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackOverlay() {
    if (_exerciseState != ExerciseState.correct &&
        _exerciseState != ExerciseState.incorrect) {
      return const SizedBox.shrink();
    }

    final isCorrect = _exerciseState == ExerciseState.correct;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SlideTransition(
        position: _feedbackSlideAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            border: Border(
              top: BorderSide(color: DesignColors.backgroundBorder, width: 2),
              left: BorderSide(color: DesignColors.backgroundBorder, width: 2),
              right: BorderSide(color: DesignColors.backgroundBorder, width: 2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Feedback Content
              Container(
                padding: const EdgeInsets.all(DesignSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isCorrect ? Icons.check_circle_rounded : Icons.cancel,
                          color: isCorrect
                              ? DesignColors.success
                              : DesignColors.error,
                          size: 24,
                        ),
                        const SizedBox(width: DesignSpacing.sm),
                        Text(
                          isCorrect ? 'Nicely done.' : 'Incorrect',
                          style: TextStyle(
                            color: isCorrect
                                ? DesignColors.success
                                : DesignColors.error,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    if (_currentFeedbackMessage != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      FutureBuilder<String?>(
                        future: _currentFeedbackMessage!,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: TextStyle(
                                color: isCorrect
                                    ? DesignColors.success
                                    : DesignColors.textSecondary,
                                fontSize: 16,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],

                    if (!isCorrect && _currentCorrectAnswer != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      Text(
                        'Correct Answer:',
                        style: const TextStyle(
                          color: DesignColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.xs),
                      FutureBuilder<String?>(
                        future: _currentCorrectAnswer!,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return Text(
                              snapshot.data!,
                              style: const TextStyle(
                                color: DesignColors.success,
                                fontSize: 16,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ],
                ),
              ),

              // Button Section
              Container(
                padding: const EdgeInsets.all(DesignSpacing.md),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(),
                      foregroundColor: DesignColors.backgroundDark,
                      elevation: 8,
                      shadowColor: _getButtonColor().withAlpha(76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _getButtonText(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    String skipText = '';
    print(_currentExercise.exerciseData.type);
    switch (_currentExercise.exerciseData.type) {
      case 'speaking':
        skipText = 'CAN\'T SPEAK NOW';
        break;
      case 'listening':
        skipText = 'CAN\'T LISTEN NOW';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Column(
        spacing: DesignSpacing.md,
        children: [
          if (skipText.isNotEmpty && _exerciseState == ExerciseState.initial)
            TextButton(
              // onPressed: widget.onVoiceBasedExercise,
              onPressed: skipVoiceBasedExercises,
              child: Text(
                skipText,
                style: TextStyle(
                  color: DesignColors.textTertiary,
                  fontSize: 15,
                ),
              ),
            ),

          // Main Action Button (only show when no feedback)
          if (_exerciseState != ExerciseState.correct &&
              _exerciseState != ExerciseState.incorrect)
            AnimatedBuilder(
              animation: _buttonAnimation,
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _exerciseState == ExerciseState.checking
                        ? null
                        : _handleCheck,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getButtonColor(),
                      foregroundColor: DesignColors.backgroundDark,
                      elevation: 8,
                      shadowColor: _getButtonColor().withAlpha(76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _exerciseState == ExerciseState.checking
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            _getButtonText(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // skips voice based exercise for the rest of the lesson
  void skipVoiceBasedExercises() {
    // show feedback overlay with
    // text: "We'll skip ${exerciseType} for this lesson."
    // button: "CONTINUE"
  }
}
