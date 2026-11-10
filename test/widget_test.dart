import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/main.dart';
import 'package:nhip_song/models/habit.dart';

Future<void> show(WidgetTester tester, Finder target, double delta) async {
  for (var i = 0; i < 40 && target.hitTestable().evaluate().isEmpty; i++) {
    await tester.drag(find.byType(Scrollable).first, Offset(0, -delta));
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
}

void main() {
  Future<void> openForm(WidgetTester tester) async {
    await show(tester, find.text('Thêm thói quen'), 150);
    await tester.tap(find.text('Thêm thói quen'));
    await tester.pumpAndSettle();
  }

  testWidgets('Tên trống hoặc chỉ có khoảng trắng không được lưu', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await openForm(tester);
    for (final name in ['', '   ']) {
      await tester.enterText(find.byKey(const ValueKey('habit-name')), name);
      await tester.tap(find.text('Lưu thói quen'));
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập tên thói quen'), findsOneWidget);
    }
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    await show(tester, find.text('4 thói quen dành cho bạn'), -150);
    expect(find.text('4 thói quen dành cho bạn'), findsOneWidget);
  });

  testWidgets('Thêm hợp lệ cắt khoảng trắng và giữ trạng thái hoàn thành cũ', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await show(tester, find.byKey(const ValueKey('complete-water')), 150);
    await tester.tap(find.byKey(const ValueKey('complete-water')));
    await tester.pump();
    await show(tester, find.text('Thêm thói quen'), -150);
    await openForm(tester);
    await tester.enterText(
      find.byKey(const ValueKey('habit-name')),
      '  Đi bộ  ',
    );
    await tester.enterText(
      find.byKey(const ValueKey('habit-note')),
      'Ngoài trời',
    );
    await tester.tap(find.byType(DropdownButtonFormField<HabitCategory>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cá nhân').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Lưu thói quen'));
    await tester.pumpAndSettle();
    await show(tester, find.text('5 thói quen dành cho bạn'), -150);
    expect(find.text('5 thói quen dành cho bạn'), findsOneWidget);
    expect(find.text('Đã hoàn thành 1/5 hôm nay'), findsOneWidget);
    await show(tester, find.text('Đi bộ'), 150);
    expect(find.text('Ngoài trời'), findsOneWidget);
    final card = find.ancestor(
      of: find.text('Đi bộ'),
      matching: find.byType(Card),
    );
    expect(
      find.descendant(of: card, matching: find.text('Cá nhân')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<Checkbox>(
            find.descendant(of: card, matching: find.byType(Checkbox)),
          )
          .value,
      isFalse,
    );
  });

  testWidgets('Hủy hoặc quay lại không thêm thói quen', (tester) async {
    await tester.pumpWidget(const MyApp());
    for (final cancel in [true, false]) {
      await openForm(tester);
      await tester.enterText(
        find.byKey(const ValueKey('habit-name')),
        'Không lưu',
      );
      if (cancel) {
        await tester.tap(find.text('Hủy'));
      } else {
        await tester.tap(find.byType(BackButton));
      }
      await tester.pumpAndSettle();
      await show(tester, find.text('4 thói quen dành cho bạn'), -150);
      expect(find.text('4 thói quen dành cho bạn'), findsOneWidget);
      expect(find.text('Không lưu'), findsNothing);
    }
  });

  testWidgets('Đánh dấu và hủy hoàn thành cập nhật số lượng độc lập', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Đã hoàn thành 0/4 hôm nay'), findsOneWidget);

    Future<void> toggle(String id) async {
      final checkbox = find.byKey(ValueKey('complete-$id'));
      await show(tester, checkbox, 100);
      await tester.tap(checkbox);
      await tester.pump();
    }

    for (final id in ['water', 'reading', 'breathe', 'journal']) {
      await toggle(id);
    }
    await show(tester, find.text('Đã hoàn thành 4/4 hôm nay'), -200);
    expect(find.text('Đã hoàn thành 4/4 hôm nay'), findsOneWidget);
    await toggle('water');
    expect(
      tester
          .widget<Checkbox>(find.byKey(const ValueKey('complete-water')))
          .value,
      isFalse,
    );
    await show(tester, find.text('Đã hoàn thành 3/4 hôm nay'), -200);
    expect(find.text('Đã hoàn thành 3/4 hôm nay'), findsOneWidget);
    await show(tester, find.byKey(const ValueKey('complete-reading')), 100);
    expect(
      tester
          .widget<Checkbox>(find.byKey(const ValueKey('complete-reading')))
          .value,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Trang chủ hiển thị dữ liệu mẫu và cảnh báo RAM', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Nhịp Sống'), findsOneWidget);
    expect(find.text('Thói quen hôm nay'), findsOneWidget);
    await show(tester, find.text('4 thói quen dành cho bạn'), -150);
    expect(find.text('4 thói quen dành cho bạn'), findsOneWidget);
    await show(tester, find.textContaining('sẽ mất khi đóng ứng dụng'), -150);
    expect(find.textContaining('sẽ mất khi đóng ứng dụng'), findsOneWidget);
    for (final name in [
      'Uống đủ nước',
      'Đọc sách 15 phút',
      'Hít thở thư giãn',
      'Viết nhật ký',
    ]) {
      await show(tester, find.text(name), 150);
      expect(find.text(name), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Trang chủ cuộn được trên màn hình hẹp với chữ lớn', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const MyApp());
    final context = tester.element(find.byType(Scaffold));
    expect(MediaQuery.textScalerOf(context).scale(16), 24);
    await show(tester, find.text('Viết nhật ký'), 200);
    expect(find.text('Viết nhật ký'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
