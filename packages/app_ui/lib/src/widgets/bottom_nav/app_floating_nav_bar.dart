import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_item_data.dart';

const double _kHeight = 56.0;
const double _kBorderRadius = 32.0;

const double _kBorderOpacity = 0.6;

const double _kShadowBlur = 8.0;
const double _kShadowOpacity = 0.06;
const Offset _kShadowOffset = Offset(0, 2);

const Duration _kAnimDuration = Duration(milliseconds: 200);
const Curve _kAnimCurve = Curves.easeInOut;
const double _kItemBorderRadius = 24.0;
const double _kItemMargin = 4.0;
const double _kItemHorizontalPadding = 24.0;
const double _kIconSize = 20.0;
const double _kIconLabelSpacing = 6.0;
const double _kLabelFontSize = 12.0;
const Color _kInactiveColor = Color(0xFF6B7280);

class AppFloatingNavBar extends StatelessWidget {
  const AppFloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onItemSelected,
  }) : assert(items.length >= 2, 'AppFloatingNavBar requires at least 2 items.');

  final int currentIndex;
  final List<BottomNavItemData> items;
  final ValueChanged<int> onItemSelected;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavBarBackground(
            child: Row(
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
          ),
        ],
      ),
    );
  }
}

class _NavBarBackground extends StatelessWidget {
  const _NavBarBackground({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_kBorderRadius),
        border: Border.all(
          color: Colors.white.withValues(alpha: _kBorderOpacity),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, _kShadowOpacity),
            blurRadius: _kShadowBlur,
            offset: _kShadowOffset,
          ),
        ],
      ),
      child: child,
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
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: _kAnimDuration,
        curve: _kAnimCurve,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: _kItemHorizontalPadding),
        margin: const EdgeInsets.all(_kItemMargin),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(_kItemBorderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: _kIconSize,
              color: isSelected ? Colors.white : _kInactiveColor,
            ),
            ClipRect(
              child: AnimatedSize(
                duration: _kAnimDuration,
                curve: _kAnimCurve,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(left: _kIconLabelSpacing),
                        child: AnimatedOpacity(
                          opacity: isSelected ? 1.0 : 0.0,
                          duration: _kAnimDuration,
                          curve: _kAnimCurve,
                          child: Text(
                            item.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: _kLabelFontSize,
                            ),
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
