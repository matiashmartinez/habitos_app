import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}
