import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  static final List<BottomNavItemData> _navItems = AppRoutes.tabs
      .map(
        (tab) => BottomNavItemData(
          icon: tab.icon,
          activeIcon: tab.activeIcon,
          label: tab.label,
        ),
      )
      .toList();

  static int _indexFromLocation(String location) {
    final tabs = AppRoutes.tabs;
    final index = tabs.indexWhere(
      (tab) => tab.path != AppRoutes.home && location.startsWith(tab.path),
    );
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return DsNavigationBar(
      currentIndex: _indexFromLocation(location),
      items: _navItems,
      onItemSelected: (index) => context.go(AppRoutes.tabs[index].path),
    );
  }
}
