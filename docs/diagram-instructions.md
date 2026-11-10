# Hướng dẫn tự vẽ sơ đồ và lưu minh chứng

Tất cả sơ đồ bên dưới phải do sinh viên tự vẽ bằng phần mềm (ví dụ draw.io giao diện kéo/thả, Visio hoặc StarUML). Tài liệu này chỉ mô tả nội dung bằng chữ. Không dùng chức năng sinh hình từ AI, Mermaid, PlantUML hoặc mã lệnh. Không có file sơ đồ do trợ lý tạo.

1. Use case: một tác nhân Người dùng; các ca thêm, xem chi tiết, sửa, xác nhận xóa, chọn ngày/đánh dấu, tìm/lọc, xem thống kê, đổi ngôn ngữ, xem nhóm. Nêu ranh giới ứng dụng RAM; xác nhận xóa là bước bắt buộc trong luồng xóa.
2. Hoạt động thêm: mở biểu mẫu; nhập; kiểm tra tên/độ dài; nếu lỗi quay về nhập và hiện lỗi; nếu hợp lệ tạo Habit ngày hôm nay; trả kết quả; thêm vào store; cập nhật danh sách. Hủy/quay lại trả null và không ghi.
3. Hoạt động hoàn thành: nhận ID/ngày; kiểm tra tồn tại, không tương lai, không trước ngày tạo; sai thì từ chối; đúng thì thêm hoặc bỏ ID trong tập ngày; cập nhật tiến độ.
4. Kiến trúc tổng thể: giao diện Flutter và các màn hình; lớp quản lý HabitStore trong RAM; mô hình Habit; không vẽ máy chủ/CSDL như thể đã triển khai. LanguageScope/Material localization phục vụ giao diện; url_launcher mở GitHub bên ngoài.
5. Thành phần: HomeScreen điều phối Navigator; AddHabitScreen trả Habit; HabitDetailScreen sửa/xóa qua store; StatisticsScreen đọc store; AboutScreen mở link. Chỉ rõ notifyListeners hoặc setState làm mới.
6. Lớp: Habit, HabitCategory, HabitStore, HomeScreen/State, AddHabitScreen/State, HabitDetailScreen, StatisticsScreen, AboutScreen, LanguageScope. Thuộc tính và phương thức lấy từ mã thực tế, chú ý final, ID, createdAt và Map<DateTime, Set<String>>.
7. Tuần tự thêm và hoàn thành: Người dùng, màn hình, Navigator/Form, HabitStore; thể hiện nhánh validate lỗi/hủy, nhánh ngày sai và cập nhật thành công. Không thêm API/database giả.
8. Cây widget: MyApp/LanguageScope/MaterialApp; HomeScreen/Scaffold/AppBar/SafeArea/Center/ConstrainedBox/ListView; từng thẻ Card/Row/Expanded/Column; form Scaffold/Form/ListView/TextFormField/DropdownButtonFormField. Có thể làm hai cây trang chủ và biểu mẫu nếu dễ đọc.

## Minh chứng phải do sinh viên lưu

- Mỗi sơ đồ lưu file gốc có thể sửa, tên người vẽ và ngày thực hiện do bạn tự ghi đúng thực tế.
- Chụp ảnh màn hình phần mềm lúc đang vẽ, có canvas và thanh công cụ; có thể quay ngắn quá trình nếu đề yêu cầu. Không tạo hay sửa ảnh để giả minh chứng.
- Xuất PNG/PDF từ phần mềm, chèn vào vị trí tương ứng trong DOCX; thêm chú thích, nguồn “Sinh viên tự vẽ bằng …”, ngày thật.
- Kiểm tra lại sơ đồ với code trước nộp; xuất lại PDF báo cáo và slide nếu có chèn sơ đồ. Giữ minh chứng cùng file gốc trong thư mục Báo cáo của bản nộp cuối.
