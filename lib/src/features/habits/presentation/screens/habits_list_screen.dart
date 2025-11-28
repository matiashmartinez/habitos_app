import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_app/src/features/habits/application/habit_notifier.dart';
import 'package:habitos_app/src/features/habits/domain/habit_state.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(habitNotifierProvider);
    final notifier = ref.read(habitNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: state is HabitLoading
          ? const Center(child: CircularProgressIndicator())
          : state is HabitError
              ? Center(child: Text(state.message))
              : state is HabitLoaded
                  ? ListView.builder(
                      itemCount: state.habits.length,
                      itemBuilder: (context, index) {
                        final habit = state.habits[index];
                        return ListTile(
                          title: Text(
                            habit.title,
                            style: TextStyle(
                              decoration: habit.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          leading: Checkbox(
                            value: habit.completed,
                            onChanged: (_) => notifier.toggleHabit(habit.id),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => notifier.deleteHabit(habit.id),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titleController = TextEditingController();
          final result = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('New Habit'),
              content: TextField(controller: titleController),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, titleController.text),
                  child: const Text('Add'),
                ),
              ],
            ),
          );

          if (result != null && result.isNotEmpty) {
            await notifier.addHabit(result,result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
