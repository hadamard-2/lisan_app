import 'package:flutter/material.dart';
import 'dart:math';

import 'package:lisan_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _pathController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pathAnimation;

  final ScrollController _scrollController = ScrollController();
  int _currentUnitIndex = 0;

  // Constants for scroll calculation
  final double _headerHeight =
      280.0; // Height before units start (welcome + current indicator)
  final double _approximateUnitHeight = 650.0; // Approximate height per unit

  // Demo data
  final int streakCount = 47;
  final int hearts = 3;
  final int maxHearts = 5;
  final String userName = "Dwight";

  final List<UnitData> units = [
    UnitData(
      id: 1,
      title: "Basic Greetings",
      color: Colors.blue,
      lessons: [
        LessonNode(id: 1, title: "Hello & Goodbye", type: LessonType.completed),
        LessonNode(id: 2, title: "How are you?", type: LessonType.completed),
        LessonNode(id: 3, title: "Thank you", type: LessonType.completed),
        LessonNode(
          id: 4,
          title: "Please & Excuse me",
          type: LessonType.current,
        ),
        LessonNode(id: 5, title: "Yes & No", type: LessonType.locked),
        LessonNode(id: 6, title: "Nice to meet you", type: LessonType.locked),
      ],
    ),
    UnitData(
      id: 2,
      title: "Family & Friends",
      color: Colors.green,
      lessons: [
        LessonNode(id: 7, title: "My family", type: LessonType.locked),
        LessonNode(id: 8, title: "Brothers & sisters", type: LessonType.locked),
        LessonNode(id: 9, title: "Parents", type: LessonType.locked),
        LessonNode(id: 10, title: "Friends", type: LessonType.locked),
        LessonNode(id: 11, title: "Relationships", type: LessonType.locked),
        LessonNode(id: 12, title: "Ages", type: LessonType.locked),
      ],
    ),
    UnitData(
      id: 3,
      title: "Daily Activities",
      color: Colors.orange,
      lessons: [
        LessonNode(id: 13, title: "Morning routine", type: LessonType.locked),
        LessonNode(id: 14, title: "Work & school", type: LessonType.locked),
        LessonNode(id: 15, title: "Eating meals", type: LessonType.locked),
        LessonNode(id: 16, title: "Evening time", type: LessonType.locked),
        LessonNode(id: 17, title: "Weekend plans", type: LessonType.locked),
        LessonNode(id: 18, title: "Daily review", type: LessonType.locked),
      ],
    ),
    UnitData(
      id: 4,
      title: "Food & Drinks",
      color: Colors.purple,
      lessons: [
        LessonNode(id: 19, title: "Basic foods", type: LessonType.locked),
        LessonNode(id: 20, title: "Beverages", type: LessonType.locked),
        LessonNode(id: 21, title: "At restaurant", type: LessonType.locked),
        LessonNode(id: 22, title: "Cooking", type: LessonType.locked),
        LessonNode(id: 23, title: "Shopping", type: LessonType.locked),
        LessonNode(id: 24, title: "Food review", type: LessonType.locked),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pathController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _pathAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pathController, curve: Curves.easeOutCubic),
    );

    _scrollController.addListener(_scrollListener);

    _fadeController.forward();
    _pathController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _scrollListener() {
    // Calculate which unit is currently most visible
    final currentScroll = _scrollController.offset;

    // Account for the header section
    final scrollAfterHeader = currentScroll - _headerHeight;

    if (scrollAfterHeader < 0) {
      // Still in header area, show first unit
      if (_currentUnitIndex != 0) {
        setState(() => _currentUnitIndex = 0);
      }
      return;
    }

    // Simple calculation: divide scroll position by approximate unit height
    int newIndex = (scrollAfterHeader / _approximateUnitHeight).floor();

    // Clamp to valid range
    newIndex = newIndex.clamp(0, units.length - 1);

    if (newIndex != _currentUnitIndex) {
      setState(() => _currentUnitIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pathController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Mathematical positioning for smooth curves (sin wave with bigger amplitude)
  double _getLessonOffset(int lessonIndex) {
    const double amplitude = -90.0; // Increase for bigger wave
    const double frequency =
        pi / 3; // Controls wave period (6 lessons per cycle)
    return sin(lessonIndex * frequency) * amplitude;
  }

  Widget _buildTopNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Streak Counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2127),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1CC06)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🔥  $streakCount',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF1CC06),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Hearts Indicator
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Practice session coming soon!"),
                  backgroundColor: Color(0xFFF1CC06),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2127),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2A2D33)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_rounded, color: Colors.red, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    '$hearts',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Profile Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF1CC06), Color(0xFFFFD700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  "D",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14161B),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome back, $userName!",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ready to continue your Amharic journey?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFFB0B0B0),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentUnitIndicator() {
    if (_currentUnitIndex >= units.length) return const SizedBox.shrink();

    final currentUnit = units[_currentUnitIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: currentUnit.color,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          bottom: BorderSide(
            color: _darkenColor(currentUnit.color, 0.2),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: currentUnit.color.withAlpha(76),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "UNIT ${currentUnit.id} • CURRENTLY VIEWING",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUnit.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.book_rounded, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildAdventurePath() {
    List<Widget> pathWidgets = [];
    int globalLessonIndex = 0;

    for (int unitIndex = 0; unitIndex < units.length; unitIndex++) {
      final unit = units[unitIndex];

      // Unit divider
      pathWidgets.add(_buildUnitDivider(unit));
      pathWidgets.add(const SizedBox(height: 32));

      // Unit lessons
      for (
        int lessonIndex = 0;
        lessonIndex < unit.lessons.length;
        lessonIndex++
      ) {
        final lesson = unit.lessons[lessonIndex];

        // Add treasure chest after every 2nd lesson in each unit
        if (lessonIndex != 0 && lessonIndex % 2 == 0) {
          pathWidgets.add(_buildTreasureChest(globalLessonIndex));
          pathWidgets.add(const SizedBox(height: 32));
          globalLessonIndex++; // Increment for treasure chest position
        }

        pathWidgets.add(
          _buildLessonNode(lesson, globalLessonIndex, unit.color),
        );

        if (lessonIndex < unit.lessons.length - 1) {
          pathWidgets.add(const SizedBox(height: 32));
        }

        globalLessonIndex++;
      }

      // Add spacing between units
      if (unitIndex < units.length - 1) {
        pathWidgets.add(const SizedBox(height: 48));
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: pathWidgets),
    );
  }

  Widget _buildUnitDivider(UnitData unit) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFF2A2D33), thickness: 2)),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: unit.color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            unit.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(child: Divider(color: Color(0xFF2A2D33), thickness: 2)),
      ],
    );
  }

  Widget _buildTreasureChest(int globalIndex) {
    final offset = _getLessonOffset(globalIndex);

    return Transform.translate(
      offset: Offset(offset, 0),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFF1CC06),
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(
              color: _darkenColor(const Color(0xFFF1CC06), 0.2),
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF1CC06).withAlpha(76),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.card_giftcard_rounded,
          color: Color(0xFF14161B),
          size: 36,
        ),
      ),
    );
  }

  Widget _buildLessonNode(LessonNode lesson, int globalIndex, Color unitColor) {
    final offset = _getLessonOffset(globalIndex);

    return AnimatedBuilder(
      animation: _pathAnimation,
      builder: (context, child) {
        final shouldShow =
            _pathAnimation.value >= (globalIndex / (units.length * 6));

        return AnimatedOpacity(
          opacity: shouldShow ? 1.0 : 0.3,
          duration: const Duration(milliseconds: 300),
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: Column(
              children: [
                _buildLessonCircle(lesson, unitColor),
                const SizedBox(height: 12),
                SizedBox(
                  width: 120,
                  child: Text(
                    lesson.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: lesson.type == LessonType.locked
                          ? const Color(0xFF888888)
                          : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLessonCircle(LessonNode lesson, Color unitColor) {
    final baseColor = _getLessonCircleColor(lesson.type, unitColor);
    final size = 60.0;
    final shadowFactor = (lesson.type == LessonType.completed) ? 0.15 : 0.07;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Bottom layer (shadow/depth)
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _darkenColor(baseColor, shadowFactor),
          ),
        ),
        // Top layer (main button surface)
        Transform.translate(
          offset: const Offset(0, -6),
          child: Material(
            shape: const CircleBorder(),
            color: baseColor,
            child: SizedBox(
              width: size,
              height: size,
              child: InkWell(
                onTap: () => _onLessonTap(lesson),
                customBorder: const CircleBorder(),
                child: Center(child: _getLessonIcon(lesson.type)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getLessonCircleColor(LessonType type, Color unitColor) {
    switch (type) {
      case LessonType.completed:
        return unitColor;
      case LessonType.current:
      case LessonType.locked:
        return const Color(0xFF1E2127);
    }
  }

  Widget _getLessonIcon(LessonType type) {
    switch (type) {
      case LessonType.completed:
        return const Icon(Icons.check_rounded, color: Colors.white, size: 28);
      case LessonType.current:
        return Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32);
      case LessonType.locked:
        return const Icon(
          Icons.lock_rounded,
          color: Color(0xFF888888),
          size: 24,
        );
    }
  }

  Color _darkenColor(Color color, double factor) {
    return HSLColor.fromColor(color)
        .withLightness(
          (HSLColor.fromColor(color).lightness - factor).clamp(0.0, 1.0),
        )
        .toColor();
  }

  void _onLessonTap(LessonNode lesson) {
    if (lesson.type == LessonType.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complete previous lessons to unlock!"),
          backgroundColor: Color(0xFF888888),
        ),
      );
    } else if (lesson.type == LessonType.current) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Starting: ${lesson.title}"),
          backgroundColor: const Color(0xFFF1CC06),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF14161B),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildTopNavigation(),
              const SizedBox(height: 16),
              _buildWelcomeSection(),
              const SizedBox(height: 16),
              // Dynamic Current Unit Indicator (shows which unit is in viewport)
              _buildCurrentUnitIndicator(),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: _buildAdventurePath(),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Supporting classes
enum LessonType { completed, current, locked }

class LessonNode {
  final int id;
  final String title;
  final LessonType type;

  LessonNode({required this.id, required this.title, required this.type});
}

class UnitData {
  final int id;
  final String title;
  final Color color;
  final List<LessonNode> lessons;

  UnitData({
    required this.id,
    required this.title,
    required this.color,
    required this.lessons,
  });
}
