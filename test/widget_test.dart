import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nhip_song/main.dart';

void main() {
  testWidgets('Trang chủ hiển thị dữ liệu mẫu và cảnh báo RAM', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Nhịp Sống'), findsOneWidget);
    expect(find.text('Thói quen hôm nay'), findsOneWidget);
    expect(find.text('4 thói quen mẫu dành cho bạn'), findsOneWidget);
    expect(find.textContaining('sẽ mất khi đóng ứng dụng'), findsOneWidget);
    for (final name in [
      'Uống đủ nước',
      'Đọc sách 15 phút',
      'Hít thở thư giãn',
      'Viết nhật ký',
    ]) {
      await tester.scrollUntilVisible(find.text(name), 150);
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
    await tester.scrollUntilVisible(find.text('Viết nhật ký'), 200);
    expect(find.text('Viết nhật ký'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
