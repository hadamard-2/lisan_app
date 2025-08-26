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

    // Auto-scroll to center current league after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentLeague();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentLeague() {
    final currentIndex = leagues.indexWhere(
      (league) => league['current'] == true,
    );
    if (currentIndex != -1) {
      const itemWidth = 92.5; // Trophy width + spacing
      final screenWidth = MediaQuery.of(context).size.width;
      final targetOffset =
          (currentIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
      );
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentLeague['name']} League',
                    style: const TextStyle(
                      color: DesignColors.textPrimary,
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
                padding: EdgeInsets.symmetric(
                  horizontal: DesignSpacing.md,
                  vertical: DesignSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: DesignColors.primary.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: DesignColors.primary.withAlpha((0.3 * 255).toInt()),
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

          const SizedBox(height: 24),

          // Horizontal scrollable league progression
          SizedBox(
            height: 120,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < leagues.length; i++) ...[
                    _buildLeagueTrophy(leagues[i], i),
                    if (i < leagues.length - 1) _buildProgressConnector(i),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressConnector(int index) {
    final isCompleted = leagues[index]['unlocked'] == true;
    final nextIsUnlocked =
        index + 1 < leagues.length && leagues[index + 1]['unlocked'] == true;

    return Container(
      width: 24,
      height: 3,
      margin: const EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: isCompleted && nextIsUnlocked
            // ? DesignColors.primaryGold.withAlpha((0.2 * 255).toInt())
            ? DesignColors.backgroundBorder
            : DesignColors.backgroundBorder.withAlpha((0.3 * 255).toInt()),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildLeagueTrophy(Map<String, dynamic> league, int index) {
    final color = league['color'] as Color;
    final isUnlocked = league['unlocked'] as bool;
    final isCurrent = league['current'] == true;
    final name = league['name'] as String;

    return SizedBox(
      width: 65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trophy container with animation
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color
                  : DesignColors.backgroundBorder.withAlpha(
                      (0.3 * 255).toInt(),
                    ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: color.withAlpha((0.4 * 255).toInt()),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ]
                  : isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withAlpha((0.2 * 255).toInt()),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
              border: isCurrent ? Border.all(color: color, width: 2) : null,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: isUnlocked
                      ? DesignColors.backgroundDark
                      : Colors.transparent,
                  size: 24,
                ),
                if (!isUnlocked)
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: DesignColors.backgroundDark.withAlpha(
                        (0.2 * 255).toInt(),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.lock,
                      color: DesignColors.textTertiary,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // League name
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: isCurrent
                  ? color
                  : isUnlocked
                  ? DesignColors.textPrimary
                  : DesignColors.textTertiary,
              fontSize: 10,
              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),

          // Current indicator
          SizedBox(
            height: 16,
            child: isCurrent
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'CURRENT',
                      style: TextStyle(
                        color: _getContrastingTextColor(color),
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _getContrastingTextColor(Color backgroundColor) {
    // Calculate luminance to determine if text should be dark or light
    final red = (backgroundColor.r * 255.0).round() & 0xff;
    final green = (backgroundColor.g * 255.0).round() & 0xff;
    final blue = (backgroundColor.b * 255.0).round() & 0xff;

    final luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;

    return luminance > 0.5 ? DesignColors.backgroundDark : Colors.white;
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
          color: colors[rank]!.withAlpha((0.2 * 255).toInt()),
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

          // XP and protection time
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
        color: DesignColors.success.withAlpha((0.1 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: DesignColors.success.withAlpha((0.3 * 255).toInt()),
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
