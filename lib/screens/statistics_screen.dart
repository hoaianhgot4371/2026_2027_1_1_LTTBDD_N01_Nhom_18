import '../language.dart';

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
        appBar: AppBar(
          title: Text(context.tr('Thống kê 7 ngày', '7-day statistics')),
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Text(
              context.tr(
                '7 ngày gần nhất, gồm hôm nay',
                'Last 7 days, including today',
              ),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12),
            Text(
              context.tr(
                'Tổng: $done/$total lượt · ${total == 0 ? 0 : (100 * done / total).round()}%',
                'Total: $done/$total habit-days · ${total == 0 ? 0 : (100 * done / total).round()}%',
              ),
            ),
            SizedBox(height: 16),
            for (final day in days)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${day.day}/${day.month}: ${store.completedCount(day)}/${store.availableOn(day).length}',
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(value: store.progress(day)),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 16),
            Text(
              context.tr('Chuỗi ngày theo thói quen', 'Streaks by habit'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            for (final habit in store.habits)
              ListTile(
                title: Text(habit.name),
                trailing: Text(
                  context.tr(
                    '${store.streak(habit.id)} ngày',
                    '${store.streak(habit.id)} days',
                  ),
                ),
              ),
            Divider(),
            Text(
              context.tr(
                'Cách tính: tiến độ ngày = số thói quen hoàn thành / số thói quen đã được tạo tính đến ngày đó. Không có thói quen thì tiến độ là 0%. Tỷ lệ 7 ngày = tổng lượt hoàn thành / tổng lượt có thể hoàn thành trong 7 ngày gần nhất, không lấy trung bình các phần trăm. Chuỗi là số ngày hoàn thành liên tiếp kết thúc hôm nay; nếu hôm nay chưa hoàn thành thì tính lùi từ hôm qua. Ngày trống làm đứt chuỗi. Sửa không đổi lịch sử; xóa thói quen loại cả lịch sử của nó khỏi thống kê.',
                'Daily progress = completed habits / habits created on or before that date; 0% if none exist. The 7-day rate = total completions / total eligible habit-days over the last 7 days, rather than an average of percentages. A streak counts consecutive completed days ending today, or yesterday if today is incomplete. A gap breaks the streak. Editing preserves history; deleting a habit also removes its history from statistics.',
              ),
            ),
          ],
        ),
      );
    },
  );
}
