"""Create text reports/slides with actual runtime screenshots. Never generates diagrams.
Run from repo root: python tools/build_documents.py
Dependencies: python-docx, python-pptx, reportlab, pillow.
"""
from pathlib import Path
from html import escape
import json, re, sys
sys.stdout.reconfigure(encoding='utf-8')
from docx import Document
from docx.shared import Cm, Pt as DocPt, RGBColor as DocRGB
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.opc.constants import RELATIONSHIP_TYPE
from pptx import Presentation
from pptx.util import Inches, Pt
from pptx.dml.color import RGBColor
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.enums import TA_JUSTIFY
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Image, PageBreak, KeepTogether
from reportlab.lib.pagesizes import A4
from reportlab.pdfgen import canvas
from PIL import Image as PILImage

ROOT=Path(__file__).resolve().parents[1]
FONTS=Path('C:/Windows/Fonts')
pdfmetrics.registerFont(TTFont('Arial',str(FONTS/'arial.ttf')))
pdfmetrics.registerFont(TTFont('ArialBold',str(FONTS/'arialbd.ttf')))
pdfmetrics.registerFontFamily('Arial',normal='Arial',bold='ArialBold',italic='Arial',boldItalic='ArialBold')
TEAL='#247568'
repo='https://github.com/hoaianhgot4371/2026_2027_1_1_LTTBDD_N01_Nhom_18'
source=(ROOT/'docs/report/report.md').read_text(encoding='utf-8-sig')
summary=(ROOT/'docs/verification/summary.md').read_text(encoding='utf-8-sig')
source+='\n\n## Phụ lục — Kết quả kiểm chứng tại thời điểm bàn giao\n\n'+summary.replace('# Kết quả kiểm chứng','').replace('## ','### ')
report=Document()
sec=report.sections[0]
sec.top_margin=Cm(2);sec.bottom_margin=Cm(2);sec.left_margin=Cm(2.5);sec.right_margin=Cm(2)
sec.page_width=Cm(21);sec.page_height=Cm(29.7)
normal=report.styles['Normal'];normal.font.name='Arial';normal.font.size=DocPt(11)
normal.paragraph_format.space_after=DocPt(7)
normal.paragraph_format.line_spacing=1.15
for name,size in [('Title',24),('Heading 1',18),('Heading 2',15),('Heading 3',12)]:
    report.styles[name].font.name='Arial';report.styles[name].font.size=DocPt(size)
    report.styles[name].font.color.rgb=DocRGB.from_string('247568')
header=sec.header.paragraphs[0];header.text='NHỊP SỐNG · NHÓM 18 · SRS / SAD';header.style='Caption'
footer=sec.footer.paragraphs[0];footer.text='Hồ Văn Hoài Anh — 24106659 | Trang '
fld=OxmlElement('w:fldSimple');fld.set(qn('w:instr'),'PAGE');footer._p.append(fld)
styles={
 'body':ParagraphStyle('body',fontName='Arial',fontSize=10.5,leading=15,spaceAfter=8,alignment=TA_JUSTIFY),
 'h1':ParagraphStyle('h1',fontName='ArialBold',fontSize=19,leading=24,textColor=colors.HexColor(TEAL),spaceBefore=14,spaceAfter=12,keepWithNext=True),
 'h2':ParagraphStyle('h2',fontName='ArialBold',fontSize=15,leading=20,textColor=colors.HexColor(TEAL),spaceBefore=12,spaceAfter=8,keepWithNext=True),
 'h3':ParagraphStyle('h3',fontName='ArialBold',fontSize=12,leading=17,textColor=colors.HexColor(TEAL),spaceBefore=8,spaceAfter=6,keepWithNext=True),
 'caption':ParagraphStyle('caption',fontName='Arial',fontSize=9,leading=12,spaceAfter=10),
}
story=[]
images=[('01-home-desktop.png','Trang chủ tiếng Việt, Chrome desktop.'),
 ('03-form-validation.png','Lỗi tên trống trong biểu mẫu chạy thật trên Chrome.'),
 ('06-delete-confirmation.png','Hộp thoại xóa thực tế; đã kiểm tra hủy không xóa.'),
 ('07-statistics.png','Thống kê thực: 1/5 lượt, 20%; các ngày trước tạo có mẫu số 0.'),
 ('08-about-team.png','Trang nhóm: họ tên, MSV, lớp, giảng viên và repository.'),
 ('09-home-english-narrow.png','Chrome viewport 390×844, giao diện Anh; dữ liệu tên tiếng Việt không bị dịch.'),
 ('10-form-english-narrow.png','Biểu mẫu tiếng Anh tại chiều rộng 390 px, không phải điện thoại Android.')]

