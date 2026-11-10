import 'package:flutter/material.dart';

import '../data/habit_store.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key, required this.store});
  final HabitStore store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) {
      final days = List.generate(
        7,
        (i) => DateTime(
          store.today.year,
          store.today.month,
          store.today.day - 6 + i,
        ),
      );
      final total = days.fold<int>(
        0,
        (sum, day) => sum + store.availableOn(day).length,
      );
      final done = days.fold<int>(
        0,
        (sum, day) => sum + store.completedCount(day),
      );
      return Scaffold(
        appBar: AppBar(title: const Text('Thống kê 7 ngày')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              '7 ngày gần nhất, gồm hôm nay',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Tổng: $done/$total lượt · ${total == 0 ? 0 : (100 * done / total).round()}%',
            ),
            const SizedBox(height: 16),
            for (final day in days)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.day}/${day.month}: ${store.completedCount(day)}/${store.availableOn(day).length}',
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: store.progress(day)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Chuỗi ngày theo thói quen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final habit in store.habits)
              ListTile(
                title: Text(habit.name),
                trailing: Text('${store.streak(habit.id)} ngày'),
              ),
            const Divider(),
            const Text(
              'Cách tính: tiến độ ngày = số thói quen hoàn thành / số thói quen đã được tạo tính đến ngày đó. Không có thói quen thì tiến độ là 0%. Tỷ lệ 7 ngày = tổng lượt hoàn thành / tổng lượt có thể hoàn thành trong 7 ngày gần nhất, không lấy trung bình các phần trăm. Chuỗi là số ngày hoàn thành liên tiếp kết thúc hôm nay; nếu hôm nay chưa hoàn thành thì tính lùi từ hôm qua. Ngày trống làm đứt chuỗi. Sửa không đổi lịch sử; xóa thói quen loại cả lịch sử của nó khỏi thống kê.',
            ),
          ],
        ),
      );
    },
  );
}
