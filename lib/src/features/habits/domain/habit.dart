class Habit {
  final String id;
  final String title;
  final String description; // ← agregar
  final bool completed;
  final DateTime createdAt;
  final List<DateTime> completedDates;

  Habit({
    required this.id,
    required this.title,
    this.description = "", // valor por defecto
    this.completed = false,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  })  : createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? [];

  Habit copyWith({
    String? id,
    String? title,
    String? description, // ← agregar
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
