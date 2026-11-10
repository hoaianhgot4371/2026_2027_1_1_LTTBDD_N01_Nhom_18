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
      if (matches.isEmpty) return const Scaffold();
      final habit = matches.first;
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết thói quen')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(habit.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(habit.note.isEmpty ? 'Chưa có ghi chú' : habit.note),
            const SizedBox(height: 16),
            Text(
              'Ngày tạo: ${habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Sửa thói quen'),
              onPressed: () async {
                final edited = await Navigator.of(context).push<Habit>(
                  MaterialPageRoute(
                    builder: (_) => AddHabitScreen(id: id, habit: habit),
                  ),
                );
                if (edited != null) store.update(edited);
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_outline),
              label: const Text('Xóa thói quen'),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xóa thói quen?'),
                    content: Text(
                      'Xóa “${habit.name}” và toàn bộ đánh dấu hoàn thành? Không thể hoàn tác.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Hủy'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Xóa'),
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
