# BÁO CÁO BÀI TẬP LỚN — NHỊP SỐNG

## Thông tin và tình trạng hồ sơ

Hồ Văn Hoài Anh — MSV 24106659. Nhóm 18, lớp CSE702027-1-1-26(N01). Giảng viên: ThS. Nguyễn Xuân Quế. Thực hiện cá nhân, đã được giảng viên cho phép theo thông tin sinh viên cung cấp.

Repository: https://github.com/hoaianhgot4371/2026_2027_1_1_LTTBDD_N01_Nhom_18

Đây là nội dung báo cáo được chuẩn bị từ mã nguồn và kiểm thử thực tế. Chưa có mẫu “Bìa BTL.docx” trong workspace: cần bổ sung bìa theo mẫu khi nhận được. Không tự nhận đã dùng mẫu bìa. Các vị trí sơ đồ đang để trống có chủ đích; sinh viên phải tự vẽ bằng phần mềm, chèn hình và bổ sung minh chứng. Video phải do sinh viên tự quay và tự thuyết minh.

## 1. Giới thiệu

### 1.1. Bài toán và mục tiêu

Người dùng cần ghi nhớ các hoạt động nhỏ như uống nước, đọc sách, thư giãn và viết nhật ký. Danh sách thuần văn bản khó cho biết ngày nào đã thực hiện và tiến độ chung. Nhịp Sống tổ chức thói quen theo nhóm, cho phép đánh dấu theo ngày và cung cấp số liệu bảy ngày gần nhất.

Mục tiêu là ứng dụng Flutter có giao diện rõ ràng, nhiều màn hình, chạy được bản Android, hỗ trợ Việt/Anh, có kiểm thử nghiệp vụ và luồng giao diện. Phạm vi bài tập cho phép RAM nên hệ thống không triển khai máy chủ, đăng nhập, CSDL hoặc đồng bộ. Việc mất dữ liệu khi đóng/tải lại được thông báo trên giao diện và tài liệu.

### 1.2. Phạm vi và thuật ngữ

Thói quen là một mục có ID, tên, ghi chú, nhóm và ngày tạo. Ngày là ngày lịch địa phương bỏ phần giờ. Một lượt khả dụng là một cặp thói quen-ngày mà ngày không trước ngày tạo. Hoàn thành là sự hiện diện của ID trong tập đánh dấu của ngày đó. Chuỗi là số ngày liên tiếp theo quy tắc ở mục 3.

Ứng dụng không có chức năng thương mại, thu chi, mạng xã hội, nhắc giờ hoặc điểm thưởng. Không giả lập dữ liệu sử dụng cá nhân thành thành tích thực tế. Bốn thói quen ban đầu là mẫu, được tạo tại ngày mở phiên ứng dụng, chưa hoàn thành.

## 2. SRS — Đặc tả yêu cầu phần mềm

### 2.1. Tác nhân, môi trường và giả định

Tác nhân chính là Người dùng, tự quản lý dữ liệu của một phiên. Trình duyệt/Android cung cấp ngày giờ và môi trường chạy. GitHub chỉ là liên kết bên ngoài để xem mã nguồn, không phải nơi lưu dữ liệu thói quen. Giả định thiết bị cung cấp đồng hồ và múi giờ phù hợp; hệ thống không có thời gian tin cậy từ máy chủ.

Môi trường phát triển đã dùng Flutter 3.47.9, Dart 3.13.7 trên Windows, Android SDK/NDK đã cấu hình. Máy khác cần cài SDK và chạy flutter pub get. Xem log kiểm chứng để biết công cụ đã chạy, không đồng nhất môi trường phát triển với thiết bị Android đã kiểm thử.

### 2.2. Yêu cầu chức năng

FR01 — Thêm: mở biểu mẫu; tên bắt buộc sau trim, tối đa 60 ký tự; ghi chú tùy chọn tối đa 240 ký tự; chọn một trong health, learning, mindfulness, personal. Ngày tạo là ngày lưu thành công; ID duy nhất trong phiên; chưa có dấu hoàn thành.

FR02 — Xem: danh sách theo ngày khả dụng; thẻ thể hiện nhóm, tên, ghi chú, trạng thái và nút xem chi tiết. Trang chi tiết hiển thị nội dung và ngày tạo.

FR03 — Sửa: nạp sẵn nội dung, áp dụng cùng kiểm tra với thêm; cập nhật đối tượng có cùng ID, giữ ngày tạo và mọi dấu hoàn thành. Hủy/quay lại không ghi thay đổi.

