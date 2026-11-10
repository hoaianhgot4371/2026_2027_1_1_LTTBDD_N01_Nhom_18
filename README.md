# Nhịp Sống — Nhóm 18

Ứng dụng Flutter theo dõi thói quen hằng ngày. Dữ liệu lưu trong RAM và mất khi đóng hoặc tải lại ứng dụng.

## Thông tin nhóm

- Hồ Văn Hoài Anh — MSV **24106659**.
- Nhóm 18 — lớp **CSE702027-1-1-26(N01)**.
- Giảng viên: **ThS. Nguyễn Xuân Quế**.
- Thực hiện cá nhân, đã được giảng viên cho phép.
- Repository: https://github.com/hoaianhgot4371/2026_2027_1_1_LTTBDD_N01_Nhom_18

## Chức năng

- Thêm, xem chi tiết, sửa và xóa thói quen có xác nhận.
- Tên bắt buộc, tối đa 60 ký tự; ghi chú tùy chọn, tối đa 240 ký tự.
- Bốn nhóm: sức khỏe, học tập, tinh thần, cá nhân.
- Đánh dấu/hủy hoàn thành theo ngày; chặn ngày tương lai và ngày trước khi tạo.
- Tìm theo tên/ghi chú và lọc theo nhóm.
- Tiến độ ngày, thống kê 7 ngày và chuỗi hoàn thành.
- Giao diện tiếng Việt/Anh, giữ nguyên nội dung người dùng nhập.
- Trang thông tin nhóm và liên kết GitHub.

## Chạy ứng dụng

Môi trường đã sử dụng: Flutter 3.47.9, Dart 3.13.7. Cần cài Flutter và Android SDK để build APK. Trên Windows, đặt mã nguồn trong đường dẫn không dấu để tránh lỗi Dart analysis server đã gặp với SDK hiện tại.

```powershell
flutter pub get
flutter run -d chrome
```

Chạy trên Android: kết nối thiết bị hoặc mở emulator, kiểm tra `flutter devices`, sau đó chạy `flutter run -d <device-id>`.

## Kiểm thử và build

```powershell
flutter analyze
flutter test
flutter build apk --release
git diff --check
```

APK được tạo tại `build/app/outputs/flutter-apk/app-release.apk`.

## Cấu trúc mã nguồn

- `lib/main.dart`: cấu hình ứng dụng, theme và ngôn ngữ.
- `lib/language.dart`: chuỗi giao diện Việt/Anh.
- `lib/models/habit.dart`: mô hình thói quen và điều kiện ngày khả dụng.
- `lib/data/habit_store.dart`: dữ liệu RAM, CRUD, hoàn thành và công thức thống kê.
- `lib/screens/`: trang chủ, biểu mẫu, chi tiết, thống kê và thông tin nhóm.
- `test/`: kiểm thử nghiệp vụ và giao diện.
- `docs/verification/`: kết quả kiểm tra thực tế.
- `docs/screenshots/`: ảnh ứng dụng web chạy trên Chrome.

## Công thức thống kê

- Tiến độ ngày = số thói quen hoàn thành / số thói quen có ngày tạo không sau ngày đó; bằng 0 nếu không có thói quen.
- Tỷ lệ 7 ngày = tổng lượt hoàn thành / tổng lượt khả dụng từ hôm nay trừ 6 đến hôm nay.
- Chuỗi đếm các ngày hoàn thành liên tiếp từ hôm nay; nếu hôm nay chưa hoàn thành thì bắt đầu từ hôm qua.
- Sửa giữ ngày tạo và dấu hoàn thành. Xóa loại cả lịch sử của thói quen khỏi thống kê.
- Tìm kiếm/lọc chỉ đổi danh sách hiển thị, không đổi tổng tiến độ ngày.

## Giới hạn

- Không lưu bền, không tài khoản, đồng bộ hoặc nhắc giờ.
- Ngày dựa trên đồng hồ và múi giờ thiết bị; trang chủ làm mới ngày mỗi phút.
- Tìm kiếm không phân biệt hoa/thường nhưng còn phân biệt dấu tiếng Việt.
- APK bài tập hiện dùng cấu hình ký debug của dự án mẫu.
- Đã kiểm thử tự động, build APK và chạy web trên Chrome; chưa kiểm tra chạy trên điện thoại/emulator Android.
