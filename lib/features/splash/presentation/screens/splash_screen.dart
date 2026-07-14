import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// Shown while the app boots. Runs the progress-bar animation for a minimum
/// display duration matching the reference design (~2.4s), then navigates on
/// once [AuthProvider] has also finished restoring its persisted status
/// (whichever finishes last) — see `core/router/app_router.dart` for how the
/// router guards `/login`/`/home` afterward.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..forward();
    _controller.addStatusListener(_onAnimationStatusChanged);
    _authProvider.addListener(_maybeNavigate);
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) _maybeNavigate();
  }

  void _maybeNavigate() {
    if (!mounted) return;
    if (_controller.isCompleted && _authProvider.status != AuthStatus.unknown) {
      _authProvider.removeListener(_maybeNavigate);
      context.go(_authProvider.status == AuthStatus.authenticated ? AppRoutes.home : AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onAnimationStatusChanged);
    _authProvider.removeListener(_maybeNavigate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryContainer,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.6),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Icon(Icons.explore, color: AppColors.inversePrimary, size: 56),
            ),
            const SizedBox(height: 40),
            Text(
              'SalatTime',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 30,
                  ),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: 144,
              height: 3,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) => ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation(AppColors.inversePrimary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