def plain(text):
    return re.sub(r'\*\*(.*?)\*\*',r'\1',text).replace('`','')
def add_doc_paragraph(text):
    paragraph = report.add_paragraph()
    for part in re.split(r'(https://[^\s]+)', plain(text)):
        if part.startswith('https://'):
            link = OxmlElement('w:hyperlink')
            link.set(qn('r:id'), paragraph.part.relate_to(part, RELATIONSHIP_TYPE.HYPERLINK, is_external=True))
            run = OxmlElement('w:r')
            properties = OxmlElement('w:rPr')
            color = OxmlElement('w:color'); color.set(qn('w:val'), '247568'); properties.append(color)
            run.append(properties)
            value = OxmlElement('w:t'); value.text = part; run.append(value)
            link.append(run); paragraph._p.append(link)
        else:
            paragraph.add_run(part)
    return paragraph
def markup(text):
    text=escape(plain(text))
    return re.sub(r'https://[^\s<]+',lambda m:f'<link href="{m.group(0)}" color="#247568">{m.group(0)}</link>',text)
def insert_images():
    for i,(file,caption) in enumerate(images,1):
        p=ROOT/'docs/screenshots'/file
        if not p.exists():
            raise RuntimeError('Missing real runtime evidence '+str(p))
        report.add_page_break()
        report.add_heading(f'Ảnh thực tế {i}',level=2)
        w,h=PILImage.open(p).size
        width=min(15.5,18.5*w/h)
        report.add_picture(str(p),width=Cm(width))
        report.add_paragraph(f'Hình {i}. {caption} Nguồn: chụp ứng dụng web release thực chạy, xem web-smoke.json.',style='Caption')
        story.extend([PageBreak(),Paragraph(f'Ảnh thực tế {i}',styles['h2'])])
        maxw,maxh=440,535
        scale=min(maxw/w,maxh/h)
        story.extend([Image(str(p),width=w*scale,height=h*scale),Spacer(1,8),Paragraph(markup(f'Hình {i}. {caption} Nguồn: Chrome thực, docs/verification/web-smoke.json.'),styles['caption'])])

for line in source.splitlines():
    line=line.strip()
    if not line:continue
    if line.startswith('[ẢNH THỰC TẾ'):
        insert_images();continue
    if line.startswith('# '):
        text=plain(line[2:]);report.add_paragraph(text,style='Title');story.append(Paragraph(markup(text),styles['h1']))
    elif line.startswith('## '):
        text=plain(line[3:]);report.add_heading(text,level=1);story.append(Paragraph(markup(text),styles['h1']))
    elif line.startswith('### '):
        text=plain(line[4:]);report.add_heading(text,level=2);story.append(Paragraph(markup(text),styles['h2']))
    else:
        add_doc_paragraph(line);story.append(Paragraph(markup(line),styles['body']))
report.save(ROOT/'docs/report/Nhip_Song_Bao_Cao.docx')
def footer_pdf(c,doc):
    c.setFont('Arial',8);c.setFillColor(colors.HexColor(TEAL))
    c.drawString(50,25,'Nhịp Sống · Nhóm 18 · Hồ Văn Hoài Anh — 24106659')
    c.drawRightString(545,25,f'Trang {doc.page}')
SimpleDocTemplate(str(ROOT/'docs/report/Nhip_Song_Bao_Cao.pdf'),pagesize=A4,rightMargin=50,leftMargin=60,topMargin=45,bottomMargin=45,
 title='Nhịp Sống — SRS và SAD',author='Hồ Văn Hoài Anh — Nhóm 18').build(story,onFirstPage=footer_pdf,onLaterPages=footer_pdf)

