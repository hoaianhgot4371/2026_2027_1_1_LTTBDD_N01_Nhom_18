import 'package:flutter/foundation.dart';

import '../models/habit.dart';

DateTime calendarDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// RAM-only source of truth. Completion is keyed by local calendar date.
class HabitStore extends ChangeNotifier {
  HabitStore({List<Habit>? initialHabits, DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      _habits = List.of(initialHabits ?? []);

  final DateTime Function() _clock;
  final List<Habit> _habits;
  final Map<DateTime, Set<String>> _completed = {};
  int _nextId = 0;
  DateTime get today => calendarDay(_clock());
  List<Habit> get habits => List.unmodifiable(_habits);
  String nextId() => 'habit-${_nextId++}';

  bool add(Habit habit) {
    if (_habits.any((h) => h.id == habit.id)) return false;
    _habits.add(habit);
    notifyListeners();
    return true;
  }

  bool update(Habit habit) {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index < 0) return false;
    final old = _habits[index];
    // Editing content must not rewrite creation dates or completion history.
    _habits[index] = Habit(
      id: old.id,
      name: habit.name,
      note: habit.note,
      category: habit.category,
      iconIndex: habit.iconIndex,
      createdAt: old.createdAt,
    );
    notifyListeners();
    return true;
  }

  void delete(String id) {
    _habits.removeWhere((h) => h.id == id);
    for (final ids in _completed.values) {
      ids.remove(id);
    }
    notifyListeners();
  }

  List<Habit> availableOn(DateTime date) =>
      _habits.where((h) => h.isAvailableOn(date)).toList();
  bool isCompleted(String id, DateTime date) =>
      _completed[calendarDay(date)]?.contains(id) ?? false;
  bool setCompleted(String id, DateTime date, bool value) {
    final day = calendarDay(date);
    final matches = _habits.where((h) => h.id == id);
    if (day.isAfter(today) ||
        matches.isEmpty ||
        !matches.first.isAvailableOn(day)) {
      return false;
    }
    final ids = _completed.putIfAbsent(day, () => {});
    if (value) {
      ids.add(id);
    } else {
      ids.remove(id);
    }
    notifyListeners();
    return true;
  }

  int completedCount(DateTime date) =>
      availableOn(date).where((h) => isCompleted(h.id, date)).length;
  double progress(DateTime date) {
    final count = availableOn(date).length;
    return count == 0 ? 0 : completedCount(date) / count;
  }

  /// Consecutive completed days ending today, or yesterday if today is incomplete.
  int streak(String id) {
    var day = today;
    if (!isCompleted(id, day)) day = DateTime(day.year, day.month, day.day - 1);
    var count = 0;
    while (isCompleted(id, day)) {
      count++;
      day = DateTime(day.year, day.month, day.day - 1);
    }
    return count;
  }
}
