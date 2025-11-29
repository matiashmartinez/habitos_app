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
            // 📊 Gráfico PieChart con mejor altura y espacio
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: completedHabits.length.toDouble(),
                        color: Colors.green,
                        title: 'Completados',
                        radius: 45,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PieChartSectionData(
                        value: pendingHabits.length.toDouble(),
                        color: Colors.red,
                        title: 'Pendientes',
                        radius: 45,
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            ),
            // 💳 Contadores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _counterCard("Pendientes", pendingHabits.length, Colors.red),
                  _counterCard("Completados", completedHabits.length, Colors.green),
                  _counterCard("Total", state.habits.length, Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 📝 Lista de hábitos con swipe
            Expanded(
              child: ListView(
                children: [
                  if (pendingHabits.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Pendientes',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ...pendingHabits.map((habit) => _habitTile(context, ref, habit)),
                  if (completedHabits.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Completados',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  // 🌟 Cada hábito ahora es un Dismissible para swipe
  Widget _habitTile(BuildContext context, WidgetRef ref, Habit habit) {
    final lastModified = habit.completedDates.isNotEmpty
        ? habit.completedDates.last
        : habit.createdAt;

    return Dismissible(
      key: Key(habit.id),
      background: Container(
        color: Colors.blue,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe a la derecha → Editar
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HabitEditScreen(habit: habit)),
          );
          return false; // No eliminar
        } else if (direction == DismissDirection.endToStart) {
          // Swipe a la izquierda → Eliminar
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Eliminar hábito'),
              content: const Text('¿Estás seguro de eliminar este hábito?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Eliminar'),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            ref.read(habitNotifierProvider.notifier).deleteHabit(habit.id);
          }
          return confirmed;
        }
        return false;
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: habit.completed,
            onChanged: (_) {
              ref.read(habitNotifierProvider.notifier).toggleHabit(habit.id);
            },
          ),
          title: Text(
            habit.title,
            style: TextStyle(
              decoration: habit.completed ? TextDecoration.lineThrough : null,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (habit.description.isNotEmpty)
                Text(
                  habit.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              const SizedBox(height: 4),
              Text(
                'Creado: ${habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}',
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
              Text(
                'Última modificación: ${lastModified.day}/${lastModified.month}/${lastModified.year}',
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
