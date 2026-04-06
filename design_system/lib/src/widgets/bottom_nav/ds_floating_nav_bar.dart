import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

const double _kIconSize = 16.0;

class DsNavigationBar extends StatelessWidget {
  const DsNavigationBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onItemSelected,
  }) : assert(items.length >= 2);

  final int currentIndex;
  final List<BottomNavItemData> items;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = Platform.isAndroid ? MediaQuery.of(context).padding.bottom + 5 : DsLayout.spacingMd;

    return _NavBarBackground(
      bottomPadding: bottomPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
              (i) => _NavItem(
            item: items[i],
            isSelected: i == currentIndex,
            onTap: () => onItemSelected(i),
          ),
        ),
      ),
    );
  }
}

class _NavBarBackground extends StatelessWidget {
  const _NavBarBackground({
    required this.child,
    required this.bottomPadding,
  });

  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.dsColors.surface,
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        top: DsLayout.spacingXs,
      ),
      child: SizedBox(
        height: DsLayout.navBarHeight,
        child: Center(child: child),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final BottomNavItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = context.dsColors.muted;

    final selectedBgColor = isDark ? DsColors.blue500 : DsColors.blue50;
    final selectedContentColor = isDark ? DsColors.white : DsColors.blue500;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: DsLayout.spacingXs,
          vertical: DsLayout.spacingXs,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: DsLayout.spacingSm,
          horizontal: DsLayout.spacingXxl,
        ),
        decoration: BoxDecoration(
          color: isSelected ? selectedBgColor : Colors.transparent,
          borderRadius: DsLayout.borderRadiusLg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: _kIconSize,
              color: isSelected ? selectedContentColor : inactiveColor,
            ),
            const SizedBox(height: 2),
            DsText(
              item.label,
              variant: isSelected ? TextVariant.medium2 : TextVariant.regular2,
              color: isSelected ? selectedContentColor : inactiveColor,
            ),
          ],
        ),
      ),
    );
  }
}