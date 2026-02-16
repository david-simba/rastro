import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/routing/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = AppRoutes.tabs;
    final location = GoRouterState.of(context).uri.path;
    final currentIndex = _indexFromLocation(location);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => context.go(tabs[i].path),
      selectedItemColor: Theme.of(context).colorScheme.primary,
      items: [
        BottomNavigationBarItem(
          icon: Icon(tabs[0].icon),
          activeIcon: Icon(tabs[0].activeIcon),
          label: tabs[0].label,
        ),
        BottomNavigationBarItem(
          icon: Icon(tabs[1].icon),
          activeIcon: Icon(tabs[1].activeIcon),
          label: tabs[1].label,
        ),
      ],
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
