import '../language.dart';

import 'package:flutter/material.dart';

import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key, required this.id, this.habit});
  final String id;
  final Habit? habit;

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _note = TextEditingController();
  HabitCategory _category = HabitCategory.health;

  @override
  void initState() {
    super.initState();
    _name.text = widget.habit?.name ?? '';
    _note.text = widget.habit?.note ?? '';
    _category = widget.habit?.category ?? HabitCategory.health;
  }

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Habit(
        id: widget.id,
        name: _name.text.trim(),
        note: _note.text.trim(),
        category: _category,
        createdAt: widget.habit?.createdAt ?? DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        widget.habit == null
            ? context.tr('Thêm thói quen', 'Add habit')
            : context.tr('Sửa thói quen', 'Edit habit'),
      ),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.all(20),
              children: [
                TextFormField(
                  key: ValueKey('habit-name'),
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: context.tr('Tên thói quen', 'Habit name'),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 60,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    final name = (value ?? '').trim();
                    if (name.isEmpty) {
                      return context.tr(
                        'Vui lòng nhập tên thói quen',
                        'Please enter a habit name',
                      );
                    }
                    if (name.characters.length > 60) {
                      return context.tr(
                        'Tên tối đa 60 ký tự',
                        'Name must be at most 60 characters',
                      );
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  key: ValueKey('habit-note'),
                  controller: _note,
                  decoration: InputDecoration(
                    labelText: context.tr(
                      'Ghi chú (tùy chọn)',
                      'Note (optional)',
                    ),
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 240,
                  minLines: 2,
                  maxLines: 4,
                  validator: (value) => (value ?? '').characters.length > 240
                      ? context.tr(
                          'Ghi chú tối đa 240 ký tự',
                          'Note must be at most 240 characters',
                        )
                      : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<HabitCategory>(
                  initialValue: _category,
                  decoration: InputDecoration(
                    labelText: context.tr('Nhóm thói quen', 'Habit category'),
                    border: OutlineInputBorder(),
                  ),
                  items: [
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
                  onChanged: (value) => setState(() => _category = value!),
                ),
                SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: Text(context.tr('Lưu thói quen', 'Save habit')),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.tr('Hủy', 'Cancel')),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
