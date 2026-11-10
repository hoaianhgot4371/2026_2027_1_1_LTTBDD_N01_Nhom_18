from pathlib import Path
import sys,json,zipfile
sys.stdout.reconfigure(encoding='utf-8')
from pypdf import PdfReader
from docx import Document
from pptx import Presentation
import pymupdf
root=Path.cwd()
report=root/'docs/report/Nhip_Song_Bao_Cao.pdf'
slides=root/'docs/slides/Nhip_Song_Thuyet_Trinh.pdf'
r=PdfReader(report);s=PdfReader(slides)
assert len(s.pages)==9
text='\n'.join(p.extract_text() for p in r.pages)
for required in ['24106659','SRS','SAD','Nguyễn Xuân Quế','github.com','16']:
    assert required in text,required
assert len(Document(root/'docs/report/Nhip_Song_Bao_Cao.docx').inline_shapes)==7
assert len(Presentation(root/'docs/slides/Nhip_Song_Thuyet_Trinh.pptx').slides)==9
for f in [root/'docs/report/Nhip_Song_Bao_Cao.docx',root/'docs/slides/Nhip_Song_Thuyet_Trinh.pptx']:
    with zipfile.ZipFile(f) as z:assert z.testzip() is None
preview=root/'build/document-previews';preview.mkdir(parents=True,exist_ok=True)
for file,label in [(report,'report'),(slides,'slide')]:
    doc=pymupdf.open(file)
    for i,page in enumerate(doc):
        page.get_pixmap(matrix=pymupdf.Matrix(.55,.55)).save(preview/f'{label}-{i+1:02}.png')
result={'report_pdf_pages':len(r.pages),'report_docx_images':7,'slide_pdf_pages':len(s.pages),'pptx_slides':9,'office_zip_structure':'passed','vietnamese_pdf_text':'passed','pdf_pages_rendered':'all','office_gui_opened':False}
(root/'docs/verification/document-validation.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(result,ensure_ascii=False,indent=2))
