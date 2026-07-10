import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/shell/presentation/screens/app_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'app_routes.dart';

/// Auth-gated routing. [SplashScreen] owns the initial navigation away from
/// `/splash` itself (it waits for both its minimum display timer and
/// [authProvider] to finish restoring before calling `context.go`) — this
/// redirect only guards `/login` and `/home` against being reached with the
/// wrong auth status (e.g. deep link, browser back button, or auth changing
/// while already on one of those routes). [refreshListenable] re-runs
/// `redirect` whenever [authProvider] notifies.
GoRouter buildAppRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: (context, state) {
      final status = authProvider.status;
      final location = state.matchedLocation;

      if (location == AppRoutes.splash) return null;

      if (status == AuthStatus.unauthenticated && location == AppRoutes.home) {
        return AppRoutes.login;
      }
      if (status == AuthStatus.authenticated && location == AppRoutes.login) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: AppRoutes.home, builder: (context, state) => const AppShell()),
    ],
  );
}
