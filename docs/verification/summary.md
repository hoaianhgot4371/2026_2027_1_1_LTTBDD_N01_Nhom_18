# Kết quả kiểm chứng

Thời điểm: 10/11/2026 (Asia/Bangkok). Bản mã ứng dụng đối chiếu: `48feab4` trên `main`; các đợt trước: `7d7c6f7` (store), `2b30f66` (chi tiết/sửa/xóa), `c175406` (ngày/tìm/lọc/thống kê), `a69d41b` (song ngữ/nhóm).

## Đã kiểm thử tự động và build

- Lần kiểm tra `05-runtime-evidence.txt`: flutter analyze không có vấn đề, flutter test **16 kiểm thử đạt**, flutter build apk --release thành công **49.8 MB**, git diff --check mã thoát 0.
- Các đợt 01/02/03/04 lần lượt 11/12/13/16 test đạt; mỗi đợt có log analyze/test/build/diff check trước commit tương ứng.
- Có cảnh báo Java native access trong build, nhưng mã thoát build là 0. Một số dòng NativeCommandError trong log là PowerShell biểu diễn stderr cảnh báo; kiểm tra mã thoát ngay sau từng lệnh để phân biệt.
- APK tại `build/app/outputs/flutter-apk/app-release.apk`. Không đưa APK vào Git hoặc thư mục Code trong ZIP.
- Flutter 3.47.9, Dart 3.13.7; Windows 10; Chrome 156; phụ thuộc khóa bằng pubspec.lock. Tên và ngày trên màn hình là dữ liệu của phiên kiểm tra, không phải lịch sử sử dụng của sinh viên.

## Đã chạy thực tế

- `flutter build web --release --no-web-resources-cdn` thành công; chạy web build qua HTTP tại loopback và Chrome headless với profile tạm riêng.
- `tools/web_smoke.py` chạy thao tác thật qua Chrome DevTools, có assert: tên trống hiện lỗi, thêm làm tổng 4→5, tick làm số hoàn thành 1/5, thống kê 1/5=20%, hủy hộp thoại xóa; chuyển sang Anh.
- Đã chụp và xem ảnh PNG từ ứng dụng đang render: trang chủ, biểu mẫu, lỗi, hoàn thành, chi tiết, xác nhận xóa, thống kê, thông tin nhóm, giao diện Anh và biểu mẫu ở viewport 390×844.
- Nguồn ảnh: `docs/screenshots/01...10`; metadata thao tác thật ở `web-smoke.json`. Ảnh Chrome viewport hẹp là mô phỏng kích thước trình duyệt, **không phải điện thoại Android**.

## Chưa kiểm chứng / chưa hoàn thành bởi sinh viên

- Không có điện thoại/emulator Android kết nối trong lần kiểm tra; chưa cài/chạy APK trên Android, chưa đo hiệu năng hoặc test thiết bị dài ngày.
- Chưa gửi lời mời giảng viên, chưa kiểm tra quyền tài khoản giảng viên trên repository.
- Chưa có mẫu Bìa BTL.docx, sơ đồ do sinh viên tự vẽ và minh chứng quá trình, hoặc video tự quay/giọng thật. Các phần này cần sinh viên bổ sung trước nộp.
- DOCX/PDF được tạo từ cùng nội dung văn bản; PDF slide và PPTX có cùng 9 slide. Không có Microsoft Office trong môi trường; có thể kiểm tra cấu trúc và render PDF, chưa trực tiếp mở DOCX/PPTX bằng Word/PowerPoint.

## Tái lập

Đã kiểm tra thêm bản Code sạch từ ZIP thử. Chạy trực tiếp trong thư mục có dấu `Nhóm_18/Code` làm analysis server thoát 255 với `FormatException`. Cùng các file nguồn trích từ ZIP trong đường dẫn ASCII `build/submission-code-check` đã qua analyze, 16 test và build APK release 49.8 MB; kết quả được lưu trong `package-source-check.txt`. Khi giải nén trên Windows, chép Code sang đường dẫn không dấu trước khi chạy. Không sửa mã ứng dụng để che lỗi SDK này.

Chạy `flutter analyze`, `flutter test`, `flutter build apk --release`, `git diff --check`. Script `tools/verify.ps1` có SDK của máy phát triển và lưu log. Để tái lập web: build web như trên, phục vụ build/web ở localhost:8765; mở Chrome với profile tạm, headless và DevTools 9223; cài websocket-client rồi chạy tools/web_smoke.py. Không dùng profile Chrome cá nhân. Kịch bản dùng tọa độ cho vài thao tác nên cần kiểm tra lại nếu bố cục thay đổi.