FR04 — Xóa: mở hộp thoại nêu rõ không hoàn tác; chỉ xác nhận mới xóa. Xóa cả ID khỏi các tập hoàn thành, làm thay đổi thống kê của phiên. Hủy hoặc đóng hộp thoại giữ nguyên.

FR05 — Ngày và hoàn thành: chọn ngày từ ngày tạo sớm nhất còn trong danh sách đến hôm nay; ngày tương lai không được chọn. Lớp nghiệp vụ vẫn kiểm tra ID, tương lai và ngày tạo để không phụ thuộc riêng date picker. Đánh dấu/hủy cập nhật ngay số hoàn thành và tiến độ. Mỗi thói quen tối đa một dấu trong một ngày.

FR06 — Tìm/lọc: tìm chuỗi trong tên hoặc ghi chú, trim từ khóa và không phân biệt hoa/thường; còn phân biệt dấu. Kết hợp với một nhóm hoặc Tất cả. Hiện trạng thái không có kết quả; không xóa dữ liệu gốc. Tổng/tiến độ ngày tính trên tất cả thói quen khả dụng, không chỉ kết quả lọc.

FR07 — Thống kê: hiển thị đúng bảy ngày gồm hôm nay, số lượt hoàn thành/khả dụng, thanh tiến độ từng ngày, tỷ lệ tổng và chuỗi theo từng thói quen. Hiển thị giải thích công thức và trường hợp không có dữ liệu.

FR08 — Ngôn ngữ: chuyển Việt/Anh cho nhãn, biểu mẫu, lỗi, hộp thoại, trạng thái và Material date picker. Không tự dịch tên/ghi chú đã nhập; dữ liệu mẫu cũng được xem là nội dung dữ liệu. Ngôn ngữ lựa chọn chỉ tồn tại trong phiên RAM.

FR09 — Thông tin: hiển thị họ tên, MSV, lớp, nhóm, giảng viên, thực hiện cá nhân và địa chỉ GitHub; cho phép mở liên kết hoặc chọn/copy địa chỉ khi không mở được.

FR10 — Lưu RAM: thông báo mất dữ liệu khi đóng/tải lại. Không ghi file, không gửi dữ liệu thói quen tới mạng; liên kết GitHub mở ngoài ứng dụng khi người dùng yêu cầu.

### 2.3. Yêu cầu phi chức năng

NFR01 — Dễ dùng: Material 3, tông xanh, khoảng cách nhất quán, có trạng thái trống, hộp thoại xác nhận và lỗi gắn trường nhập. SafeArea và danh sách cuộn hỗ trợ màn hình hẹp, chữ lớn và bàn phím.

NFR02 — Đúng nghiệp vụ: chuẩn hóa ngày, tránh chia 0, không đếm ID trùng, giữ lịch sử khi sửa. Thay đổi UI không thể vượt kiểm tra ngày của HabitStore.

NFR03 — Bảo trì: tách mô hình, store, chuỗi giao diện và màn hình. Kiểm thử dùng clock truyền vào để tái lập các ngày cố định. Log kiểm tra lưu cùng dự án, commit từng đợt sau kiểm tra.

NFR04 — Quy mô: mục tiêu danh sách cá nhân nhỏ trong RAM. Tìm/lọc và đếm theo danh sách; không tuyên bố hiệu năng cho hàng triệu mục. Không có benchmark tải lớn.

NFR05 — Riêng tư và phát hành: không tài khoản/mật khẩu, không khóa ký release trong Git. APK bài tập dùng cấu hình ký debug hiện có; chưa phải bản phát hành cửa hàng. Không có kiểm thử xâm nhập hay tuyên bố bảo mật đã chứng nhận.

### 2.4. Đặc tả use case

UC01 — Thêm thói quen. Tiền điều kiện: đang ở trang chủ. Luồng chính: chọn Thêm, nhập thông tin, lưu; Form xác thực; Navigator trả Habit; HomeScreen ghi store và về hôm nay, bỏ bộ lọc để thấy mục mới. Hậu điều kiện: tổng tăng một, mục mới chưa hoàn thành. Ngoại lệ: tên trắng/độ dài sai hiển thị lỗi; hủy/back trả null, không tăng tổng.

UC02 — Xem và sửa. Tiền điều kiện: thói quen còn tồn tại. Chọn Xem chi tiết, bấm Sửa, đổi nội dung, lưu. Store tìm ID và cập nhật tên/ghi chú/nhóm, giữ createdAt và completion. Nếu hủy không cập nhật. Hậu điều kiện: trang chi tiết và danh sách thể hiện giá trị mới; thống kê không mất dấu cũ.

