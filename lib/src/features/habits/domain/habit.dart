class Habit {
  final String id;
  final String title;
  final String description; // descripción del hábito
  final bool completed;
  final DateTime createdAt;
  final List<DateTime> completedDates; // historial de completados

  Habit({
    required this.id,
    required this.title,
    this.description = "",
    this.completed = false,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  })  : createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? [];

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      completedDates: completedDates ?? List.from(this.completedDates),
    );
  }
}
