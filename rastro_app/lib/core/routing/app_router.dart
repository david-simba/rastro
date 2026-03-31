import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:rastro/core/layout/app_shell.dart';
import 'package:rastro/core/routing/app_routes.dart';
import 'package:rastro/features/auth/presentation/screens/auth_screen.dart';
import 'package:rastro/features/home/presentation/screens/home_screen.dart';
import 'package:rastro/features/map/presentation/screens/map_screen.dart';
import 'package:rastro/features/routes/presentation/screens/routes_screen.dart';
import 'package:rastro/features/profile/presentation/screens/profile_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.auth,
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.map,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.routes,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RoutesScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});
