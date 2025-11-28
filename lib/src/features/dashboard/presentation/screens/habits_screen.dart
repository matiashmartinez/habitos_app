class Habit {
  final String id;
  final String title;
  final bool completed;

  Habit({
    required this.id,
    required this.title,
    this.completed = false,
  });

  Habit copyWith({String? id, String? title, bool? completed}) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