UC03 — Xóa có xác nhận. Từ chi tiết bấm Xóa; hộp thoại hỏi rõ đối tượng và ảnh hưởng lịch sử. Hủy/đóng không ghi. Xác nhận: quay về danh sách, xóa Habit và dấu tương ứng; tổng và thống kê tính lại. Không có khôi phục sau xóa trong phiên.

UC04 — Hoàn thành theo ngày. Tiền điều kiện: ngày trong khoảng tạo đến hôm nay. Chọn ngày, tick hoặc bỏ tick; lớp store kiểm tra ngày/ID; cập nhật Set và thông báo UI. Sai điều kiện: từ chối thay đổi. Hậu điều kiện: trạng thái các ngày khác độc lập. Ngày trước tạo không hiển thị thói quen.

UC05 — Tìm và lọc. Nhập từ khóa, chọn nhóm; áp dụng điều kiện giao nhau. Không có kết quả thì hiện thông báo, dữ liệu gốc vẫn còn. Xóa từ khóa/chọn Tất cả khôi phục danh sách ngày đó. Tổng tiến độ ngày vẫn là tổng toàn bộ danh sách khả dụng.

UC06 — Thống kê. Mở từ AppBar; hệ thống tạo dãy bảy ngày lịch và tính số liệu từ store. Người dùng xem tỷ lệ, chuỗi, đọc công thức; quay lại không thay đổi dữ liệu.

UC07 — Ngôn ngữ/thông tin. Chạm biểu tượng ngôn ngữ để chuyển; MaterialApp đổi locale, LanguageScope dựng lại chuỗi. Xem trang nhóm và mở link nếu thiết bị hỗ trợ. Nếu không mở được thì hiện thông báo và giữ địa chỉ có thể sao chép.

### 2.5. Vị trí sơ đồ SRS

[CHÈN SƠ ĐỒ USE CASE DO SINH VIÊN TỰ VẼ BẰNG PHẦN MỀM VÀ MINH CHỨNG QUÁ TRÌNH.]

[CHÈN SƠ ĐỒ HOẠT ĐỘNG THÊM THÓI QUEN VÀ ĐÁNH DẤU THEO NGÀY DO SINH VIÊN TỰ VẼ.]

Hướng dẫn nội dung bằng chữ tại docs/diagram-instructions.md. Các khung này không phải sơ đồ đã hoàn thành.

## 3. Quy tắc dữ liệu và công thức

### 3.1. Mô hình

HabitCategory có bốn giá trị; giao diện dịch nhãn nhưng không đổi enum. Habit gồm id, name, note, category, iconIndex, createdAt. Các trường final. ID liên kết completion và không dựa vào tên vì tên có thể trùng hoặc bị sửa. createdAt được chuẩn hóa ngày lịch trong constructor.

HabitStore giữ danh sách riêng và Map<DateTime, Set<String>>. Key là ngày lịch, value là tập ID hoàn thành. Set ngăn đếm đôi. Getter habits trả danh sách không thể sửa từ bên ngoài. Lưu RAM có nghĩa mọi dữ liệu tạo/sửa/xóa và dấu hoàn thành không tồn tại qua phiên mới.

### 3.2. Tiến độ và thống kê

A(d) là các thói quen còn tồn tại có createdAt không sau d. C(d) là số ID hoàn thành của A(d). Tiến độ P(d)=C(d)/|A(d)|, bằng 0 nếu mẫu số 0. Không tính thói quen chưa được tạo vào mẫu số ngày quá khứ. Không tính thống kê theo kết quả tìm kiếm/lọc.

Bảy ngày là từ ngày hiện tại trừ sáu đến ngày hiện tại, theo ngày lịch địa phương. Tỷ lệ tuần W bằng tổng C(d) chia tổng |A(d)| trong cửa sổ này; nếu mẫu số 0 thì W=0. Đây là tỷ lệ theo lượt thói quen-ngày, không phải trung bình bảy tỷ lệ ngày. UI làm tròn phần trăm hiển thị, dữ liệu đếm giữ số nguyên.

Ví dụ A tạo ngày 8, B tạo ngày 10; hôm nay ngày 10; A hoàn thành các ngày 8,9,10 và B chưa xong: số lượt hoàn thành 3, số lượt khả dụng 4, W=75%. Các ngày 4–7 không có thói quen nên không thêm mẫu số. Tiến độ ngày 10 là 1/2=50%.

