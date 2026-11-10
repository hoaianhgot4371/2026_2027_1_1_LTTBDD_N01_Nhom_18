import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/main.dart';
import 'package:nhip_song/models/habit.dart';
import 'package:nhip_song/data/habit_store.dart';
import 'package:nhip_song/screens/home_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> reveal(
  WidgetTester tester,
  Finder finder, [
  double delta = 150,
]) async {
  for (var i = 0; i < 40 && finder.hitTestable().evaluate().isEmpty; i++) {
    final rect = tester.getRect(find.byType(ListView).first);
    await tester.dragFrom(
      Offset(rect.left + 8, rect.top + 100),
      Offset(0, -delta),
    );
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'English labels, errors, delete dialog; user content is not translated',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.tap(find.byTooltip('Đổi ngôn ngữ'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Add habit'));
      await tester.tap(find.text('Add habit'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save habit'));
      await tester.pumpAndSettle();
      expect(find.text('Please enter a habit name'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('habit-name')),
        'Thói quen của tôi',
      );
      await tester.tap(find.text('Save habit'));
      await tester.pumpAndSettle();
      await reveal(tester, find.text('Thói quen của tôi'));
      final card = find.ancestor(
        of: find.text('Thói quen của tôi'),
        matching: find.byType(Card),
      );
      final detail = find.descendant(
        of: card,
        matching: find.text('View details'),
      );
      await reveal(tester, detail);
      await tester.tap(detail);
      await tester.pumpAndSettle();
      expect(find.text('Habit details'), findsOneWidget);
      expect(find.text('Thói quen của tôi'), findsOneWidget);
      await tester.tap(find.text('Delete habit'));
      await tester.pumpAndSettle();
      expect(find.text('Delete habit?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('About the team'));
      await tester.pumpAndSettle();
      expect(find.text('Hồ Văn Hoài Anh — MSV 24106659'), findsOneWidget);
      expect(find.textContaining('Nguyễn Xuân Quế'), findsOneWidget);
    },
  );

  testWidgets(
    'Past date is independent and future date is disabled in picker',
    (tester) async {
      final store = HabitStore(
        clock: () => DateTime(2026, 11, 10),
        initialHabits: [
          Habit(
            id: 'a',
            name: 'Past habit',
            category: HabitCategory.health,
            createdAt: DateTime(2026, 11, 8),
          ),
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('vi'),
          supportedLocales: const [Locale('vi')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: HomeScreen(store: store),
        ),
      );
      final choose = find.text('Chọn ngày · 10/11/2026');
      await reveal(tester, choose);
      await tester.tap(choose);
      await tester.pumpAndSettle();
      final picker = tester.widget<DatePickerDialog>(
        find.byType(DatePickerDialog),
      );
      expect(picker.lastDate, DateTime(2026, 11, 10));
      expect(picker.firstDate, DateTime(2026, 11, 8));
      await tester.tap(find.text('9'));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      final check = find.byKey(const ValueKey('complete-a'));
      await reveal(tester, check);
      await tester.tap(check);
      await tester.pump();
      expect(store.isCompleted('a', DateTime(2026, 11, 9)), isTrue);
      expect(store.isCompleted('a', store.today), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Name/note length enforcement and keyboard on narrow form', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    await reveal(tester, find.text('Thêm thói quen'));
    await tester.tap(find.text('Thêm thói quen'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('habit-name')), 'a' * 61);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('habit-name')))
          .controller!
          .text
          .length,
      60,
    );
    await tester.enterText(find.byKey(const ValueKey('habit-note')), 'b' * 241);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const ValueKey('habit-note')))
          .controller!
          .text
          .length,
      240,
    );
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pump();
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await reveal(tester, find.text('Lưu thói quen'));
    await tester.tap(find.text('Lưu thói quen'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
