import '../language.dart';

import 'dart:async';

import 'about_screen.dart';

import 'package:flutter/material.dart';

import '../models/habit.dart';
import 'add_habit_screen.dart';
import '../data/habit_store.dart';
import 'habit_detail_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.store});
  final HabitStore? store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HabitStore _store =
      widget.store ?? HabitStore(initialHabits: _createSamples());
  Timer? _dayRefresh;
  @override
  void initState() {
    super.initState();
    _dayRefresh = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  final _search = TextEditingController();

  @override
  void dispose() {
    _dayRefresh?.cancel();
    if (widget.store == null) _store.dispose();
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
      initialDate:
          (_selectedDay != null &&
              !_selectedDay!.isBefore(first) &&
              !_selectedDay!.isAfter(_store.today))
          ? _selectedDay
          : _store.today,
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
    final today = _selectedDay ?? _store.today;

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
        title: Text('Nhịp Sống'),
        leading: Icon(Icons.spa_outlined),
        actions: [
          IconButton(
            tooltip: context.tr('Đổi ngôn ngữ', 'Change language'),
            icon: const Icon(Icons.language),
            onPressed: LanguageScope.maybeOf(context)?.toggle,
          ),
          IconButton(
            tooltip: context.tr('Thông tin nhóm', 'About the team'),
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
            ),
          ),
          IconButton(
            tooltip: context.tr('Thống kê 7 ngày', '7-day statistics'),
            icon: Icon(Icons.bar_chart),
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
            constraints: BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Text(
                  '${_selectedDay == null ? context.tr('HÔM NAY', 'TODAY') : context.tr('NGÀY ĐÃ CHỌN', 'SELECTED DATE')} · ${today.day}/${today.month}/${today.year}',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  context.tr(
                    'Một chút mỗi ngày,\nmột nhịp sống tốt hơn.',
                    'A little every day,\na better rhythm of life.',
                  ),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  context.tr(
                    'Bắt đầu từ những việc nhỏ và dành thời gian cho bạn.',
                    'Start small and make time for yourself.',
                  ),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.tr(
                            'Danh sách ban đầu gồm 4 thói quen mẫu. Dữ liệu chỉ lưu trong RAM và sẽ mất khi đóng ứng dụng hoặc tải lại.',
                            'The initial list contains 4 sample habits. Data is stored in RAM and is lost when the app is closed or reloaded.',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                Text(
                  _selectedDay == null
                      ? context.tr('Thói quen hôm nay', 'Today’s habits')
                      : context.tr(
                          'Thói quen ngày đã chọn',
                          'Habits on selected date',
                        ),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  context.tr(
                    '${habits.length} thói quen dành cho bạn',
                    '${habits.length} habits for you',
                  ),
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    onPressed: _addHabit,
                    icon: Icon(Icons.add),
                    label: Text(context.tr('Thêm thói quen', 'Add habit')),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  context.tr(
                    'Đã hoàn thành ${_store.completedCount(today)}/${habits.length} ${_selectedDay == null ? 'hôm nay' : 'ngày đã chọn'}',
                    'Completed ${_store.completedCount(today)}/${habits.length} ${_selectedDay == null ? 'today' : 'on selected date'}',
                  ),
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: _chooseDate,
                  icon: Icon(Icons.calendar_month),
                  label: Text(
                    context.tr(
                      'Chọn ngày · ${today.day}/${today.month}/${today.year}',
                      'Choose date · ${today.day}/${today.month}/${today.year}',
                    ),
                  ),
                ),
                if (_selectedDay != null)
                  TextButton(
                    onPressed: () => setState(() => _selectedDay = null),
                    child: Text(context.tr('Về hôm nay', 'Back to today')),
                  ),
                SizedBox(height: 12),
                LinearProgressIndicator(value: _store.progress(today)),
                SizedBox(height: 16),
                TextFormField(
                  key: ValueKey('search'),
                  controller: _search,
                  decoration: InputDecoration(
                    labelText: context.tr(
                      'Tìm theo tên hoặc ghi chú',
                      'Search name or note',
                    ),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<HabitCategory>(
                  key: ValueKey(_category),
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: context.tr(
                      'Lọc theo nhóm',
                      'Filter by category',
                    ),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(context.tr('Tất cả', 'All')),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.health,
                      child: Text(context.tr('Sức khỏe', 'Health')),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.learning,
                      child: Text(context.tr('Học tập', 'Learning')),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.mindfulness,
                      child: Text(context.tr('Tinh thần', 'Mindfulness')),
                    ),
                    DropdownMenuItem(
                      value: HabitCategory.personal,
                      child: Text(context.tr('Cá nhân', 'Personal')),
                    ),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                ),
                SizedBox(height: 16),
                if (visibleHabits.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      context.tr(
                        'Không có thói quen phù hợp.',
                        'No matching habits.',
                      ),
                    ),
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
                SizedBox(height: 8),
                Text(
                  context.tr(
                    'Mỗi bước nhỏ đều có ý nghĩa.',
                    'Every small step matters.',
                  ),
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
        context.tr('Sức khỏe', 'Health'),
        Icons.water_drop_outlined,
        Colors.blue,
      ),
      HabitCategory.learning => (
        context.tr('Học tập', 'Learning'),
        Icons.menu_book_outlined,
        Colors.orange,
      ),
      HabitCategory.mindfulness => (
        context.tr('Tinh thần', 'Mindfulness'),
        Icons.self_improvement,
        Colors.teal,
      ),
      HabitCategory.personal => (
        context.tr('Cá nhân', 'Personal'),
        Icons.edit_note,
        Colors.purple,
      ),
    };
    final theme = Theme.of(context);
    return Card(
      key: ValueKey(habit.id),
      margin: EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: theme.textTheme.labelMedium),
                  SizedBox(height: 4),
                  Text(
                    habit.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(habit.note),
                  TextButton(
                    onPressed: onOpen,
                    child: Text(context.tr('Xem chi tiết', 'View details')),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        key: ValueKey('complete-${habit.id}'),
                        value: isCompleted,
                        semanticLabel: context.tr(
                          'Hoàn thành ${habit.name} ngày đã chọn',
                          'Complete ${habit.name} on selected date',
                        ),
                        onChanged: (value) => onChanged(value ?? false),
                      ),
                      Flexible(
                        child: Text(
                          isCompleted
                              ? context.tr('Đã hoàn thành', 'Completed')
                              : context.tr('Chưa hoàn thành', 'Not completed'),
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
