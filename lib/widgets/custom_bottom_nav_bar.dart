import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:lisan_app/design/style.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 6),
            Icon(
              icon,
              size: 32,
              fill: isSelected ? 1 : 0,
              color: isSelected
                  ? DesignColors.lightGold
                  : DesignColors.tertiaryText.withAlpha((0.5 * 255).toInt()),
            ),
            SizedBox(height: 6),
            Container(
              height: 2,
              width: 18,
              decoration: BoxDecoration(
                color: isSelected
                    ? DesignColors.primaryGold
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: DesignColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignColors.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: DesignColors.darkestBg.withAlpha((0.8 * 255).toInt()),
            blurRadius: 20,
            offset: Offset(0, -2),
          ),
        ],
      ),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Symbols.home_rounded, 0),
          _buildNavItem(Symbols.trophy, 1),
          _buildNavItem(Symbols.person_rounded, 2),
        ],
      ),
    );
  }
}
