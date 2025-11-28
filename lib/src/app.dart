// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/domain/auth_state.dart';
import 'features/auth/presentation/auth_notifier.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: switch (authState) {
        AuthLoading() => const Scaffold(
            body: Center(child: CircularProgressIndicator())),
        AuthAuthenticated() => const DashboardScreen(),
        AuthUnauthenticated() => const LoginScreen(),
      },
    );
  }
}
