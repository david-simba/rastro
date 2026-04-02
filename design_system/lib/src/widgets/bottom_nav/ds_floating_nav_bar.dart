import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

const Duration _kAnimDuration = Duration(milliseconds: 200);
const Curve _kAnimCurve = Curves.easeInOut;
const double _kIconSize = 20.0;

class DsFloatingNavBar extends StatelessWidget {
  const DsFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onItemSelected,
  }) : assert(items.length >= 2, 'DsFloatingNavBar requires at least 2 items.');

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
  const _NavBarBackground({required this.child, required this.bottomPadding});
  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding, top: DsLayout.spacingXs),
      decoration: BoxDecoration(
        color: context.dsColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      child: SizedBox(height: DsLayout.navBarHeight, child: Center(child: child)),
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
    final inactiveColor = context.dsColors.muted;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: _kAnimDuration,
        curve: _kAnimCurve,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: DsLayout.spacingXxl),
        margin: const EdgeInsets.all(DsLayout.radiusXs),
        decoration: BoxDecoration(
          color: isSelected ? DsColors.blue500 : Colors.transparent,
          borderRadius: DsLayout.borderRadiusLg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: _kIconSize,
              color: isSelected ? DsColors.white : inactiveColor,
            ),
            ClipRect(
              child: AnimatedSize(
                duration: _kAnimDuration,
                curve: _kAnimCurve,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: DsLayout.spacingSm),
                        child: AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: _kAnimDuration,
                          curve: _kAnimCurve,
                          child: DsText(
                            item.label,
                            color: DsColors.white,
                            variant: TextVariant.medium2,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
