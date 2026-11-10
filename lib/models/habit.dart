enum HabitCategory { health, learning, mindfulness, personal }

class Habit {
  final String id;
  final String name;
  final String note;
  final HabitCategory category;
  final int iconIndex;
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.name,
    this.note = '',
    required this.category,
    this.iconIndex = 0,
    required DateTime createdAt,
  }) : createdAt = DateTime(createdAt.year, createdAt.month, createdAt.day);

  bool isAvailableOn(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return !day.isBefore(createdAt);
  }
}
