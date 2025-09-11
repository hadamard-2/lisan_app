import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lisan_app/design/theme.dart';
import 'package:lisan_app/pages/profile_page.dart';

class UserStatsPage extends StatefulWidget {
  const UserStatsPage({super.key});

  @override
  State<UserStatsPage> createState() => _UserStatsPageState();
}

class _UserStatsPageState extends State<UserStatsPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Demo user data
  final String userName = "Dwight Schrute";
  final String userInitials = "DS";
  final int streakCount = 47;
  final int totalXP = 2847;
  final String currentLeague = "Gold";
  final int daysActive = 63;
  final int lessonsCompleted = 89;
  final int wordsLearned = 342;
  final DateTime joinDate = DateTime(2024, 6, 15);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Color _generateProfileColor(String initials) {
    final colors = [
      DesignColors.primary, // Golden
      const Color(0xFFE67E22), // Orange
      const Color(0xFFE74C3C), // Red
      const Color(0xFF27AE60), // Green
      const Color(0xFF3498DB), // Blue
      const Color(0xFF9B59B6), // Purple
      const Color(0xFFF39C12), // Yellow-orange
      const Color(0xFF1ABC9C), // Turquoise
    ];

    int hash = initials.hashCode;
    return colors[hash.abs() % colors.length];
  }

  RadialGradient _getProfileGradient(String initials) {
    final baseColor = _generateProfileColor(initials);

    final alpha = (baseColor.a * 255.0).round() & 0xff;
    final red = (baseColor.r * 255.0).round() & 0xff;
    final green = (baseColor.g * 255.0).round() & 0xff;
    final blue = (baseColor.b * 255.0).round() & 0xff;

    // Create a lighter center and darker edge for depth
    final centerColor = Color.fromARGB(
      alpha,
      (red + 40).clamp(0, 255),
      (green + 40).clamp(0, 255),
      (blue + 40).clamp(0, 255),
    );

    final edgeColor = Color.fromARGB(
      alpha,
      (red - 30).clamp(0, 255),
      (green - 30).clamp(0, 255),
      (blue - 30).clamp(0, 255),
    );

    return RadialGradient(
      center: const Alignment(
        -0.3,
        -0.3,
      ), // Slight offset for more natural lighting
      radius: 1.2,
      colors: [centerColor, baseColor, edgeColor],
      stops: const [0.0, 0.6, 1.0],
    );
  }

  Widget _buildProfileHeader() {
    final profileGradient = _getProfileGradient(userInitials);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Profile Circle with Streak
          Stack(
            alignment: Alignment.center,
            children: [
              // Streak Ring
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: DesignColors.primary, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: DesignColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              // Profile Circle
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: profileGradient,
                ),
                child: Center(
                  child: Text(
                    userInitials,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              // Streak Badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: DesignColors.primary,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: DesignColors.backgroundDark,
                      width: 2,
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '🔥',
                          style: GoogleFonts.notoColorEmoji(fontSize: 18),
                        ),
                        TextSpan(
                          text: ' $streakCount',
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: DesignColors.backgroundDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          // Motivational Streak Message
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: DesignColors.backgroundCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: DesignColors.backgroundBorder),
            ),
            child: Text(
              _getStreakMessage(streakCount),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: DesignColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStreakMessage(int streak) {
    if (streak >= 365) return "🏆 Streak Master!";
    if (streak >= 100) return "🔥 On Fire!";
    if (streak >= 30) return "⚡ Unstoppable!";
    if (streak >= 7) return "🌟 Great Progress!";
    return "💪 Keep Going!";
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Primary Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.emoji_events,
                  label: "Total XP",
                  value: totalXP.toString(),
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.workspace_premium,
                  label: "League",
                  value: currentLeague,
                  isPrimary: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Secondary Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.calendar_today,
                  label: "Days Active",
                  value: daysActive.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.school,
                  label: "Lessons",
                  value: lessonsCompleted.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Third Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.psychology,
                  label: "Words Learned",
                  value: wordsLearned.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.today,
                  label: "Member Since",
                  value: "${joinDate.month}/${joinDate.year}",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    bool isPrimary = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary
              ? DesignColors.primary
              : DesignColors.backgroundBorder,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: const Color(
                    0xFFF1CC06,
                  ).withValues(alpha: 0.2), // 20% opacity
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isPrimary
                ? DesignColors.primary
                : DesignColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPrimary ? DesignColors.primary : Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: DesignColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        "icon": Icons.local_fire_department_rounded,
        "name": "Week Warrior",
        "earned": true,
      },
      {"icon": Icons.star_rounded, "name": "First Lesson", "earned": true},
      {
        "icon": Icons.trending_up_rounded,
        "name": "Progress Master",
        "earned": true,
      },
      {
        "icon": Icons.psychology_rounded,
        "name": "Word Explorer",
        "earned": true,
      },
      {
        "icon": Icons.emoji_events_rounded,
        "name": "XP Champion",
        "earned": false,
      },
      {
        "icon": Icons.military_tech_rounded,
        "name": "Streak Legend",
        "earned": false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Achievements",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                final isEarned = achievement["earned"] as bool;

                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: isEarned
                              ? DesignColors.primary
                              : DesignColors.backgroundBorder,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isEarned
                                ? DesignColors.primary
                                : DesignColors.backgroundBorder,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          achievement["icon"] as IconData,
                          color: isEarned
                              ? DesignColors.backgroundDark
                              : DesignColors.textTertiary,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 80,
                        child: Text(
                          achievement["name"] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isEarned
                                ? Colors.white
                                : DesignColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: DesignColors.backgroundDark,
              pinned: true,
              floating: false,
              snap: false,
              elevation: 0,
              scrolledUnderElevation: 6,
              shadowColor: Colors.black.withValues(alpha: 0.5),
              surfaceTintColor: Colors.transparent,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  padding: const EdgeInsets.only(top: 16, right: 24),
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()),
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildAchievements(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
