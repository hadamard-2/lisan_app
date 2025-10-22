import 'package:flutter/material.dart';

import 'package:lisan_app/models/lesson_node.dart';
import 'package:lisan_app/models/lesson_type.dart';
import 'package:lisan_app/models/unit_data.dart';

import 'package:lisan_app/widgets/home/adventure_path.dart';
import 'package:lisan_app/widgets/home/current_unit_indicator.dart';
import 'package:lisan_app/widgets/home/top_stats_bar.dart';
import 'package:lisan_app/widgets/home/welcome_section.dart';

class HomePage extends StatefulWidget {
  final double approximateUnitHeight = 925;

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

  // Demo data
  final int streakCount = 4;
  final int hearts = 3;
  final int maxHearts = 5;
  final String userName = "Jim";

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

    if (currentScroll < 0) {
      // Still in header area, show first unit
      if (_currentUnitIndex != 0) {
        setState(() => _currentUnitIndex = 0);
      }
      return;
    }

    // Simple calculation: divide scroll position by approximate unit height
    int newIndex = (currentScroll / widget.approximateUnitHeight).floor();

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

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          const SizedBox(height: 8),
          TopStatsBar(streakCount: streakCount, hearts: hearts),
          const SizedBox(height: 4),
          WelcomeSection(userName: userName),
          const SizedBox(height: 8),
          CurrentUnitIndicator(
            currentUnit: _currentUnitIndex < units.length
                ? units[_currentUnitIndex]
                : null,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: AdventurePath(
                units: units,
                pathAnimation: _pathAnimation,
                pulseController: _pulseController,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
