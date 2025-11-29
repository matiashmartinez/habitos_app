/* import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/habit.dart';
import '../domain/habit_state.dart';
import '../infrastructure/habit_local_repository.dart';

final habitNotifierProvider =
    NotifierProvider<HabitNotifier, HabitState>(HabitNotifier.new);

class HabitNotifier extends Notifier<HabitState> {
  late HabitLocalRepository _repository;

  @override
  HabitState build() {
    _repository = HabitLocalRepository();
    _load();
    return HabitLoading();
  }

  Future<void> _load() async {
    try {
      final list = await _repository.loadHabits();
      state = HabitLoaded(List.from(list));
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Error loading habits');
    }
  }

  Future<void> addHabit(String title, String description) async {
    try {
      await _repository.addHabit(title, description);
      await _load();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to add habit');
    }
  }

  Future<void> toggleHabit(String id) async {
    try {
      await _repository.toggleHabit(id);
      await _load();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to toggle habit');
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _repository.deleteHabit(id);
      await _load();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to delete habit');
    }
  }

  Future<void> updateHabit(String id, String title, String description) async {
    try {
      await _repository.updateHabit(id, title, description);
      await _load();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to update habit');
    }
  }

  // --- Estadísticas usando completedDates --- //

  List<Habit> habitsCompletedToday() {
    if (state is HabitLoaded) {
      return (state as HabitLoaded)
          .habits
          .completedOnDate(DateTime.now());
    }
    return [];
  }

  List<Habit> habitsCompletedThisWeek() {
    if (state is HabitLoaded) {
      return (state as HabitLoaded)
          .habits
          .completedInWeek(DateTime.now());
    }
    return [];
  }

  List<Habit> habitsCompletedThisMonth() {
    if (state is HabitLoaded) {
      return (state as HabitLoaded)
          .habits
          .completedInMonth(DateTime.now());
    }
    return [];
  }
}

// --- Extensiones para estadísticas --- //
extension HabitStats on List<Habit> {
  List<Habit> completedOnDate(DateTime date) {
    return where((habit) => habit.completedDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day)).toList();
  }

  List<Habit> completedInWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return where((habit) => habit.completedDates.any((d) =>
        !d.isBefore(startOfWeek) && !d.isAfter(endOfWeek))).toList();
  }

  List<Habit> completedInMonth(DateTime date) {
    return where((habit) => habit.completedDates.any((d) =>
        d.year == date.year && d.month == date.month)).toList();
  }
}
 */

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/habit.dart';
import '../domain/habit_state.dart';
import '../infrastructure/habit_local_repository.dart';

final habitNotifierProvider =
    NotifierProvider<HabitNotifier, HabitState>(HabitNotifier.new);

class HabitNotifier extends Notifier<HabitState> {
  late HabitLocalRepository _repository;

  @override
  HabitState build() {
    _repository = HabitLocalRepository();
    _load();
    return HabitLoading();
  }

  Future<void> _load() async {
    try {
      final list = await _repository.loadHabits();
      state = HabitLoaded(List.from(list));
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Error loading habits');
    }
  }

  Future<void> addHabit(String title, String description) async {
    try {
      await _repository.addHabit(title, description);
      await _load();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to add habit');
    }
  }

  Future<void> updateHabit(String id, String newTitle, String newDescription) async {
    try {
      final index = _repository.habits.indexWhere((h) => h.id == id);
      if (index != -1) {
        final habit = _repository.habits[index];
        _repository.habits[index] = habit.copyWith(
          title: newTitle,
          description: newDescription,
        );
        await _load();
      }
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to update habit');
    }
  }

  Future<void> toggleHabit(String id) async {
    try {
      final index = _repository.habits.indexWhere((h) => h.id == id);
      if (index != -1) {
        final habit = _repository.habits[index];
        final completedDates = List<DateTime>.from(habit.completedDates);
        if (!habit.completed) {
          completedDates.add(DateTime.now());
        }
        _repository.habits[index] =
            habit.copyWith(completed: !habit.completed, completedDates: completedDates);
        await _load();
      }
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to toggle habit');
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      await _repository.deleteHabit(id);
      await _load();
    } catch (e) {
      if (kDebugMode) debugPrint(e.toString());
      state = HabitError('Unable to delete habit');
    }
  }

  // Métodos auxiliares para estadísticas por fechas
  List<Habit> completedOnDate(DateTime date) {
    if (state is! HabitLoaded) return [];
    return (state as HabitLoaded)
        .habits
        .where((h) => h.completedDates.any((d) =>
            d.year == date.year && d.month == date.month && d.day == date.day))
        .toList();
  }

  List<Habit> completedThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    if (state is! HabitLoaded) return [];
    return (state as HabitLoaded)
        .habits
        .where((h) => h.completedDates.any(
            (d) => d.isAfter(startOfWeek.subtract(const Duration(days: 1))) && d.isBefore(endOfWeek.add(const Duration(days: 1)))))
        .toList();
  }

  List<Habit> completedThisMonth() {
    final now = DateTime.now();
    if (state is! HabitLoaded) return [];
    return (state as HabitLoaded)
        .habits
        .where((h) => h.completedDates.any((d) => d.year == now.year && d.month == now.month))
        .toList();
  }
}
