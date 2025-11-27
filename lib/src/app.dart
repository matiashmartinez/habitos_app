import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/domain/auth_state.dart';
import 'features/auth/presentation/auth_notifier.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Inicialización por defecto (never null)
    Widget screen = const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );

    switch (authState) {
      case AuthUnauthenticated():
        screen = const LoginScreen();
        break;

      case AuthLoading():
        screen = const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
        break;

      case AuthAuthenticated():
        screen = const DashboardScreen();
        break;

      default:
        screen = const LoginScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Modular App',
      home: screen,
    );
  }
}
