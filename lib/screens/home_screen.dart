import 'package:flutter/material.dart';

import '../models/habit.dart';
import 'add_habit_screen.dart';
import '../data/habit_store.dart';
import 'habit_detail_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HabitStore _store = HabitStore(initialHabits: _createSamples());
  final _search = TextEditingController();

  @override
  void dispose() {
    _store.dispose();
    _search.dispose();
    super.dispose();
  }

  DateTime? _selectedDay;
  String _query = '';
  HabitCategory? _category;

  Future<void> _chooseDate() async {
    final created = _store.habits.map((h) => h.createdAt).toList()..sort();
    final first = created.isEmpty ? _store.today : created.first;
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDay ?? _store.today,
      firstDate: first,
      lastDate: _store.today,
    );
    if (date != null && mounted) setState(() => _selectedDay = date);
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
    setState(() {
      _store.add(habit);
      _selectedDay = null;
      _query = '';
      _search.clear();
      _category = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = _selectedDay ?? DateTime(now.year, now.month, now.day);

    final habits = _store.habits
        .where((habit) => habit.isAvailableOn(today))
        .toList();
    final visibleHabits = habits
        .where(
          (h) =>
              (_category == null || h.category == _category) &&
              ('${h.name} ${h.note}'.toLowerCase().contains(
                _query.trim().toLowerCase(),
              )),
        )
        .toList();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhịp Sống'),
        leading: const Icon(Icons.spa_outlined),
        actions: [
          IconButton(
            tooltip: 'Thống kê 7 ngày',
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => StatisticsScreen(store: _store),
              ),
            ),
          ),
        ],
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
                  '${_selectedDay == null ? 'HÔM NAY' : 'NGÀY ĐÃ CHỌN'} · ${today.day}/${today.month}/${today.year}',
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
                  _selectedDay == null
                      ? 'Thói quen hôm nay'
                      : 'Thói quen ngày đã chọn',
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
                  'Đã hoàn thành ${habits.where((habit) => _store.isCompleted(habit.id, today)).length}/${habits.length} ${_selectedDay == null ? 'hôm nay' : 'ngày đã chọn'}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _chooseDate,
                  icon: const Icon(Icons.calendar_month),
                  label: Text(
                    'Chọn ngày · ${today.day}/${today.month}/${today.year}',
                  ),
                ),
                if (_selectedDay != null)
                  TextButton(
                    onPressed: () => setState(() => _selectedDay = null),
                    child: const Text('Về hôm nay'),
                  ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: _store.progress(today)),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('search'),
                  controller: _search,
                  decoration: const InputDecoration(
                    labelText: 'Tìm theo tên hoặc ghi chú',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<HabitCategory>(
                  key: ValueKey(_category),
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Lọc theo nhóm',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Tất cả')),
                    DropdownMenuItem(
                      value: HabitCategory.health,
                      child: Text('Sức khỏe'),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.learning,
                      child: Text('Học tập'),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.mindfulness,
                      child: Text('Tinh thần'),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.personal,
                      child: Text('Cá nhân'),
                    ),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: 16),
                if (visibleHabits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Không có thói quen phù hợp.'),
                  ),
                for (final habit in visibleHabits)
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
