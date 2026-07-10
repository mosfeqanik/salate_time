import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:salate_time/core/storage/local_storage_service.dart';
import 'package:salate_time/features/auth/data/auth_repository.dart';
import 'package:salate_time/features/auth/presentation/providers/auth_provider.dart';
import 'package:salate_time/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows the brand name and a progress indicator', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final authProvider = AuthProvider(AuthRepository(LocalStorageService()));

    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>.value(
        value: authProvider,
        child: const MaterialApp(home: SplashScreen()),
      ),
    );

    expect(find.text('SalatTime'), findsOneWidget);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
  });
}
