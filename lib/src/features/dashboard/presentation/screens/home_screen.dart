import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../habits/application/habit_notifier.dart';
import '../../../habits/domain/habit_state.dart';
import '../../../habits/presentation/screens/habit_create_screen.dart';
import '../../../habits/presentation/screens/habit_edit_screen.dart';
import '../../../habits/domain/habit.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitNotifierProvider);

    if (state is HabitLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is HabitError) {
      return Center(child: Text(state.message));
    } else if (state is HabitLoaded) {
      final pendingHabits = state.habits.where((h) => !h.completed).toList();
      final completedHabits = state.habits.where((h) => h.completed).toList();

      final completedCount = completedHabits.length;
      final pendingCount = pendingHabits.length;

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HabitCreateScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            // Gráfico de pastel
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: completedCount.toDouble(),
                        color: Colors.green,
                        title: 'Completados',
                        radius: 50,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: pendingCount.toDouble(),
                        color: Colors.red,
                        title: 'Pendientes',
                        radius: 50,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 30,
                  ),
                ),
              ),
            ),
            // Contadores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _counterCard("Pendientes", pendingCount, Colors.red),
                  _counterCard("Completados", completedCount, Colors.green),
                  _counterCard("Total", state.habits.length, Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Lista de hábitos
            Expanded(
              child: ListView(
                children: [
                  if (pendingHabits.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Pendientes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ...pendingHabits.map((habit) => _habitTile(context, ref, habit)),
                  if (completedHabits.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Completados',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ...completedHabits.map((habit) => _habitTile(context, ref, habit)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _counterCard(String label, int count, Color color) {
    return Card(
      color: color.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "$count",
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _habitTile(BuildContext context, WidgetRef ref, Habit habit) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(
          habit.title,
          style: TextStyle(
            decoration: habit.completed ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: habit.description.isNotEmpty
            ? Text(
                habit.description,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              )
            : null,
        leading: Checkbox(
          value: habit.completed,
          onChanged: (_) {
            ref.read(habitNotifierProvider.notifier).toggleHabit(habit.id);
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => HabitEditScreen(habit: habit)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ref.read(habitNotifierProvider.notifier).deleteHabit(habit.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
