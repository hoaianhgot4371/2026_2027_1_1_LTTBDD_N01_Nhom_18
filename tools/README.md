# Công cụ hồ sơ và tái lập

Các script này phục vụ bài tập, không tạo sơ đồ và không tạo video/giọng nói.

- `verify.ps1`: analyze/test/build APK/diff check và log. Đường dẫn Flutter hiện theo máy sinh viên; đổi biến `$flutter` trên máy khác.
- `build_documents.py`: xuất văn bản báo cáo DOCX/PDF, PPTX/PDF từ report.md, summary.md, slides.json và ảnh chụp có thật. Cần Arial/Arial Bold trong C:/Windows/Fonts; máy khác điều chỉnh FONTS tới bộ font có tiếng Việt. DOCX/PPTX chỉnh sửa được; không yêu cầu Word/PowerPoint để tạo, nhưng cần sinh viên mở kiểm tra bằng phần mềm nộp.
- `validate_documents.py`: kiểm tra file Office là ZIP hợp lệ, nội dung tiếng Việt PDF, số slide 9 và ảnh trong DOCX; render PDF vào build/document-previews. Cần thư viện ở requirements-docs.txt. Render thành công không bảo đảm Word/PowerPoint hiển thị giống tuyệt đối.
- `capture_web.py` và `web_smoke.py`: chụp ảnh/kiểm tra ứng dụng web build thực qua Chrome DevTools. Dùng server cục bộ 8765 và DevTools 9223 với profile tạm riêng. Không dùng profile cá nhân. Các tọa độ trong script phù hợp bố cục hiện tại, cần rà lại khi đổi UI. Log/ảnh là từ web, không Android.
- `package_submission.py`: chạy sau commit cuối, lấy các file được Git theo dõi, chặn thư mục build/cache/config máy/khóa ký, tạo deliverables/Nhóm_18.zip và checksum. Không thay thế thư mục đã tồn tại để bảo vệ sơ đồ/video sinh viên có thể thêm sau. Không commit deliverables.

Ví dụ môi trường Python có pip: `python -m pip install -r tools/requirements-docs.txt`, rồi `python tools/build_documents.py` và `python tools/validate_documents.py`. Runtime portable dùng để tạo hồ sơ phiên này nằm trong thư mục tạm, không phải thành phần ứng dụng và không được đưa vào repository/ZIP.

Bổ sung sơ đồ do sinh viên tự vẽ vào DOCX rồi xuất lại PDF bằng Word/LibreOffice. Nếu sửa report.md và chạy lại script sẽ tạo lại DOCX từ nguồn, vì vậy phải giữ bản đã chèn sơ đồ riêng hoặc cập nhật quy trình nguồn trước khi chạy lại. Không chạy lại generator làm mất phần tự làm.
