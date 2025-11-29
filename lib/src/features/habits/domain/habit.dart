class Habit {
  final String id; // ID único del hábito
  final String userId;
  final String title;
  final String description; // descripción del hábito
  final bool completed;
  final DateTime createdAt;
  final List<DateTime> completedDates; // historial de completados

  Habit({
    required this.id,
    required this.userId,
    required this.title,
    this.description = "",
    this.completed = false,
    DateTime? createdAt,
    List<DateTime>? completedDates,
  })  : createdAt = createdAt ?? DateTime.now(),
        completedDates = completedDates ?? [];

  Habit copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    bool? completed,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      completedDates: completedDates ?? List.from(this.completedDates),
    );
  }

  // --- Serialización / Deserialización --- //

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      completedDates: (json['completedDates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e as String))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt.toIso8601String(),
      'completedDates': completedDates.map((d) => d.toIso8601String()).toList(),
    };
  }
}
