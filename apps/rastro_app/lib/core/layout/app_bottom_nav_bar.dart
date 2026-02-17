import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rastro/core/routing/app_routes.dart';
import 'app_nav_item.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = AppRoutes.tabs;
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFromLocation(location);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(60, 0, 60, bottomPadding),
      child: _NavBarBackground(
        child: Row(
          children: List.generate(tabs.length, (i) {
            return Expanded(
              child: NavItem(
                tab: tabs[i],
                isSelected: i == currentIndex,
                onTap: () => context.go(tabs[i].path),
              ),
            );
          }),
        ),
      ),
    );
  }

  int _indexFromLocation(String location) {
    final tabs = AppRoutes.tabs;
    final index = tabs.indexWhere(
          (tab) => tab.path != AppRoutes.home && location.startsWith(tab.path),
    );
    return index == -1 ? 0 : index;
  }
}

class _NavBarBackground extends StatelessWidget {
  const _NavBarBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFF2F2F2).withValues(alpha: 0.65),
                const Color(0xFFE6E6E6).withValues(alpha: 0.75),
                const Color(0xFFF2F2F2).withValues(alpha: 0.65),
              ],
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
