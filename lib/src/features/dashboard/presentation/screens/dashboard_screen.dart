import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_app/src/features/dashboard/presentation/dashboard_controller.dart';
import 'package:habitos_app/src/features/dashboard/presentation/screens/home_screen.dart';
import 'package:habitos_app/src/features/dashboard/presentation/screens/profile_screen.dart';
import 'package:habitos_app/src/features/dashboard/presentation/screens/settings_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(dashboardIndexProvider);

    final screens = const [
      HomeScreen(),
      ProfileScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          index == 0
              ? "Home"
              : index == 1
                  ? "Perfil"
                  : "Ajustes",
        ),
        actions: [
          
        ],
      ),
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          ref.read(dashboardIndexProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Ajustes",
          ),
        ],
      ),
    );
  }
}
