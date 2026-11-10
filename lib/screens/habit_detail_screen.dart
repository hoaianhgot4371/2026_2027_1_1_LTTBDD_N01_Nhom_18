import '../language.dart';

import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../models/habit.dart';
import 'add_habit_screen.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.store, required this.id});
  final HabitStore store;
  final String id;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) {
      final matches = store.habits.where((h) => h.id == id);
      if (matches.isEmpty) return Scaffold();
      final habit = matches.first;
      return Scaffold(
        appBar: AppBar(
          title: Text(context.tr('Chi tiết thói quen', 'Habit details')),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(habit.name, style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 16),
            Text(
              habit.note.isEmpty
                  ? context.tr('Chưa có ghi chú', 'No note yet')
                  : habit.note,
            ),
            SizedBox(height: 16),
            Text(
              context.tr(
                'Ngày tạo: ${habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}',
                'Created: ${habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}',
              ),
            ),
            SizedBox(height: 24),
            FilledButton.icon(
              icon: Icon(Icons.edit_outlined),
              label: Text(context.tr('Sửa thói quen', 'Edit habit')),
              onPressed: () async {
                final edited = await Navigator.of(context).push<Habit>(
                  MaterialPageRoute(
                    builder: (_) => AddHabitScreen(id: id, habit: habit),
                  ),
                );
                if (edited != null) store.update(edited);
              },
            ),
            SizedBox(height: 12),
            OutlinedButton.icon(
              icon: Icon(Icons.delete_outline),
              label: Text(context.tr('Xóa thói quen', 'Delete habit')),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.tr('Xóa thói quen?', 'Delete habit?')),
                    content: Text(
                      context.tr(
                        'Xóa “${habit.name}” và toàn bộ đánh dấu hoàn thành? Không thể hoàn tác.',
                        'Delete “${habit.name}” and all its completions? This cannot be undone.',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(context.tr('Hủy', 'Cancel')),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(context.tr('Xóa', 'Delete')),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && context.mounted) {
                  Navigator.pop(context);
                  store.delete(id);
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
