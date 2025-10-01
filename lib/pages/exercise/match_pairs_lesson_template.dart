import 'package:flutter/material.dart';

import 'package:lisan_app/design/theme.dart';

import 'package:lisan_app/models/lesson_stats.dart';
import 'package:lisan_app/models/match_pairs_exercise_data.dart';

import 'package:lisan_app/widgets/exercise/instruction_text.dart';
import 'package:lisan_app/widgets/exercise/lesson_top_bar.dart';
import 'package:lisan_app/widgets/exercise/match_item_widget.dart';

import 'package:lisan_app/root_screen.dart';

class MatchPairsLessonTemplate extends StatefulWidget {
  final MatchPairsExerciseData exerciseData;
  final void Function(BuildContext context, LessonStats stats)
  onLessonCompletion;
  final VoidCallback? onExit;
  final int hearts;
  final int itemsPerRound;

  const MatchPairsLessonTemplate({
    super.key,
    required this.exerciseData,
    required this.onLessonCompletion,
    this.onExit,
    this.hearts = 5,
    this.itemsPerRound = 5,
  });

  @override
  State<MatchPairsLessonTemplate> createState() =>
      _MatchPairsLessonTemplateState();
}

class _MatchPairsLessonTemplateState extends State<MatchPairsLessonTemplate>
    with TickerProviderStateMixin {
  // State management
  late List<MatchItem> _remainingLeftItems;
  late List<MatchItem> _remainingRightItems;
  late List<CorrectPair> _remainingPairs;

  final List<MatchItem> _currentLeftItems = [];
  final List<MatchItem> _currentRightItems = [];

  String? _selectedLeftId;
  String? _selectedRightId;

  final Set<String> _matchedLeftIds = {};
  final Set<String> _matchedRightIds = {};

  final Map<String, MatchItemState> _leftItemStates = {};
  final Map<String, MatchItemState> _rightItemStates = {};

  late int _remainingHearts;
  int _totalCorrectMatches = 0;

  // Stats tracking
  late DateTime _startTime;
  final List<String> _correctPairIds = [];

  // Animation controllers
  late AnimationController _newItemsController;
  late Animation<double> _newItemsAnimation;

  int _roundCorrectMatches = 0;

  @override
  void initState() {
    super.initState();

    _startTime = DateTime.now();
    _remainingHearts = widget.hearts;

    // Initialize remaining items and pairs
    _remainingLeftItems = List.from(widget.exerciseData.leftItems);
    _remainingRightItems = List.from(widget.exerciseData.rightItems);
    _remainingPairs = List.from(widget.exerciseData.correctPairs);

    // Shuffle for variety
    _remainingLeftItems.shuffle();
    _remainingRightItems.shuffle();

    // Animation setup
    _newItemsController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _newItemsAnimation = CurvedAnimation(
      parent: _newItemsController,
      curve: Curves.easeInOut,
    );

    // Load initial items
    _loadNextRound();
  }

  @override
  void dispose() {
    _newItemsController.dispose();
    super.dispose();
  }

  double get _progress {
    final totalPairs = widget.exerciseData.correctPairs.length;
    return totalPairs > 0 ? _totalCorrectMatches / totalPairs : 0.0;
  }

  bool get _isAudioType => widget.exerciseData.subtype == 'audio_text';

  void _loadNextRound() {
    _roundCorrectMatches = 0;

    final itemsToShow = widget.itemsPerRound;

    // Take up to itemsToShow pairs from remaining
    final pairsToShow = _remainingPairs.take(itemsToShow).toList();

    _currentLeftItems.clear();
    _currentRightItems.clear();

    // Get the left and right items for these pairs
    for (final pair in pairsToShow) {
      final leftItem = _remainingLeftItems.firstWhere(
        (item) => item.id == pair.leftId,
      );
      final rightItem = _remainingRightItems.firstWhere(
        (item) => item.id == pair.rightId,
      );

      _currentLeftItems.add(leftItem);
      _currentRightItems.add(rightItem);
    }

    // Shuffle the current items
    _currentLeftItems.shuffle();
    _currentRightItems.shuffle();

    // Reset item states
    _leftItemStates.clear();
    _rightItemStates.clear();

    for (final item in _currentLeftItems) {
      _leftItemStates[item.id] = MatchItemState.normal;
    }
    for (final item in _currentRightItems) {
      _rightItemStates[item.id] = MatchItemState.normal;
    }

    // Clear selections
    _selectedLeftId = null;
    _selectedRightId = null;

    // Animate in new items
    _newItemsController.forward();

    setState(() {});
  }

  void _onLeftItemTap(String itemId) {
    if (_matchedLeftIds.contains(itemId)) return;

    setState(() {
      // Clear previous selection
      if (_selectedLeftId != null) {
        _leftItemStates[_selectedLeftId!] = MatchItemState.normal;
      }

      _selectedLeftId = itemId;
      _leftItemStates[itemId] = MatchItemState.selected;

      // Check for match if both items selected
      if (_selectedRightId != null) {
        _checkMatch();
      }
    });
  }

  void _onRightItemTap(String itemId) {
    if (_matchedRightIds.contains(itemId)) return;

    setState(() {
      // Clear previous selection
      if (_selectedRightId != null) {
        _rightItemStates[_selectedRightId!] = MatchItemState.normal;
      }

      _selectedRightId = itemId;
      _rightItemStates[itemId] = MatchItemState.selected;

      // Check for match if both items selected
      if (_selectedLeftId != null) {
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    if (_selectedLeftId == null || _selectedRightId == null) return;

    // Find if this is a correct pair
    final isCorrectMatch = _remainingPairs.any(
      (pair) =>
          pair.leftId == _selectedLeftId && pair.rightId == _selectedRightId,
    );

    if (isCorrectMatch) {
      _handleCorrectMatch();
    } else {
      _handleIncorrectMatch();
    }
  }

  void _handleCorrectMatch() {
    setState(() {
      // Mark items as matched
      _matchedLeftIds.add(_selectedLeftId!);
      _matchedRightIds.add(_selectedRightId!);

      // Increment both total *and* per-round counters
      _totalCorrectMatches++;
      _roundCorrectMatches++;
      _correctPairIds.add('${_selectedLeftId}_$_selectedRightId');

      _leftItemStates[_selectedLeftId!] = MatchItemState.matched;
      _rightItemStates[_selectedRightId!] = MatchItemState.matched;
    });

    // Remove the matched pair from remaining
    _remainingPairs.removeWhere(
      (pair) =>
          pair.leftId == _selectedLeftId && pair.rightId == _selectedRightId,
    );

    _remainingLeftItems.removeWhere((item) => item.id == _selectedLeftId);
    _remainingRightItems.removeWhere((item) => item.id == _selectedRightId);

    // Clear selections
    _selectedLeftId = null;
    _selectedRightId = null;

    // Check if round is complete
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      // Use _roundCorrectMatches vs. current round size
      if (_roundCorrectMatches == _currentLeftItems.length) {
        if (_remainingPairs.isEmpty) {
          _completeLesson();
        } else {
          _newItemsController.reset();
          _loadNextRound();
        }
      }
    });
  }

  void _handleIncorrectMatch() {
    setState(() {
      _leftItemStates[_selectedLeftId!] = MatchItemState.error;
      _rightItemStates[_selectedRightId!] = MatchItemState.error;
      _remainingHearts--;
    });

    // Check for game over
    if (_remainingHearts <= 0) {
      widget.onExit?.call();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RootScreen()),
      );
      return;
    }

    // Clear selections after error animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _leftItemStates[_selectedLeftId!] = MatchItemState.normal;
          _rightItemStates[_selectedRightId!] = MatchItemState.normal;
          _selectedLeftId = null;
          _selectedRightId = null;
        });
      }
    });
  }

  void _completeLesson() {
    final stats = LessonStats(
      correctExerciseIds: _correctPairIds,
      skippedExerciseIds: [],
      xp: _totalCorrectMatches * 2,
      timeTaken: DateTime.now().difference(_startTime),
      accuracy: _totalCorrectMatches / widget.exerciseData.correctPairs.length,
      remainingHearts: _remainingHearts,
    );

    widget.onLessonCompletion(context, stats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            LessonTopBar(
              onExit: widget.onExit,
              progress: _progress,
              remainingHearts: _remainingHearts,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(DesignSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InstructionText(
                      instruction: widget.exerciseData.instruction,
                    ),
                    const SizedBox(height: DesignSpacing.xxxl * 3),

                    Expanded(
                      child: FadeTransition(
                        opacity: _newItemsAnimation,
                        child: Row(
                          children: [
                            // Left Column
                            Expanded(
                              child: Column(
                                children: _currentLeftItems.map((item) {
                                  return MatchItemWidget(
                                    key: ValueKey('left_${item.id}'),
                                    item: item,
                                    state:
                                        _leftItemStates[item.id] ??
                                        MatchItemState.normal,
                                    onTap: () => _onLeftItemTap(item.id),
                                    isAudioType: _isAudioType,
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(width: DesignSpacing.lg),

                            // Right Column
                            Expanded(
                              child: Column(
                                children: _currentRightItems.map((item) {
                                  return MatchItemWidget(
                                    key: ValueKey('right_${item.id}'),
                                    item: item,
                                    state:
                                        _rightItemStates[item.id] ??
                                        MatchItemState.normal,
                                    onTap: () => _onRightItemTap(item.id),
                                    isAudioType:
                                        false, // Right column is always text
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
