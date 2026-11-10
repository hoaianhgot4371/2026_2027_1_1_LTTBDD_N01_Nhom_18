import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../language.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static final repository = Uri.parse(
    'https://github.com/hoaianhgot4371/2026_2027_1_1_LTTBDD_N01_Nhom_18',
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.tr('Thông tin nhóm', 'About the team'))),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(Icons.spa_outlined, size: 64),
              const SizedBox(height: 16),
              Text(
                'Nhịp Sống',
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                context.tr(
                  'Ứng dụng theo dõi thói quen hằng ngày',
                  'Daily habit tracker',
                ),
              ),
              const SizedBox(height: 24),
              const SelectableText('Hồ Văn Hoài Anh — MSV 24106659'),
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'Nhóm 18 — Lớp CSE702027-1-1-26(N01)',
                  'Group 18 — Class CSE702027-1-1-26(N01)',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'Giảng viên: ThS. Nguyễn Xuân Quế',
                  'Lecturer: MSc. Nguyễn Xuân Quế',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr(
                  'Thực hiện cá nhân, đã được giảng viên cho phép.',
                  'Individual project with lecturer approval.',
                ),
              ),
              const SizedBox(height: 24),
              SelectableText(repository.toString()),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.open_in_new),
                label: Text(context.tr('Mở GitHub', 'Open GitHub')),
                onPressed: () async {
                  var opened = false;
                  try {
                    opened = await launchUrl(
                      repository,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (_) {
                    opened = false;
                  }
                  if (!opened && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          context.tr(
                            'Không thể mở liên kết. Bạn có thể sao chép địa chỉ phía trên.',
                            'Cannot open the link. You can copy the address above.',
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(
                context.tr(
                  'Dữ liệu chỉ lưu trong RAM, mất khi đóng hoặc tải lại ứng dụng. Không có đồng bộ hoặc tài khoản.',
                  'Data is stored in RAM and lost on close or reload. No sync or accounts.',
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
