import 'package:flutter/material.dart';

import '../models/habit.dart';
import 'add_habit_screen.dart';
import '../data/habit_store.dart';
import 'habit_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HabitStore _store = HabitStore(initialHabits: _createSamples());

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  List<Habit> _createSamples() {
    final today = DateTime.now();
    return [
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
    ];
  }

  Future<void> _addHabit() async {
    final habit = await Navigator.of(context).push<Habit>(
      MaterialPageRoute(builder: (_) => AddHabitScreen(id: _store.nextId())),
    );
    if (!mounted || habit == null) return;
    setState(() => _store.add(habit));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final habits = _store.habits
        .where((habit) => habit.isAvailableOn(today))
        .toList();
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
                          'Danh sách ban đầu gồm 4 thói quen mẫu. Dữ liệu chỉ lưu trong RAM và sẽ mất khi đóng ứng dụng.',
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
                Text('${habits.length} thói quen dành cho bạn'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: _addHabit,
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm thói quen'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Đã hoàn thành ${habits.where((habit) => _store.isCompleted(habit.id, today)).length}/${habits.length} hôm nay',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                for (final habit in habits)
                  _HabitCard(
                    habit: habit,
                    isCompleted: _store.isCompleted(habit.id, today),
                    onOpen: () async {
                      await Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (_) =>
                              HabitDetailScreen(store: _store, id: habit.id),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                    onChanged: (value) => setState(
                      () => _store.setCompleted(habit.id, today, value),
                    ),
                  ),
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
  const _HabitCard({
    required this.habit,
    required this.isCompleted,
    required this.onChanged,
    required this.onOpen,
  });
  final Habit habit;
  final bool isCompleted;
  final ValueChanged<bool> onChanged;
  final VoidCallback onOpen;

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
                  TextButton(
                    onPressed: onOpen,
                    child: const Text('Xem chi tiết'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        key: ValueKey('complete-${habit.id}'),
                        value: isCompleted,
                        semanticLabel: 'Hoàn thành ${habit.name} hôm nay',
                        onChanged: (value) => onChanged(value ?? false),
                      ),
                      Flexible(
                        child: Text(
                          isCompleted ? 'Đã hoàn thành' : 'Chưa hoàn thành',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
