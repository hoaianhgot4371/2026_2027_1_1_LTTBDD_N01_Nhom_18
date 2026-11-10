import 'package:flutter/material.dart';

import '../models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key, required this.id});
  final String id;

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _note = TextEditingController();
  HabitCategory _category = HabitCategory.health;

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
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Thêm thói quen')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                TextFormField(
                  key: const ValueKey('habit-name'),
                  controller: _name,
                  decoration: const InputDecoration(
                    labelText: 'Tên thói quen',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 60,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    final name = (value ?? '').trim();
                    if (name.isEmpty) return 'Vui lòng nhập tên thói quen';
                    if (name.characters.length > 60) {
                      return 'Tên tối đa 60 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const ValueKey('habit-note'),
                  controller: _note,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú (tùy chọn)',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 240,
                  minLines: 2,
                  maxLines: 4,
                  validator: (value) => (value ?? '').characters.length > 240
                      ? 'Ghi chú tối đa 240 ký tự'
                      : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<HabitCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Nhóm thói quen',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
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
                  onChanged: (value) => setState(() => _category = value!),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Lưu thói quen'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
