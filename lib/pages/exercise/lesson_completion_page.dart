import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/lesson_stats.dart';

class LessonCompletionPage extends StatefulWidget {
  final LessonStats stats;

  const LessonCompletionPage({super.key, required this.stats});

  @override
  State<LessonCompletionPage> createState() => _LessonCompletionPageState();
}

class _LessonCompletionPageState extends State<LessonCompletionPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(DesignSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Character illustration placeholder
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: DesignColors.backgroundCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.celebration_rounded,
                    color: DesignColors.primary,
                    size: 60,
                  ),
                ),
              ),

              SizedBox(height: DesignSpacing.lg),

              // Title - Dynamic based on accuracy
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  _getTitleText(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: DesignColors.primary,
                  ),
                ),
              ),

              SizedBox(height: DesignSpacing.md),

              // Subtitle - Dynamic based on performance
              SlideTransition(
                position: _slideAnimation,
                child: Text(
                  _getSubtitleText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: DesignColors.textSecondary,
                  ),
                ),
              ),

              SizedBox(height: DesignSpacing.xxl),

              // Stats Row
              SlideTransition(
                position: _slideAnimation,
                child: Row(
                  spacing: DesignSpacing.md,
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildStatCard(
                        icon: Icons.bolt_rounded,
                        label: "TOTAL XP",
                        value: "${widget.stats.xp}",
                        color: DesignColors.primary,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildStatCard(
                        icon: Icons.check_circle_rounded,
                        label: "ACCURACY",
                        value: widget.stats.formattedAccuracy,
                        color: DesignColors.success,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildStatCard(
                        icon: Icons.access_time_rounded,
                        label: "TIME",
                        value: widget.stats.formattedTime,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: DesignSpacing.xxxl * 2),

              // Claim XP Button
              SlideTransition(
                position: _slideAnimation,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle claim XP action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "CLAIM XP",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: DesignColors.backgroundDark,
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

  String _getTitleText() {
    final accuracy = widget.stats.accuracy;
    if (accuracy == 1.0) {
      return "Perfect!";
    } else if (accuracy >= 0.8) {
      return "Great job!";
    } else {
      return "Good effort!";
    }
  }

  String _getSubtitleText() {
    final accuracy = widget.stats.accuracy;
    if (accuracy == 1.0) {
      return "Scientists should study your big,\nbeautiful brain.";
    } else if (accuracy >= 0.8) {
      return "You're making excellent progress.\nKeep it up!";
    } else {
      return "Every mistake is a step closer\nto mastery.";
    }
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(DesignSpacing.md),
          decoration: BoxDecoration(
            color: DesignColors.backgroundCard,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              top: BorderSide(color: color, width: 32),
              right: BorderSide(color: color, width: 2),
              bottom: BorderSide(color: color, width: 2),
              left: BorderSide(color: color, width: 2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20, fill: 1,),
              SizedBox(width: DesignSpacing.xs),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: DesignColors.backgroundDark,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
