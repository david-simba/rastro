import 'package:driver_app/core/routing/app_routes.dart';
import 'package:driver_app/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthRouterNotifier extends ChangeNotifier {
  AuthRouterNotifier(Ref ref) {
    ref.listen(authSessionProvider, (_, _) => notifyListeners());
  }
}

String? authRedirect(Ref ref, BuildContext context, GoRouterState state) {
  final authState = ref.read(authSessionProvider);
  if (authState.isLoading) return null;

  final isLoggedIn = authState.asData?.value != null;
  final isAuthRoute = state.matchedLocation == AppRoutes.auth;

  if (!isLoggedIn && !isAuthRoute) return AppRoutes.auth;
  if (isLoggedIn && isAuthRoute) return AppRoutes.routeSelection;
  return null;
}
