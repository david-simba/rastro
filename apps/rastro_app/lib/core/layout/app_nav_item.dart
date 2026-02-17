import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rastro/core/routing/app_routes.dart';

class NavItem extends StatelessWidget {
  final AppRouteItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  static const _duration = Duration(milliseconds: 200);
  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = const Color(0xFF6B7280);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: _duration,
        curve: _curve,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: _duration,
              switchInCurve: _curve,
              switchOutCurve: _curve,
              child: Icon(
                isSelected ? tab.activeIcon : tab.icon,
                key: ValueKey(isSelected),
                size: 20,
                color: isSelected ? Colors.white : inactiveColor,
              ),
            ),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: _duration,
              curve: _curve,
              style: TextStyle(
                color: isSelected ? Colors.white : inactiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 12,
              ),
              child: AppText(
                tab.label,
                variant: TextVariant.label,
                color: isSelected ? Colors.white : inactiveColor,
                bold: isSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
