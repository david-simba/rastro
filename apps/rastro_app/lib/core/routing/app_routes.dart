import 'package:flutter/material.dart';

class AppRouteItem {
  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const AppRouteItem({
    required this.path,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

abstract final class AppRoutes {
  static const home = '/';
  static const map = '/map';

  static const List<AppRouteItem> tabs = [
    AppRouteItem(
      path: home,
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    AppRouteItem(
      path: map,
      label: 'Map',
      icon: Icons.map_outlined,
      activeIcon: Icons.map,
    ),
  ];
}
