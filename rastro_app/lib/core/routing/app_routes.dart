import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

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
  static const routes = '/routes';
  static const profile = '/profile';

  static const List<AppRouteItem> tabs = [
    AppRouteItem(
      path: home,
      label: 'Inicio',
      icon: LucideIcons.house,
      activeIcon: LucideIcons.house,
    ),
    AppRouteItem(
      path: map,
      label: 'Mapa',
      icon: LucideIcons.map,
      activeIcon: LucideIcons.map,
    ),
    AppRouteItem(
      path: routes,
      label: 'Rutas',
      icon: LucideIcons.route,
      activeIcon: LucideIcons.route,
    ),
    AppRouteItem(
      path: profile,
      label: 'Perfil',
      icon: LucideIcons.user,
      activeIcon: LucideIcons.user,
    ),
  ];
}
