import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/models/habit.dart';

void main() {
  test('Thoi quen chi xuat hien tu ngay tao, khong phu thuoc gio', () {
    final habit = Habit(
      id: 'habit-1',
      name: 'Đọc sách',
      category: HabitCategory.learning,
      createdAt: DateTime(2026, 11, 1, 15, 30),
    );

    expect(
      habit.isAvailableOn(DateTime(2026, 10, 31, 23)),
      isFalse,
    );
    expect(
      habit.isAvailableOn(DateTime(2026, 11, 1)),
      isTrue,
    );
    expect(
      habit.isAvailableOn(DateTime(2026, 11, 2)),
      isTrue,
    );
  });
}