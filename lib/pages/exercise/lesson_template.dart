import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/pages/exercise/exercise_widget.dart';
import 'package:lisan_app/widgets/exercise/feedback_panel.dart';
import 'package:lisan_app/widgets/exercise/lesson_controls.dart';
import 'package:lisan_app/widgets/exercise/lesson_top_bar.dart';
import 'package:lisan_app/models/exercise_state.dart';
import 'package:lisan_app/models/lesson_stats.dart';

class LessonTemplate extends StatefulWidget {
  final List<Widget> exercises;
  final double? initialProgress; // Optional: override auto-calculated progress
  final int hearts;
  final bool requeueIncorrectAnswers;

  // Callbacks
  final VoidCallback? onExit;
  final void Function(BuildContext context, LessonStats stats)
  onLessonCompletion;
  final Function(int currentIndex, int totalRemaining)? onExerciseComplete;
  final Function(String id)? onExerciseRequeued;

  // Per-exercise data (functions that take current exercise index)
  final Future<String?> Function(String id)? getFeedbackMessage;
  final Future<String?> Function(String id)? getCorrectAnswer;
  final Future<bool> Function(String id)? validateAnswer;

  const LessonTemplate({
    super.key,
    required this.exercises,
    required this.onLessonCompletion,
    this.initialProgress,
    this.hearts = 5,
    this.requeueIncorrectAnswers = true,
    this.onExit,
    this.onExerciseComplete,
    this.onExerciseRequeued,
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
  int _currentExerciseIndex = 0;
  int _totalExercisesCompleted = 0;
  late int _remainingHearts;
  final Set<String> _skippedTypes = {};

  // Stats tracking
  late DateTime _startTime;
  final List<String> _correctIds = [];
  final List<String> _skippedIds = [];
  int _skippedCount = 0;

  late AnimationController _feedbackController;
  late AnimationController _buttonController;
  late AnimationController _transitionController;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _feedbackSlideAnimation;
  late Animation<Offset> _exerciseSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize stats tracking
    _startTime = DateTime.now();

    // Initialize exercise queue and requeue tracking
    _exerciseQueue = List<ExerciseWidget>.from(widget.exercises);
    _remainingHearts = widget.hearts;

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
      duration: const Duration(milliseconds: 600),
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

  /// Only fetch once we’ve moved out of the initial state.
  Future<String?>? get _currentFeedbackMessage {
    if (_exerciseState == ExerciseState.skipped) {
      final exerciseType = _currentExercise.exerciseData.type;
      return Future.value(
        "We'll skip ${exerciseType == 'listening' ? 'listening' : 'speaking'} for this lesson.",
      );
    }

    if (_exerciseState != ExerciseState.correct &&
        _exerciseState != ExerciseState.incorrect) {
      return null;
    }
    return widget.getFeedbackMessage?.call(_currentExercise.exerciseData.id);
  }

  /// Only fetch the “correct answer” when we’re showing incorrect feedback.
  Future<String?>? get _currentCorrectAnswer {
    if (_exerciseState != ExerciseState.incorrect) return null;
    return widget.getCorrectAnswer?.call(_currentExercise.exerciseData.id);
  }

  void _handleSkip() {
    final exerciseType = _currentExercise.exerciseData.type;

    setState(() {
      _exerciseState = ExerciseState.skipped;
      _skippedTypes.add(exerciseType);
      _skippedIds.add(_currentExercise.exerciseData.id);
    });

    _feedbackController.forward();
  }

  void _handleCheck() {
    setState(() {
      _exerciseState = ExerciseState.checking;
    });

    _buttonController.forward();

    // Simulate checking delay
    Future.delayed(const Duration(milliseconds: 1500), () async {
      if (mounted) {
        // Validate answer
        final isCorrect =
            await widget.validateAnswer?.call(
              _currentExercise.exerciseData.id,
            ) ??
            true;

        setState(() {
          _exerciseState = isCorrect
              ? ExerciseState.correct
              : ExerciseState.incorrect;

          if (!isCorrect) _remainingHearts--;
        });
        _feedbackController.forward();
      }
    });
  }

  void _handleContinue() {
    _feedbackController.reverse();
    _buttonController.reverse();

    final wasCorrect = _exerciseState == ExerciseState.correct;
    final wasSkipped = _exerciseState == ExerciseState.skipped;

    // Update stats
    if (wasCorrect && !_currentExercise.isRequeued) {
      _correctIds.add(_currentExercise.exerciseData.id);
    }
    if (wasSkipped) {
      _skippedCount++;
    }

    if (_remainingHearts <= 0) {
      widget.onExit?.call();
      Navigator.of(context).pop();
      return;
    }

    // Handle skipped exercises - filter out future exercises of this type
    if (wasSkipped) {
      final skippedType = _currentExercise.exerciseData.type;

      // Remove all future exercises of the skipped type
      _exerciseQueue = [
        ..._exerciseQueue.sublist(0, _currentExerciseIndex + 1),
        ..._exerciseQueue
            .sublist(_currentExerciseIndex + 1)
            .where((exercise) => exercise.exerciseData.type != skippedType),
      ];
    }

    // Handle incorrect answer re-queueing
    if (!wasCorrect && !wasSkipped && widget.requeueIncorrectAnswers) {
      final exerciseId = _currentExercise.exerciseData.id;

      final requeuedExercise = _currentExercise.copyWith(
        isRequeued: true,
        key: UniqueKey(),
      );

      _exerciseQueue.add(requeuedExercise);
      widget.onExerciseRequeued?.call(exerciseId);
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
      // All exercises completed - calculate stats and trigger completion callback
      final stats = LessonStats(
        correctExerciseIds: _correctIds,
        skippedExerciseIds: _skippedIds,
        xp: _correctIds.length * 2,
        timeTaken: DateTime.now().difference(_startTime),
        accuracy: (widget.exercises.length - _skippedCount) > 0
            ? _correctIds.length / (widget.exercises.length - _skippedCount)
            : 0.0,
        remainingHearts: _remainingHearts,
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          widget.onLessonCompletion(context, stats);
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
      case ExerciseState.skipped:
        return DesignColors.attention;
    }
  }

  String _getButtonText() {
    switch (_exerciseState) {
      case ExerciseState.initial:
        return 'CHECK';
      case ExerciseState.checking:
        return 'CHECKING...';
      case ExerciseState.correct:
      case ExerciseState.skipped:
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
                LessonTopBar(
                  onExit: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Exit'),
                        content: Text(
                          'Are you sure you want to exit the lesson?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              widget.onExit?.call();
                            },
                            child: Text('Exit'),
                          ),
                        ],
                      ),
                    );
                  },
                  progress: _progress,
                  remainingHearts: _remainingHearts,
                ),

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

                LessonControls(
                  exerciseType: _currentExercise.exerciseData.type,
                  exerciseState: _exerciseState,
                  buttonAnimation: _buttonAnimation,
                  handleCheck: _handleCheck,
                  handleSkip: _handleSkip,
                  buttonText: _getButtonText(),
                  buttonColor: _getButtonColor(),
                ),
              ],
            ),

            FeedbackPanel(
              exerciseState: _exerciseState,
              currentFeedbackMessage: _currentFeedbackMessage,
              currentCorrectAnswer: _currentCorrectAnswer,
              handleContinue: _handleContinue,
              feedbackSlideAnimation: _feedbackSlideAnimation,
              buttonText: _getButtonText(),
              buttonColor: _getButtonColor(),
            ),
          ],
        ),
      ),
    );
  }
}
