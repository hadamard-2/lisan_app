import 'package:flutter/material.dart';
import 'package:lisan_app/design/theme.dart';

// Mock data model
class User {
  final int id;
  final String name;
  final int xp;
  final String country;
  final int streak;
  final bool online;

  User({
    required this.id,
    required this.name,
    required this.xp,
    required this.country,
    required this.streak,
    this.online = false,
  });
}

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  // Mock data matching the screenshot
  final List<User> mockUsers = [
    User(
      id: 1,
      name: 'Salmann',
      xp: 1145,
      country: '🇺🇸',
      streak: 28,
      online: true,
    ),
    User(id: 2, name: 'Rawand Alammori', xp: 1135, country: '🇫🇷', streak: 8),
    User(id: 3, name: 'Iyob G.', xp: 1091, country: '🇫🇷', streak: 31),
    User(
      id: 4,
      name: 'kübra',
      xp: 636,
      country: '🇺🇸',
      streak: 15,
      online: true,
    ),
    User(id: 5, name: 'алиса', xp: 375, country: '🇪🇸', streak: 11),
    User(
      id: 6,
      name: 'Den Kot',
      xp: 297,
      country: '🇺🇸',
      streak: 15,
      online: true,
    ),
    User(id: 7, name: 'Yarenn Altaş', xp: 0, country: '🇺🇸', streak: 16),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        LeaderboardHeader(),

        // Leaderboard List
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 120),
            itemCount: mockUsers.length,
            itemBuilder: (context, index) {
              final user = mockUsers[index];
              final rank = index + 1;
              final isPromotionZone = rank == 6;

              return Column(
                children: [
                  if (isPromotionZone) PromotionZoneWidget(),
                  LeaderboardItem(user: user, rank: rank),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class LeaderboardHeader extends StatefulWidget {
  const LeaderboardHeader({super.key});

  @override
  State<LeaderboardHeader> createState() => _LeaderboardHeaderState();
}

class _LeaderboardHeaderState extends State<LeaderboardHeader> {
  late ScrollController _scrollController;

  // Define all leagues with their colors and unlock status
  final List<Map<String, dynamic>> leagues = const [
    {'name': 'Bronze', 'color': Color(0xFFCD7F32), 'unlocked': true},
    {'name': 'Silver', 'color': Color(0xFFC0C0C0), 'unlocked': true},
    {'name': 'Gold', 'color': Color(0xFFFFD700), 'unlocked': true},
    {'name': 'Sapphire', 'color': Color(0xFF0F52BA), 'unlocked': true},
    {'name': 'Ruby', 'color': Color(0xFFE0115F), 'unlocked': true},
    {'name': 'Emerald', 'color': Color(0xFF50C878), 'unlocked': true},
    {
      'name': 'Amethyst',
      'color': Color(0xFF9966CC),
      'unlocked': true,
      'current': true,
    },
    {'name': 'Pearl', 'color': Color(0xFFF8F6F0), 'unlocked': false},
    {'name': 'Obsidian', 'color': Color(0xFF3C3C3C), 'unlocked': false},
    {'name': 'Diamond', 'color': Color(0xFFB9F2FF), 'unlocked': false},
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLeague = leagues.firstWhere(
      (league) => league['current'] == true,
      orElse: () => leagues[6],
    );

    final currentIndex = leagues.indexWhere(
      (league) => league['current'] == true,
    );

    return Container(
      padding: EdgeInsets.all(DesignSpacing.lg),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // League name and timer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentLeague['name']} League',
                    style: TextStyle(
                      color: currentLeague['color'],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'League ${currentIndex + 1} of ${leagues.length}',
                    style: TextStyle(
                      color: DesignColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: DesignSpacing.xs),
                padding: EdgeInsets.symmetric(
                  horizontal: DesignSpacing.md,
                  vertical: DesignSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: DesignColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: DesignColors.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: DesignColors.primary,
                      size: 16,
                    ),
                    SizedBox(width: DesignSpacing.xs),
                    const Text(
                      '4 DAYS',
                      style: TextStyle(
                        color: DesignColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LeaderboardItem extends StatelessWidget {
  final User user;
  final int rank;

  const LeaderboardItem({super.key, required this.user, required this.rank});

  Widget getRankWidget() {
    if (rank <= 3) {
      final colors = {
        1: DesignColors.primary,
        2: Color(0xFFC0C0C0), // Silver
        3: Color(0xFFCD7F32), // Bronze
      };

      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: colors[rank]!.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors[rank]!, width: 2),
        ),
        child: Center(
          child: Text(
            rank.toString(),
            style: TextStyle(
              color: colors[rank]!,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 32,
      child: Text(
        rank.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: DesignColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: DesignSpacing.lg),
      padding: EdgeInsets.symmetric(vertical: DesignSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: DesignColors.backgroundBorder, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Rank
          getRankWidget(),

          SizedBox(width: DesignSpacing.md),

          // Avatar with indicators
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: DesignColors.backgroundCard,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: DesignColors.backgroundBorder,
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: DesignColors.textSecondary,
                  size: 24,
                ),
              ),

              // Achievement badge
              if (user.online)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: DesignColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: DesignColors.backgroundDark,
                        width: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: DesignSpacing.md),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          color: DesignColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2),

                Row(
                  children: [
                    Text(user.country, style: TextStyle(fontSize: 14)),
                    SizedBox(width: DesignSpacing.xs),
                    Text(
                      user.streak.toString(),
                      style: TextStyle(
                        color: DesignColors.textTertiary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // XP time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${user.xp} XP',
                style: TextStyle(
                  color: DesignColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PromotionZoneWidget extends StatelessWidget {
  const PromotionZoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: DesignSpacing.lg,
        vertical: DesignSpacing.md,
      ),
      padding: EdgeInsets.symmetric(vertical: DesignSpacing.md),
      decoration: BoxDecoration(
        color: DesignColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: DesignColors.success.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.keyboard_arrow_up, color: DesignColors.success, size: 20),
          SizedBox(width: DesignSpacing.xs),
          Text(
            'PROMOTION ZONE',
            style: TextStyle(
              color: DesignColors.success,
              fontWeight: FontWeight.w800,
              fontSize: 14,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(width: DesignSpacing.xs),
          Icon(Icons.keyboard_arrow_up, color: DesignColors.success, size: 20),
        ],
      ),
    );
  }
}