### 3.3. Chuỗi và tác động CRUD

Chuỗi từng thói quen đếm liên tiếp kết thúc hôm nay. Nếu hôm nay chưa hoàn thành, bắt đầu từ hôm qua để không cắt chuỗi khi ngày hiện tại chưa kết thúc. Đi lùi đến ngày không hoàn thành thì dừng; không có dấu trước ngày tạo vì store cấm. Với ví dụ trên, chuỗi A là 3; bỏ dấu ngày 9 thì còn 1. Nếu ngày 10 chưa làm nhưng 8 và 9 đã làm thì chuỗi 2.

Sửa giữ ID/createdAt và dấu hoàn thành. Xóa xóa ID trong mọi ngày, do đó thống kê quá khứ của phiên được tính lại theo các thói quen còn tồn tại. Đây là lựa chọn thiết kế của bài tập; chưa có cơ chế lưu trữ thói quen đã xóa hoặc khôi phục.

## 4. SAD — Thiết kế kiến trúc phần mềm

### 4.1. Kiến trúc tổng thể và thành phần

Ứng dụng một tiến trình Flutter, không backend. Lớp trình bày gồm các màn hình và widget Material. Lớp nghiệp vụ/dữ liệu là HabitStore trong RAM; mô hình là Habit/HabitCategory. main.dart cấu hình theme và locale; LanguageScope truyền trạng thái ngôn ngữ đến màn hình. url_launcher chỉ dùng mở repository ngoài ứng dụng.

HomeScreen sở hữu store, danh sách mẫu, ngày chọn, từ khóa, nhóm lọc và controller tìm kiếm. Khi dispose, store/controller/timer do màn hình sở hữu được giải phóng. Store có thể truyền từ ngoài trong test để kiểm tra ngày cố định. Không dùng singleton toàn cục cho dữ liệu.

AddHabitScreen quản lý Form, controller, enum nhóm; trả Habit hoặc null qua Navigator. HabitDetailScreen đọc store bằng ListenableBuilder, điều phối sửa và xác nhận xóa. StatisticsScreen đọc số liệu từ store. AboutScreen hiển thị thông tin và xử lý thất bại mở URL.

### 4.2. Thiết kế lớp

Habit là lớp dữ liệu bất biến; constructor chuẩn hóa ngày và isAvailableOn kiểm tra ngày. HabitStore kế thừa ChangeNotifier, cung cấp add/update/delete, setCompleted/isCompleted, availableOn/completedCount/progress/streak, today và nextId. Clock tùy chọn giúp test xác định thời gian.

HomeScreen và AddHabitScreen là StatefulWidget vì có trạng thái tương tác; các trang chi tiết/thống kê nhận store và phản ứng qua ListenableBuilder. LanguageScope kế thừa InheritedWidget; updateShouldNotify so sánh ngôn ngữ. Extension context.tr chọn chuỗi Việt hoặc Anh, không sửa nội dung Habit.

### 4.3. Luồng tương tác và xử lý lỗi

Luồng thêm: người dùng bấm nút; HomeScreen push route; Form kiểm tra; nếu đúng, AddHabitScreen pop Habit; HomeScreen kiểm tra mounted/kết quả, thêm store, về hôm nay và xóa tìm/lọc để mục mới không bị ẩn. Nếu hủy, không gọi add.

Luồng sửa: trang chi tiết push form với Habit cũ; lưu trả đối tượng; store tìm ID và tạo bản cập nhật giữ ngày tạo. notifyListeners dựng lại chi tiết. Khi quay về, HomeScreen gọi setState để đồng bộ danh sách.

Luồng hoàn thành: checkbox gửi ID/ngày/value; store chuẩn hóa ngày, từ chối ID không tồn tại, tương lai hoặc trước tạo; sau đó thêm/bỏ ID khỏi Set. UI tính lại tổng và thanh tiến độ. Luồng xóa chỉ thực hiện sau dialog trả true.

Lỗi nhập được hiện trong Form; URL không mở được có SnackBar và địa chỉ chọn/copy. async dùng mounted trước tương tác context khi cần. Các trường hợp không dữ liệu dùng tỷ lệ 0; danh sách lọc trống có thông báo riêng.

### 4.4. Thiết kế giao diện và cây widget

