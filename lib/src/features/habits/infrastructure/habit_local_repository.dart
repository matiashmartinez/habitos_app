import 'package:uuid/uuid.dart';
import '../domain/habit.dart';

class HabitLocalRepository {
  final List<Habit> habits = [];
  final _uuid = const Uuid();

  /// Carga todos los hábitos
  Future<List<Habit>> loadHabits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(habits);
  }

  /// Agrega un nuevo hábito
  Future<void> addHabit(String userId, String title, String description) async {


    habits.add(Habit(
      id: _uuid.v4(),        // id único del hábito
      userId: userId,        // id del usuario
      title: title,
      description: description,
      completed: false,
      completedDates: [],
      createdAt: DateTime.now(),
    ));
  }

  /// Alterna el estado de completado de un hábito
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

  /// Elimina un hábito
  Future<void> deleteHabit(String id) async {
    habits.removeWhere((h) => h.id == id);
  }

  /// Actualiza título y descripción de un hábito
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
