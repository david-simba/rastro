import 'package:driver_app/core/routing/app_routes.dart';
import 'package:driver_app/core/routing/auth_redirect.dart';
import 'package:driver_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:driver_app/features/route_selection/presentation/screens/route_selection_screen.dart';
import 'package:driver_app/features/tracking/presentation/screens/tracking_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = AuthRouterNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.auth,
    refreshListenable: notifier,
    redirect: (context, state) => authRedirect(ref, context, state),
    routes: [
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.routeSelection,
        builder: (context, state) => const RouteSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.tracking,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>;
          return TrackingScreen(
            vehicleId: extra['vehicleId']!,
            routeId: extra['routeId']!,
            routeName: extra['routeName']!,
          );
        },
      ),
    ],
  );
});
