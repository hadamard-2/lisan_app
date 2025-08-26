import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

enum ExerciseState { initial, checking, correct, incorrect }

enum ExerciseType { translation, speaking, multipleChoice, readAndRespond }

class ExerciseTemplate extends StatefulWidget {
  final Widget exerciseContent;
  final double progress;
  final int hearts;
  final bool showAudioHelper;
  final VoidCallback? onExit;
  final VoidCallback? onCheck;
  final VoidCallback? onContinue;
  final VoidCallback? onAudioHelper;
  final String? feedbackMessage;
  final String? correctAnswer;

  const ExerciseTemplate({
    super.key,
    required this.exerciseContent,
    this.progress = 0.0,
    this.hearts = 5,
    this.showAudioHelper = false,
    this.onExit,
    this.onCheck,
    this.onContinue,
    this.onAudioHelper,
    this.feedbackMessage,
    this.correctAnswer,
  });

  @override
  State<ExerciseTemplate> createState() => _ExerciseTemplateState();
}

class _ExerciseTemplateState extends State<ExerciseTemplate>
    with TickerProviderStateMixin {
  ExerciseState _exerciseState = ExerciseState.initial;
  late AnimationController _feedbackController;
  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;
  late Animation<Offset> _feedbackSlideAnimation;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _buttonController = AnimationController(
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
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _handleCheck() {
    setState(() {
      _exerciseState = ExerciseState.checking;
    });

    _buttonController.forward();

    // Simulate checking delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          // This would normally be determined by actual answer validation
          _exerciseState = ExerciseState.correct; // or ExerciseState.incorrect
        });
        _feedbackController.forward();
        widget.onCheck?.call();
      }
    });
  }

  void _handleContinue() {
    _feedbackController.reverse();
    _buttonController.reverse();
    setState(() {
      _exerciseState = ExerciseState.initial;
    });
    widget.onContinue?.call();
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
        return 'CONTINUE';
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

                // Main Content (Scrollable)
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(DesignSpacing.lg),
                    child: widget.exerciseContent,
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
                widthFactor: widget.progress,
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

                    if (widget.feedbackMessage != null) ...[
                      const SizedBox(height: DesignSpacing.md),
                      Text(
                        'Meaning:',
                        style: const TextStyle(
                          color: DesignColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: DesignSpacing.xs),
                      Text(
                        widget.feedbackMessage!,
                        style: TextStyle(
                          color: isCorrect
                              ? DesignColors.success
                              : DesignColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],

                    if (!isCorrect && widget.correctAnswer != null) ...[
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
                      Text(
                        widget.correctAnswer!,
                        style: const TextStyle(
                          color: DesignColors.success,
                          fontSize: 16,
                        ),
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
    return Container(
      padding: const EdgeInsets.all(DesignSpacing.md),
      child: Column(
        spacing: DesignSpacing.sm,
        children: [
          // Audio Helper Button (if needed)
          if (widget.showAudioHelper && _exerciseState == ExerciseState.initial)
            TextButton(
              onPressed: widget.onAudioHelper,
              child: const Text(
                "CAN'T SPEAK NOW",
                style: TextStyle(
                  color: DesignColors.textTertiary,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
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
}
