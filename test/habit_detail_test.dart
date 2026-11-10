import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/data/habit_store.dart';
import 'package:nhip_song/models/habit.dart';
import 'package:nhip_song/screens/habit_detail_screen.dart';

void main() {
  testWidgets(
    'Detail edit preserves creation and completion; deletion requires confirmation',
    (tester) async {
      final created = DateTime(2026, 11, 1);
      final store = HabitStore(
        initialHabits: [
          Habit(
            id: 'a',
            name: 'Original',
            note: 'Note',
            category: HabitCategory.health,
            createdAt: created,
          ),
        ],
      );
      store.setCompleted('a', store.today, true);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => HabitDetailScreen(store: store, id: 'a'),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Original'), findsOneWidget);
      await tester.tap(find.text('Sửa thói quen'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('habit-name')),
        ' Edited ',
      );
      await tester.tap(find.text('Lưu thói quen'));
      await tester.pumpAndSettle();
      expect(find.text('Edited'), findsOneWidget);
      expect(store.habits.single.createdAt, created);
      expect(store.isCompleted('a', store.today), isTrue);
      await tester.tap(find.text('Xóa thói quen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();
      expect(store.habits, hasLength(1));
      await tester.tap(find.text('Xóa thói quen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xóa'));
      await tester.pumpAndSettle();
      expect(store.habits, isEmpty);
      expect(store.isCompleted('a', store.today), isFalse);
      expect(find.text('Open'), findsOneWidget);
    },
  );
}
