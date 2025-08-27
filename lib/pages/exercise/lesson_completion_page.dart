import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

class LessonCompletionPage extends StatefulWidget {
  const LessonCompletionPage({super.key});

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
      body: Padding(
        padding: EdgeInsets.all(DesignSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Some illustration
            SizedBox(width: double.infinity, height: 120, child: Placeholder()),

            SizedBox(height: DesignSpacing.lg),

            // Title
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                "0 mistakes!",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: DesignColors.primary,
                ),
              ),
            ),

            SizedBox(height: DesignSpacing.md),

            // Subtitle
            SlideTransition(
              position: _slideAnimation,
              child: Text(
                "Scientists should study your big,\nbeautiful brain.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: DesignColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: DesignSpacing.xxxl),

            // Stats Row
            SlideTransition(
              position: _slideAnimation,
              child: Row(
                spacing: DesignSpacing.md,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildStatCard(
                      icon: Icons.star_rounded,
                      label: "TOTAL XP",
                      value: "40",
                      color: DesignColors.primary,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildStatCard(
                      icon: Icons.check_circle_rounded,
                      label: "AMAZING",
                      value: "100%",
                      color: DesignColors.success,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildStatCard(
                      icon: Icons.access_time_rounded,
                      label: "COMMITTED",
                      value: "6:30",
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
    );
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
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
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
