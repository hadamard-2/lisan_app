import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/models/lesson_stats.dart';
import 'package:lisan_app/root_screen.dart';

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

  bool _isClaimingXP = false;
  late Dio _dio;

  @override
  void initState() {
    super.initState();

    // Initialize Dio
    _dio = Dio();
    // NOTE - I need to replace this with the URL Abel gives me
    _dio.options.baseUrl = 'http://insect-famous-ghastly.ngrok-free.app/api';
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

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

  Future<void> _claimXP() async {
    // if (_isClaimingXP) return; // Prevent multiple taps

    // setState(() {
    //   _isClaimingXP = true;
    // });

    // try {
    //   final response = await _dio.post(
    //     '/lessons/complete',
    //     data: widget.stats.toJson(),
    //   );

    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     // Success - show success message
    //     if (mounted) {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         const SnackBar(
    //           content: Text('XP claimed successfully!'),
    //           backgroundColor: DesignColors.success,
    //         ),
    //       );

    //       // Navigate back or to next screen
    //       Navigator.of(context).pop();
    //     }
    //   }
    // } catch (e) {
    //   // Handle error
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Failed to claim XP: ${e.toString()}'),
    //         backgroundColor: DesignColors.error,
    //         action: SnackBarAction(label: 'RETRY', onPressed: _claimXP),
    //       ),
    //     );
    //   }
    // } finally {
    //   if (mounted) {
    //     setState(() {
    //       _isClaimingXP = false;
    //     });
    //   }
    // }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RootScreen()));
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
                        icon: Icons.star_rounded,
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
                    onPressed: _isClaimingXP ? null : _claimXP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isClaimingXP
                          ? DesignColors.backgroundBorder
                          : Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isClaimingXP
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: DesignColors.backgroundDark,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
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
