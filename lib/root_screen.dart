import 'package:flutter/material.dart';
import 'package:lisan_app/pages/practice/fidel_practice_page.dart';
import 'package:lisan_app/pages/home_page.dart';
import 'package:lisan_app/pages/leaderboard_page.dart';
import 'package:lisan_app/pages/user_stats_page.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:lisan_app/design/theme.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _pageIndex = 0;
  void _onNavItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  final _pages = [
    HomePage(),
    LeaderboardPage(),
    UserStatsPage(),
    FidelPracticePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: Stack(
          children: [
            // your page content
            _pages[_pageIndex],

            // the floating nav bar
            Positioned(
              bottom: 12,
              left: 16,
              right: 16,
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(16),
                color: DesignColors.backgroundCard,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: DesignColors.backgroundBorder,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Symbols.home_rounded, 0),
                      _buildNavItem(Symbols.trophy, 1),
                      _buildNavItem(Symbols.person_rounded, 2),
                      _buildFidelNavItem(3),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _pageIndex == index;
    return GestureDetector(
      onTap: () => _onNavItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 6),
            Icon(
              icon,
              size: 32,
              fill: isSelected ? 1 : 0,
              color: isSelected
                  ? DesignColors.primary
                  : DesignColors.textTertiary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 6),
            Container(
              height: 2,
              width: 18,
              decoration: BoxDecoration(
                color: isSelected ? DesignColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFidelNavItem(int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const FidelPracticePage()),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 57,
        height: 57,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DesignColors.primary, width: 2),
        ),
        child: Center(
          child: Text(
            'ሀሁ',
            style: TextStyle(
              color: DesignColors.primary,
              fontFamily: 'Neteru',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
