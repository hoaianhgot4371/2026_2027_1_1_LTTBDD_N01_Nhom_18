import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/data/habit_store.dart';
import 'package:nhip_song/models/habit.dart';

void main() {
  Habit habit(String id, int day) => Habit(
    id: id,
    name: id,
    category: HabitCategory.health,
    createdAt: DateTime(2026, 11, day),
  );
  late HabitStore store;
  setUp(
    () => store = HabitStore(
      initialHabits: [habit('a', 8), habit('b', 10)],
      clock: () => DateTime(2026, 11, 10, 12),
    ),
  );

  test('Reject future, before creation and unknown habit; normalize time', () {
    expect(store.setCompleted('a', DateTime(2026, 11, 11), true), isFalse);
    expect(store.setCompleted('a', DateTime(2026, 11, 7), true), isFalse);
    expect(store.setCompleted('missing', store.today, true), isFalse);
    expect(store.setCompleted('a', DateTime(2026, 11, 10, 23), true), isTrue);
    expect(store.completedCount(store.today), 1);
    expect(store.progress(store.today), .5);
    store.setCompleted('a', store.today, false);
    expect(store.progress(store.today), 0);
  });
  test('Daily denominator excludes habits not yet created; zero is safe', () {
    store.setCompleted('a', DateTime(2026, 11, 8), true);
    expect(store.progress(DateTime(2026, 11, 8)), 1);
    expect(store.progress(DateTime(2026, 11, 7)), 0);
  });
  test(
    'Edit preserves creation/history, delete removes completion, ids unique',
    () {
      store.setCompleted('a', store.today, true);
      store.update(
        Habit(
          id: 'a',
          name: 'Edited',
          note: 'note',
          category: HabitCategory.personal,
          createdAt: store.today,
        ),
      );
      expect(store.habits.first.createdAt, DateTime(2026, 11, 8));
      expect(store.isCompleted('a', store.today), isTrue);
      expect(store.add(habit('a', 10)), isFalse);
      expect(store.nextId(), isNot(store.nextId()));
      store.delete('a');
      expect(store.completedCount(store.today), 0);
      expect(store.isCompleted('a', store.today), isFalse);
    },
  );
  test(
    'Streak tolerates incomplete today, breaks at gap, resets with new store',
    () {
      store.setCompleted('a', DateTime(2026, 11, 8), true);
      store.setCompleted('a', DateTime(2026, 11, 9), true);
      expect(store.streak('a'), 2);
      store.setCompleted('a', store.today, true);
      expect(store.streak('a'), 3);
      store.setCompleted('a', DateTime(2026, 11, 9), false);
      expect(store.streak('a'), 1);
      expect(
        HabitStore(initialHabits: store.habits).completedCount(store.today),
        0,
      );
    },
  );
}