MaterialApp chứa theme Material 3, locale và delegates. HomeScreen dùng Scaffold/AppBar; SafeArea bảo vệ vùng hệ thống; Center/ConstrainedBox giới hạn chiều rộng 720; ListView chứa giới thiệu, cảnh báo RAM, số tổng, nút thêm, tiến độ, chọn ngày, tìm/lọc và thẻ. Card dùng Row/Expanded/Column để nội dung dài xuống dòng.

Form dùng ListView để cuộn khi bàn phím mở; kéo danh sách có thể ẩn bàn phím. Tên và ghi chú có bộ đếm, lỗi, viền và nhãn song ngữ. Trạng thái checkbox có nhãn trợ năng. Các kiểm thử mô phỏng 320 px và chữ 150%; đây là kiểm thử widget, không thay thế đánh giá trên thiết bị thật.

### 4.5. Vị trí sơ đồ SAD

[CHÈN KIẾN TRÚC TỔNG THỂ VÀ SƠ ĐỒ THÀNH PHẦN DO SINH VIÊN TỰ VẼ.]

[CHÈN SƠ ĐỒ LỚP DỰA TRÊN MÃ THỰC TẾ DO SINH VIÊN TỰ VẼ.]

[CHÈN SƠ ĐỒ TUẦN TỰ THÊM VÀ ĐÁNH DẤU THEO NGÀY DO SINH VIÊN TỰ VẼ.]

[CHÈN CÂY WIDGET TRANG CHỦ/BIỂU MẪU DO SINH VIÊN TỰ VẼ.]

Mọi sơ đồ cần file gốc từ phần mềm, ảnh minh chứng quá trình và chú thích nguồn sinh viên tự vẽ; không sinh từ AI hoặc code.

## 5. Triển khai và tổ chức mã nguồn

lib/models/habit.dart chứa mô hình. lib/data/habit_store.dart chứa nguồn dữ liệu RAM và công thức. lib/main.dart và lib/language.dart cấu hình ứng dụng/ngôn ngữ. lib/screens có home_screen, add_habit_screen, habit_detail_screen, statistics_screen, about_screen. test chứa các hợp đồng nghiệp vụ và widget. tools/verify.ps1 chạy kiểm tra và ghi log; tài liệu/ảnh ở docs.

Quy trình: đọc Git, giữ lịch sử; triển khai từng đợt; chạy analyze/test/build APK/diff check trước mỗi commit; chỉ stage các file liên quan và push không force. Không đưa build/cache, local.properties, khóa ký hoặc mật khẩu vào Git. Nội dung tự động tạo tài liệu chỉ dùng cho văn bản, slide, PDF và ZIP; không sinh sơ đồ.

## 6. Kiểm chứng và ảnh chạy thực tế

### 6.1. Phương pháp

Kiểm thử model xác nhận ngày trước/đúng/sau tạo. Kiểm thử store dùng clock cố định kiểm tra các ngày và công thức, xóa/sửa/chuỗi. Kiểm thử widget thao tác Form, route, dialog, checkbox, dropdown, tìm kiếm, ngôn ngữ, màn hình hẹp và bàn phím. Mỗi lần hoàn tất đợt có log analyze, test, build release, git diff --check với mã thoát.

Không ghi các test thất bại ban đầu thành thành công; log cuối của từng đợt là lần đã sửa và chạy lại đầy đủ. Đọc số test và APK cụ thể trong docs/verification/summary.md và các file log gốc. Cảnh báo Java native access trong Gradle không đồng nghĩa build thất bại nếu mã thoát 0 và có APK.

### 6.2. Danh mục đối chiếu kiểm thử

FR01/FR03: widget_test, habit_detail_test, localization_date_test kiểm tra thêm/sửa, tên trắng, trim, độ dài, hủy và bàn phím. FR04: habit_detail_test hủy/xác nhận xóa, store_test dọn dấu. FR05: habit_test và store_test chặn ngày sai; localization_date_test thao tác chọn quá khứ và giới hạn date picker.

FR06/FR07: search_statistics_test kiểm tra tìm/lọc giao nhau, trạng thái rỗng, bảy thanh tiến độ; store_test kiểm tra mẫu số ngày tạo, chia 0 và chuỗi đứt. FR08/FR09: localization_date_test kiểm tra lỗi/hộp thoại tiếng Anh, giữ nguyên tên nhập và thông tin nhóm. FR10: store_test xác nhận phiên store mới không có dấu cũ; giao diện/README nêu RAM.

### 6.3. Ảnh minh chứng

