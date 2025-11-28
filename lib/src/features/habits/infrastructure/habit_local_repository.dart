import 'package:uuid/uuid.dart';
import '../domain/habit.dart';

class HabitLocalRepository {
  final List<Habit> habits = [];
  final _uuid = const Uuid();

  Future<List<Habit>> loadHabits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return habits;
  }

  Future<void> addHabit(String title, String description) async {
    habits.add(Habit(id: _uuid.v4(), title: title, description: description));
  }

  Future<void> toggleHabit(String id) async {
    final index = habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      final h = habits[index];
      List<DateTime> dates = List.from(h.completedDates);
      if (!h.completed) {
        dates.add(DateTime.now());
      } else {
        dates.removeLast();
      }
      habits[index] = h.copyWith(completed: !h.completed, completedDates: dates);
    }
  }

  Future<void> deleteHabit(String id) async {
    habits.removeWhere((h) => h.id == id);
  }
}
