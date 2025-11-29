import 'package:uuid/uuid.dart';
import '../domain/habit.dart';

class HabitLocalRepository {
  final List<Habit> habits = [];
  final _uuid = const Uuid();

  Future<List<Habit>> loadHabits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(habits);
  }

  Future<void> addHabit(String title, String description) async {
    habits.add(Habit(id: _uuid.v4(), title: title, description: description));
  }

  Future<void> toggleHabit(String id) async {
    final index = habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = habits[index];
      final now = DateTime.now();
      List<DateTime> updatedDates = List.from(habit.completedDates);

      if (!habit.completed) {
        updatedDates.add(now); // marca como completado hoy
      } else {
        // elimina la fecha de hoy si se desmarca
        updatedDates.removeWhere((d) =>
            d.year == now.year && d.month == now.month && d.day == now.day);
      }

      habits[index] = habit.copyWith(
        completed: !habit.completed,
        completedDates: updatedDates,
      );
    }
  }

  Future<void> deleteHabit(String id) async {
    habits.removeWhere((h) => h.id == id);
  }

  Future<void> updateHabit(String id, String title, String description) async {
    final index = habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final habit = habits[index];
      habits[index] = habit.copyWith(
        title: title,
        description: description,
      );
    }
  }
}
