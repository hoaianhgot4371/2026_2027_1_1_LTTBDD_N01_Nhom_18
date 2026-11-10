import 'package:flutter/material.dart';

import '../models/habit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final habits = [
      Habit(
        id: 'water',
        name: 'Uống đủ nước',
        note: 'Một ly nước nhỏ, một khởi đầu tốt.',
        category: HabitCategory.health,
        createdAt: today,
      ),
      Habit(
        id: 'reading',
        name: 'Đọc sách 15 phút',
        note: 'Dành thời gian cho một điều mới.',
        category: HabitCategory.learning,
        createdAt: today,
      ),
      Habit(
        id: 'breathe',
        name: 'Hít thở thư giãn',
        note: 'Chậm lại và lắng nghe bản thân.',
        category: HabitCategory.mindfulness,
        createdAt: today,
      ),
      Habit(
        id: 'journal',
        name: 'Viết nhật ký',
        note: 'Ghi lại một điều khiến bạn biết ơn.',
        category: HabitCategory.personal,
        createdAt: today,
      ),
    ].where((habit) => habit.isAvailableOn(today)).toList();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhịp Sống'),
        leading: const Icon(Icons.spa_outlined),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'HÔM NAY · ${today.day}/${today.month}/${today.year}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Một chút mỗi ngày,\nmột nhịp sống tốt hơn.',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Bắt đầu từ những việc nhỏ và dành thời gian cho bạn.',
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Bạn đang xem dữ liệu mẫu. Dữ liệu chỉ lưu trong RAM và sẽ mất khi đóng ứng dụng.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Thói quen hôm nay',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text('${habits.length} thói quen mẫu dành cho bạn'),
                const SizedBox(height: 16),
                for (final habit in habits) _HabitCard(habit: habit),
                const SizedBox(height: 8),
                const Text(
                  'Mỗi bước nhỏ đều có ý nghĩa.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  const _HabitCard({required this.habit});
  final Habit habit;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (habit.category) {
      HabitCategory.health => (
        'Sức khỏe',
        Icons.water_drop_outlined,
        Colors.blue,
      ),
      HabitCategory.learning => (
        'Học tập',
        Icons.menu_book_outlined,
        Colors.orange,
      ),
      HabitCategory.mindfulness => (
        'Tinh thần',
        Icons.self_improvement,
        Colors.teal,
      ),
      HabitCategory.personal => ('Cá nhân', Icons.edit_note, Colors.purple),
    };
    final theme = Theme.of(context);
    return Card(
      key: ValueKey(habit.id),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(
                    habit.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(habit.note),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
