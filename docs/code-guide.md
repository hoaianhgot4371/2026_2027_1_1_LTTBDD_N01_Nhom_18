# Giải thích mã nguồn Nhịp Sống

## 1. Đọc theo thứ tự

Đọc Habit, HabitStore, main/LanguageScope, HomeScreen, AddHabitScreen, HabitDetailScreen, StatisticsScreen, AboutScreen; cuối cùng mở các test tương ứng. Một thay đổi giao diện không nhất thiết là một thay đổi dữ liệu.

## 2. Dữ liệu bất biến

Habit có ID, tên, ghi chú, nhóm, iconIndex và createdAt. Các thuộc tính final; sửa tạo đối tượng Habit mới. Constructor chuẩn hóa createdAt về 00:00 theo ngày lịch địa phương. isAvailableOn cũng bỏ phần giờ rồi so sánh ngày. iconIndex được giữ để mở rộng; biểu tượng hiện chọn theo nhóm.

## 3. Nguồn sự thật trong RAM

HabitStore kế thừa ChangeNotifier, giữ List<Habit> riêng và Map<DateTime, Set<String>> các ID hoàn thành. Getter habits trả danh sách không sửa được từ bên ngoài. Set tránh một thói quen bị đếm hai lần trong cùng ngày. nextId tạo ID tăng dần cho một phiên; không cần UUID khi chưa có máy chủ/lưu bền.

add từ chối ID trùng. update tìm ID và giữ ngày tạo cũ; delete xóa thói quen và ID trong mọi tập ngày. setCompleted chuẩn hóa ngày và kiểm tra ID, ngày tạo, tương lai trước khi thay đổi Set. notifyListeners yêu cầu các trang dùng ListenableBuilder dựng lại. Trang chủ gọi setState sau thao tác của mình và sau khi quay về từ trang chi tiết.

Clock được truyền tùy chọn cho store để test không phụ thuộc thời điểm chạy. Mặc định là DateTime.now. calendarDay dùng ngày/tháng/năm, không so sánh số giờ đã trôi qua. Khi lùi ngày, dùng constructor DateTime(year, month, day - 1) để giữ ngày lịch.

## 4. Điều hướng và biểu mẫu

Navigator.push<Habit> mở biểu mẫu. Lưu trả Habit qua Navigator.pop; Hủy/quay lại trả null. Trang chủ chỉ thêm khi kết quả khác null và còn mounted. GlobalKey<FormState> gọi validate. Controller giữ văn bản người dùng, dispose để giải phóng tài nguyên. maxLength giới hạn ký tự hiển thị; validator kiểm tra thêm. Tên và ghi chú được trim khi lưu.

Cùng biểu mẫu dùng cho thêm/sửa: nếu có habit thì nạp sẵn tên/ghi chú/nhóm, giữ ngày tạo. Xóa yêu cầu showDialog<bool>; chỉ true mới xóa, false/null không làm gì. context.mounted bảo vệ điều hướng sau await.

## 5. Trang chủ và lọc

Danh sách mẫu khởi tạo một lần cho phiên màn hình, không tạo lại mỗi lần tick checkbox. Ngày chọn mặc định hôm nay. Lọc khả dụng theo ngày trước, sau đó kết hợp điều kiện nhóm và chuỗi tìm kiếm trim/toLowerCase trên tên + ghi chú. Bộ lọc không đổi số tổng/tiến độ của ngày, chỉ đổi các thẻ nhìn thấy. Controller tìm kiếm được xóa sau thêm thành công để thói quen mới xuất hiện.

Checkbox lấy giá trị từ store; callback setCompleted là nơi chặn nghiệp vụ, không chỉ dựa vào giới hạn date picker. Timer làm mới giao diện mỗi phút và được cancel khi dispose. Các thẻ có key theo ID để không gán nhầm trạng thái khi danh sách thay đổi.

## 6. Thống kê

progress tránh chia 0. Trang StatisticsScreen tính đúng bảy ngày lịch gồm hôm nay, cộng số hoàn thành và số thói quen khả dụng rồi chia. Đây là trung bình có trọng số theo lượt thói quen-ngày. streak bắt đầu hôm nay nếu đã xong, nếu chưa thì từ hôm qua, sau đó lùi cho đến ngày chưa xong. Không lưu số chuỗi riêng nên hủy dấu ở quá khứ sẽ cập nhật chuỗi ngay.

Ví dụ A tạo ngày 8, B tạo ngày 10: ngày 8 chỉ có mẫu số 1. Nếu ngày 8,9,10 hoàn thành A và chưa làm B thì tổng 7 ngày là 3/4, không phải trung bình của 7 phần trăm. Chuỗi A là 3; nếu bỏ ngày 9 thì chuỗi còn 1.

## 7. Ngôn ngữ và widget

MyApp giữ bool chọn tiếng Anh; LanguageScope là InheritedWidget, thông báo widget phụ thuộc khi ngôn ngữ thay đổi. context.tr nhận bản Việt và Anh. MaterialApp có locale/supportedLocales và GlobalMaterialLocalizations để date picker, tooltip, bộ đếm ký tự đi theo ngôn ngữ. Habit không bị dịch khi đổi locale.

Scaffold/AppBar phân bố màn hình; SafeArea tránh vùng hệ thống; Center + ConstrainedBox giới hạn chiều rộng desktop; ListView cho phép cuộn trên màn hình hẹp và khi bàn phím mở; Expanded/Flexible giúp văn bản dài xuống dòng. Material 3, ColorScheme và Card giữ phong cách thống nhất.

## 8. Kiểm thử nên tự đọc và chạy

habit_test: ngày tạo không phụ thuộc giờ. habit_store_test: chặn ngày sai/ID sai, mẫu số, sửa/xóa, chuỗi và phiên RAM mới. habit_detail_test: sửa giữ lịch sử, hủy xóa, xác nhận xóa. widget_test: thêm/đánh dấu/hủy và bố cục hẹp. search_statistics_test: tìm/lọc kết hợp, kết quả rỗng, bảy thanh tiến độ. localization_date_test: tiếng Anh, không dịch nội dung, ngày quá khứ, giới hạn độ dài và bàn phím.

Đọc `expect` như một hợp đồng: trước thao tác là gì, sau thao tác phải là gì. Không thay tên test để che lỗi; khi giao diện thay đổi vị trí, đưa widget vào vùng nhìn thấy trước khi tap.