Ảnh ở phần này chỉ được chèn khi có file chụp từ ứng dụng thực chạy; mỗi ảnh ghi môi trường. Không dùng ảnh dựng hoặc mockup. Bản web trên Chrome ở kích thước hẹp không được ghi là ảnh chạy Android. Nếu không có thiết bị Android, giữ rõ trạng thái chưa chạy trên điện thoại.

[ẢNH THỰC TẾ ĐƯỢC TRÌNH TẠO TÀI LIỆU CHÈN TỪ docs/screenshots; ĐỌC CHÚ THÍCH MÔI TRƯỜNG.]

## 7. Hướng dẫn chạy, demo và bàn giao

Lưu ý Windows: sau giải nén, chép Nhóm_18/Code sang đường dẫn không dấu, ví dụ C:/DuAn/nhip_song, trước khi chạy Flutter. Lần thử SDK hiện tại ở đường dẫn có dấu làm analysis server thoát 255 với FormatException; cùng mã nguồn trong đường dẫn ASCII đã qua analyze, 16 test và build APK release 49.8 MB. Xem package-source-check.txt để đối chiếu kết quả build nguồn sạch. Đây là quan sát môi trường, không phải chức năng ứng dụng.

Cài Flutter/Android SDK phù hợp, chạy flutter pub get, flutter analyze, flutter test. Chạy web bằng flutter run -d chrome. Build Android bằng flutter build apk --release; APK tại build/app/outputs/flutter-apk/app-release.apk. Để chạy Android cần thiết bị bật USB debugging hoặc emulator, kiểm tra flutter devices rồi flutter run -d ID. Không coi build là đã cài/chạy trên điện thoại.

Mở docs/code-guide.md để đọc giải thích dữ liệu, navigation, state, ngôn ngữ, widget và công thức. Kịch bản docs/demo/demo-script.md chia thời gian dưới 5 phút, đề xuất MP4/H.264 720p 30fps khoảng 2 Mbit/s và yêu cầu kiểm tra kích thước thật ≤100 MB. Sinh viên tự quay và dùng giọng thật.

ZIP dự kiến có Nhóm_18/Code, Báo cáo, Thuyết trình, Demo. Code không chứa build/cache/Git/config máy. Báo cáo có DOCX/PDF và hướng dẫn sơ đồ; slide PPTX/PDF tối đa 10 trang; Demo chỉ có kịch bản/hướng dẫn khi chưa có video. ZIP là gói chuẩn bị, chưa phải bản nộp hoàn chỉnh nếu còn sơ đồ/bìa/video.

## 8. Hạn chế và hướng phát triển

Dữ liệu RAM mất khi đóng/tải lại; lịch sử nhiều ngày chỉ hình thành nếu phiên tồn tại qua các ngày, do đó demo mới không có chuỗi dài. Đồng hồ địa phương có thể bị đổi; ứng dụng không chống gian lận thời gian. Trang chủ làm mới ngày theo phút; không có thông báo nền. Tìm kiếm chưa bỏ dấu tiếng Việt. Xóa làm mất lịch sử; chưa có lưu trữ mềm/khôi phục.

Hướng phát triển phù hợp: lưu cục bộ có migration, lịch nhắc có quyền người dùng, sao lưu/khôi phục và kiểm thử thiết bị Android nhiều kích thước. Đây là đề xuất chưa triển khai, không tính vào chức năng hoàn thành.

Trước nộp, sinh viên tự vẽ/chèn sơ đồ và minh chứng, bổ sung bìa đúng mẫu, quay/thuyết minh video, kiểm tra trên Android, gửi lời mời giảng viên nếu chưa gửi, rà soát thông tin và đóng lại ZIP. Trợ lý chưa gửi lời mời giảng viên và không tạo minh chứng đóng góp hay video thay sinh viên.

## 9. Tài liệu tham khảo và nguồn nội bộ

Mã nguồn và lịch sử dự án: https://github.com/hoaianhgot4371/2026_2027_1_1_LTTBDD_N01_Nhom_18

SDK và tài liệu tham khảo để sinh viên đọc thêm: https://docs.flutter.dev/ ; https://api.flutter.dev/ ; https://dart.dev/guides . Các mô tả triển khai trong báo cáo được đối chiếu từ mã và test của dự án, không khẳng định đã khảo sát thêm tài liệu bên ngoài.

Các tệp nguồn nội bộ: README.md; docs/code-guide.md; docs/diagram-instructions.md; docs/verification/*.txt; test/*.dart. Thông tin sinh viên/giảng viên và quyền làm cá nhân do sinh viên cung cấp trong yêu cầu.
