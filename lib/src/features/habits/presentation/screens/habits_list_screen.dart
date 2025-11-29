import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitos_app/src/features/habits/application/habit_notifier.dart';
import 'package:habitos_app/src/features/habits/domain/habit_state.dart';
import 'package:habitos_app/src/features/habits/domain/habit.dart';

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

                        return Dismissible(
                          key: Key(habit.id),
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              _showEditDialog(context, notifier, habit);
                              return false;
                            } else if (direction ==
                                DismissDirection.endToStart) {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirm'),
                                  content: const Text(
                                      'Do you want to delete this habit?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel')),
                                    TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete')),
                                  ],
                                ),
                              );
                              return confirm ?? false;
                            }
                            return false;
                          },
                          onDismissed: (direction) {
                            if (direction == DismissDirection.endToStart) {
                              notifier.deleteHabit(habit.id);
                            }
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              habit.title,
                              style: TextStyle(
                                decoration: habit.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(habit.description),
                                const SizedBox(height: 4),
                                Text(
                                    'Created: ${habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}'),
                                Text(
                                    'Last modified: ${habit.completedDates.isNotEmpty ? "${habit.completedDates.last.day}/${habit.completedDates.last.month}/${habit.completedDates.last.year}" : habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}'),
                              ],
                            ),
                            leading: Checkbox(
                              value: habit.completed,
                              onChanged: (_) =>
                                  notifier.toggleHabit(habit.id),
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, notifier),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, HabitNotifier notifier) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.addHabit(
                  titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
      BuildContext context, HabitNotifier notifier, Habit habit) {
    final titleController = TextEditingController(text: habit.title);
    final descriptionController =
        TextEditingController(text: habit.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Habit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.updateHabit(
                  habit.id, titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
