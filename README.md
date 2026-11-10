# Nhịp Sống — Nhóm 18

Ứng dụng Flutter theo dõi thói quen. Dữ liệu lưu trong RAM: mất khi đóng hoặc tải lại; không có tài khoản, máy chủ hoặc đồng bộ.

## Thông tin

- Hồ Văn Hoài Anh — MSV **24106659**.
- Nhóm 18 — lớp **CSE702027-1-1-26(N01)**.
- Giảng viên: **ThS. Nguyễn Xuân Quế**.
- Thực hiện cá nhân, đã được giảng viên cho phép (thông tin sinh viên cung cấp).
- GitHub: https://github.com/hoaianhgot4371/2026_2027_1_1_LTTBDD_N01_Nhom_18

## Chức năng

- Thêm, xem chi tiết, sửa; xóa có xác nhận và dọn các dấu hoàn thành tương ứng.
- Tên bắt buộc, cắt khoảng trắng đầu/cuối, tối đa 60 ký tự; ghi chú tùy chọn tối đa 240 ký tự.
- Bốn nhóm: sức khỏe, học tập, tinh thần, cá nhân.
- Đánh dấu/hủy theo ngày lịch địa phương; chặn ngày tương lai, trước ngày tạo và ID không tồn tại.
- Tìm theo tên/ghi chú, không phân biệt hoa/thường; kết hợp lọc nhóm. Tìm kiếm còn phân biệt dấu tiếng Việt.
- Tiến độ ngày, thống kê 7 ngày gồm hôm nay, chuỗi hoàn thành theo thói quen.
- Tiếng Việt/Anh cho giao diện, biểu mẫu, lỗi, hộp thoại, bộ chọn ngày. Nội dung dữ liệu không tự dịch, kể cả thói quen mẫu.
- Trang thông tin nhóm, link GitHub có thể mở hoặc sao chép.

## Chạy và kiểm tra

Trên Windows, sau khi giải nén `Nhóm_18.zip`, hãy chép thư mục `Nhóm_18/Code` sang đường dẫn không dấu, ví dụ `C:\DuAn\nhip_song`, rồi mở terminal tại đó. Lần thử với SDK hiện tại dưới đường dẫn `Nhóm_18/Code` làm Dart analysis server lỗi `FormatException`; cùng nguồn trong đường dẫn ASCII đã qua analyze, 16 test và build APK release. Chi tiết và kết quả build nguồn sạch được ghi tại `docs/verification/package-source-check.txt`.

Môi trường đã dùng: Flutter 3.47.9, Dart 3.13.7 trên Windows; Android SDK/NDK theo cấu hình Flutter. Cần Flutter trong PATH, hoặc dùng `C:\Users\hoaia\develop\flutter\bin\flutter.bat` trên máy hiện tại.

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d chrome
flutter build apk --release
```

Để lưu log bốn kiểm tra trước commit trên máy hiện tại:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File tools/verify.ps1 -Batch ten-dot
```

Script dùng đường dẫn SDK của máy phát triển; máy khác sửa biến `$flutter` trong script hoặc chạy từng lệnh. APK sinh tại `build/app/outputs/flutter-apk/app-release.apk`. Không commit APK, build, cache, `android/local.properties` hoặc khóa ký.

## Quy tắc thống kê

Với ngày d, A(d) là các thói quen có ngày tạo ≤ d, C(d) là số đã hoàn thành trong A(d).

- Tiến độ = C(d)/|A(d)|, bằng 0 nếu không có thói quen.
- 7 ngày: từ hôm nay trừ 6 đến hôm nay; tỷ lệ = tổng C(d)/tổng |A(d)|; không lấy trung bình phần trăm.
- Chuỗi của từng thói quen: đếm liên tiếp từ hôm nay; nếu hôm nay chưa xong thì bắt đầu từ hôm qua. Gặp một ngày chưa xong thì dừng. Không đếm ngày trước ngày tạo.
- Sửa giữ nguyên ID, ngày tạo và dấu hoàn thành; xóa loại lịch sử của thói quen khỏi thống kê. Số tổng/tiến độ ngày không đổi theo bộ lọc tìm kiếm.

## Cấu trúc mã nguồn

- `lib/main.dart`: theme, locale, Material localization, trạng thái ngôn ngữ.
- `lib/language.dart`: tra hai bản chuỗi giao diện qua `LanguageScope`.
- `lib/models/habit.dart`: dữ liệu và điều kiện ngày khả dụng.
- `lib/data/habit_store.dart`: nguồn dữ liệu RAM, CRUD, đánh dấu theo ngày, tiến độ, chuỗi.
- `lib/screens/`: trang chủ, biểu mẫu, chi tiết, thống kê, thông tin nhóm.
- `test/`: kiểm thử nghiệp vụ và widget.
- `docs/verification/`: log thật; `docs/screenshots/`: ảnh chụp ứng dụng thật khi đã chạy được.
- `docs/report/`, `docs/slides/`, `docs/demo/`: hồ sơ bàn giao; `docs/code-guide.md`: giải thích code.
- `tools/`: kiểm tra, tạo tài liệu, đóng gói; không dùng để sinh sơ đồ.

## Giới hạn và phần sinh viên cần làm

- Mọi dữ liệu, ngôn ngữ và dấu hoàn thành mất khi đóng/tải lại; bốn mẫu được tạo lại với ngày mở ứng dụng. Không có thông báo nhắc giờ hay lưu bền.
- Ngày dựa vào đồng hồ và múi giờ của thiết bị; không chống việc đổi đồng hồ hệ thống. Trang chủ làm mới ngày mỗi phút.
- Bản release hiện dùng cấu hình ký debug của dự án mẫu để phục vụ bài tập, chưa phải bản phát hành cửa hàng.
- Chỉ ghi nhận chạy Android khi thực sự chạy trên điện thoại/emulator; APK build thành công không phải minh chứng chạy điện thoại.
- Sinh viên phải tự vẽ sơ đồ bằng phần mềm, lưu file gốc và ảnh quá trình; tài liệu chỉ có hướng dẫn chữ/vị trí chèn. Không có sơ đồ do AI hoặc code sinh.
- Chưa có mẫu `Bìa BTL.docx`: nội dung báo cáo đã chuẩn bị, cần bổ sung bìa đúng mẫu khi có.
- Sinh viên tự quay, tự thuyết minh video ≤5 phút, ≤100 MB, không dùng giọng AI; tự gửi lời mời giảng viên nếu chưa gửi và rà soát bản nộp.

Xem `docs/submission-checklist.md` và `docs/verification/summary.md` để phân biệt phần đã kiểm chứng và phần còn lại.
