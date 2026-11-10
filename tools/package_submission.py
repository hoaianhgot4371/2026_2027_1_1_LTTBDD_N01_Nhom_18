"""Package tracked project files and prepared handover documents. No build/cache/local config.
Run after final commit: python tools/package_submission.py
"""
from pathlib import Path, PurePosixPath
import subprocess, zipfile, shutil, hashlib, json, sys, argparse
sys.stdout.reconfigure(encoding='utf-8')
root=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('--output', default='deliverables')
args=parser.parse_args()
out=(root/args.output).resolve()
if not out.is_relative_to(root):raise RuntimeError('Output must stay inside workspace.')
out.mkdir(parents=True,exist_ok=True)
bundle=out/'Nhóm_18'
# Refuse to replace an existing bundle: preserve any student-added diagrams or video.
if bundle.exists():
    raise SystemExit('Bundle already exists. Preserve/review student additions before choosing a new output directory.')
for part in ['Code','Báo cáo','Thuyết trình','Demo']:(bundle/part).mkdir(parents=True,exist_ok=True)
tracked=subprocess.check_output(['git','ls-files','-z'],cwd=root).decode('utf-8').split('\0')
banned_dirs={'.git','.dart_tool','build','.gradle','.cxx','ephemeral','.pub-cache','.pub','__pycache__','deliverables'}
banned_names={'local.properties','key.properties','.env'}
allowed=[]
for name in filter(None,tracked):
    p=PurePosixPath(name)
    if any(x in banned_dirs for x in p.parts) or p.name in banned_names or p.suffix.lower() in {'.jks','.keystore','.apk','.pyc','.p12','.pem'}:
        raise RuntimeError('Unexpected machine/build/secret file tracked: '+name)
    src=root/name
    if not src.is_file():raise RuntimeError('Missing tracked source '+name)
    target=bundle/'Code'/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target)
    allowed.append(name)
for name in ['Nhip_Song_Bao_Cao.docx','Nhip_Song_Bao_Cao.pdf','report.md']:
    shutil.copy2(root/'docs/report'/name,bundle/'Báo cáo'/name)
for name in ['code-guide.md','diagram-instructions.md','submission-checklist.md']:
    shutil.copy2(root/'docs'/name,bundle/'Báo cáo'/name)
shutil.copytree(root/'docs/screenshots',bundle/'Báo cáo'/'Anh_chay_web')
shutil.copytree(root/'docs/verification',bundle/'Báo cáo'/'Ket_qua_kiem_tra')
for name in ['Nhip_Song_Thuyet_Trinh.pptx','Nhip_Song_Thuyet_Trinh.pdf']:
    shutil.copy2(root/'docs/slides'/name,bundle/'Thuyết trình'/name)
shutil.copy2(root/'docs/demo/demo-script.md',bundle/'Demo'/'Kich_ban_va_huong_dan.md')
(bundle/'Demo'/'CHUA_CO_VIDEO.txt').write_text('Chưa có video sinh viên tự quay/thuyết minh. Sinh viên cần quay giọng thật, tối đa 5 phút và 100 MB, kiểm tra file rồi bổ sung trước khi nộp.\n',encoding='utf-8')
commit=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()
(bundle/'CAN_BO_SUNG_TRUOC_NOP.txt').write_text(
    'Gói chuẩn bị Nhịp Sống — Nhóm 18\nCommit nguồn: '+commit+'\n'
    'Chưa phải hồ sơ nộp hoàn chỉnh: cần bìa đúng mẫu Bìa BTL.docx, sơ đồ sinh viên tự vẽ và minh chứng, video tự quay/giọng thật.\n'
    'Ảnh minh chứng là Chrome web, chưa chạy trên điện thoại Android. Tự kiểm tra Android, lời mời giảng viên nếu chưa gửi và rà soát bản nộp cuối.\n'
    'Trên Windows, chép Code sang đường dẫn không dấu (ví dụ C:/DuAn/nhip_song) trước khi chạy; đã quan sát lỗi SDK analyzer trong đường dẫn Nhóm_18 có dấu.\n'
    'Không có build/cache, cấu hình máy, APK hoặc khóa ký trong Code. Chạy flutter pub get rồi flutter build apk --release để tạo APK.\n',encoding='utf-8')
manifest={p.relative_to(bundle).as_posix():hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(bundle.rglob('*')) if p.is_file()}
(bundle/'SHA256.json').write_text(json.dumps({'source_commit':commit,'files':manifest},ensure_ascii=False,indent=2),encoding='utf-8')
archive=out/'Nhóm_18.zip'
if archive.exists():raise RuntimeError('Existing archive: refusing to overwrite.')
with zipfile.ZipFile(archive,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(bundle.rglob('*')):
        if p.is_file():z.write(p,p.relative_to(out).as_posix())
with zipfile.ZipFile(archive) as z:
    assert z.testzip() is None
    for info in z.infolist():
        p=PurePosixPath(info.filename)
        assert p.parts[0]=='Nhóm_18' and '..' not in p.parts
        assert not any(x in banned_dirs for x in p.parts)
        assert p.name not in banned_names
        assert p.suffix.lower() not in {'.jks','.keystore','.apk','.pyc','.p12','.pem'}
    for relative,digest in manifest.items():
        assert hashlib.sha256(z.read('Nhóm_18/'+relative)).hexdigest()==digest
result={'source_commit':commit,'archive':str(archive),'bytes':archive.stat().st_size,'tracked_code_files':len(allowed),'bundle_files':len(manifest)+1,'zip_crc':'passed','sha256_files':'passed','no_build_cache_secrets':'passed','video_present':False,'student_diagrams_present':False}
(out/'package-validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
