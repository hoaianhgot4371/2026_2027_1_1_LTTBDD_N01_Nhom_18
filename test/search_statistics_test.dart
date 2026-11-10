import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/main.dart';
import 'package:nhip_song/models/habit.dart';

void main() {
  testWidgets(
    'Search and category intersect; empty result and seven-day statistics',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      final field = find.byKey(const ValueKey('search'));
      await tester.scrollUntilVisible(field, 150);
      await tester.ensureVisible(field);
      await tester.enterText(field, '  ĐỌC SÁCH  ');
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byType(DropdownButtonFormField<HabitCategory>),
      );
      await tester.tap(find.byType(DropdownButtonFormField<HabitCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sức khỏe').last);
      await tester.pumpAndSettle();
      expect(find.text('Không có thói quen phù hợp.'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<HabitCategory>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Học tập').last);
      await tester.pumpAndSettle();
      expect(find.text('Đọc sách 15 phút'), findsOneWidget);
      expect(find.text('Uống đủ nước'), findsNothing);
      await tester.tap(find.byTooltip('Thống kê 7 ngày'));
      await tester.pumpAndSettle();
      expect(find.text('Tổng: 0/4 lượt · 0%'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNWidgets(7));
      expect(tester.takeException(), isNull);
    },
  );
}
