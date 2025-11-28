import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_app/src/features/dashboard/presentation/screens/settings_screen.dart';
import 'package:habitos_app/src/features/habits/presentation/screens/habit_create_screen.dart';
import '../dashboard_controller.dart';
import 'home_screen.dart';
import 'profile_screen.dart';



class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(dashboardIndexProvider);

    final screens = [
      const HomeScreen(),
      const ProfileScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(index == 0
            ? "Mis Hábitos"
            : index == 1
                ? "Perfil"
                : "Ajustes"),
      ),
      body: screens[index],
      floatingActionButton: index == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const HabitCreateScreen()));
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          ref.read(dashboardIndexProvider.notifier).state = value;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ajustes"),
        ],
      ),
    );
  }
}