slides=json.loads((ROOT/'docs/slides/slides.json').read_text(encoding='utf-8-sig'))
assert len(slides)<=10
prs=Presentation();prs.slide_width=Inches(13.333333);prs.slide_height=Inches(7.5)
pc=canvas.Canvas(str(ROOT/'docs/slides/Nhip_Song_Thuyet_Trinh.pdf'),pagesize=(960,540))
pc.setTitle('Nhịp Sống — Thuyết trình Nhóm 18');pc.setAuthor('Hồ Văn Hoài Anh')
def textbox(slide,x,y,w,h,text,size=20,bold=False,color='203A35'):
    box=slide.shapes.add_textbox(Inches(x),Inches(y),Inches(w),Inches(h))
    tf=box.text_frame;tf.word_wrap=True
    tf.margin_left=0;tf.margin_right=0;tf.margin_top=0;tf.margin_bottom=0
    for i,line in enumerate(text.split('\n')):
        p=tf.paragraphs[0] if i==0 else tf.add_paragraph();p.text=line
        p.font.name='Arial';p.font.size=Pt(size);p.font.bold=bold;p.font.color.rgb=RGBColor.from_string(color)
        if 'GitHub:' in line and p.runs:p.runs[0].hyperlink.address=repo
    return box
for i,data in enumerate(slides,1):
    slide=prs.slides.add_slide(prs.slide_layouts[6])
    slide.background.fill.solid();slide.background.fill.fore_color.rgb=RGBColor.from_string('F5F8F6')
    textbox(slide,.55,.3,12.1,.75,data['title'],30,True,'247568')
    textbox(slide,.55,7.03,12,.25,f'NHÓM 18 · HỒ VĂN HOÀI ANH · 24106659                                      {i}/{len(slides)}',10,False,'247568')
    pc.setFillColor(colors.HexColor('#F5F8F6'));pc.rect(0,0,960,540,fill=1,stroke=0)
    pc.setFillColor(colors.HexColor(TEAL));pc.setFont('ArialBold',28);pc.drawString(40,490,data['title'])
    y=1.3
    if data.get('subtitle'):
        textbox(slide,.6,y,7.0,.55,data['subtitle'],20,True)
        pc.setFillColor(colors.HexColor('#203A35'));pc.setFont('ArialBold',18)
        pc.drawString(43,540-y*72-20,data['subtitle'])
        y+=.7
    py=540-y*72
    for bullet in data['bullets']:
        # Layout measured with reportlab, then same line breaks placed in editable PPTX.
        words=bullet.split();lines=[];line=''
        for word in words:
            candidate=(line+' '+word).strip()
            if pdfmetrics.stringWidth(candidate,'Arial',18)>475 and line:
                lines.append(line);line=word
            else:line=candidate
        if line:lines.append(line)
        text='• '+('\n  '.join(lines))
        height=(len(lines)*24+14)/72
        textbox(slide,.65,y,6.9,height,text,18)
        pc.setFillColor(colors.HexColor('#203A35'));pc.setFont('Arial',18)
        for j,line in enumerate(lines):pc.drawString(46,py-18-j*24,('• ' if j==0 else '  ')+line)
        if 'GitHub:' in bullet:pc.linkURL(repo,(46,py-len(lines)*24,520,py),relative=0)
        y+=height+.08;py=540-y*72
    image=ROOT/'docs/screenshots'/data['image']
    w,h=PILImage.open(image).size
    scale=min(4.8/w,5.35/h)
    iw,ih=w*scale,h*scale
    x=8.0+(4.8-iw)/2;top=1.3
    slide.shapes.add_picture(str(image),Inches(x),Inches(top),width=Inches(iw),height=Inches(ih))
    pc.drawImage(str(image),x*72,540-(top+ih)*72,width=iw*72,height=ih*72)
    textbox(slide,8,6.65,4.8,.3,'Ảnh ứng dụng web chạy thật · Chrome',10,False,'247568')
    pc.setFont('Arial',9);pc.setFillColor(colors.HexColor(TEAL));pc.drawString(576,40,'Ảnh ứng dụng web chạy thật · Chrome')
    pc.drawString(40,18,'NHÓM 18 · HỒ VĂN HOÀI ANH · 24106659');pc.drawRightString(920,18,f'{i}/{len(slides)}')
    pc.showPage()
prs.save(ROOT/'docs/slides/Nhip_Song_Thuyet_Trinh.pptx');pc.save()
print('Created report DOCX/PDF and',len(slides),'editable slides + PDF. No diagrams generated.')
