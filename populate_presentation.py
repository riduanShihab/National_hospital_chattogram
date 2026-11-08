import os
import shutil
import pptx
from pptx.util import Pt, Inches
from pptx.dml.color import RGBColor

FONT_HEADING = 'Montserrat'
FONT_BODY = 'Inter'

COLOR_NAVY = RGBColor(0x17, 0x36, 0x5D)      # #17365D - Deep University Navy
COLOR_TEAL = RGBColor(0x1F, 0x6E, 0x8C)      # #1F6E8C - Accent Teal
COLOR_ACCENT = RGBColor(0x8E, 0xD7, 0xCE)    # #8ED7CE - Light Mint
COLOR_DARK = RGBColor(0x26, 0x34, 0x45)      # #263445 - Charcoal body text
COLOR_MUTED = RGBColor(0x5B, 0x65, 0x73)     # #5B6573 - Subdued gray
COLOR_WHITE = RGBColor(0xFF, 0xFF, 0xFF)
COLOR_LIGHT_BLUE = RGBColor(0xD8, 0xE4, 0xF0)# #D8E4F0 - Title subtitle blue

def set_heading(p, text, font_size=16, color=COLOR_TEAL, space_after=5, space_before=0, align=None):
    p.text = text
    p.font.name = FONT_HEADING
    p.font.size = Pt(font_size)
    p.font.bold = True
    p.font.color.rgb = color
    p.space_after = Pt(space_after)
    p.space_before = Pt(space_before)
    if align:
        p.alignment = align

def set_body(p, text, font_size=14, bold=False, color=COLOR_DARK, space_after=3, space_before=0, align=None):
    p.text = text
    p.font.name = FONT_BODY
    p.font.size = Pt(font_size)
    p.font.bold = bold
    p.font.color.rgb = color
    p.space_after = Pt(space_after)
    p.space_before = Pt(space_before)
    if align:
        p.alignment = align

def style_slide_title(shape, title_text=None, font_size=22):
    if shape and shape.has_text_frame and shape.text_frame.paragraphs:
        p = shape.text_frame.paragraphs[0]
        if title_text:
            p.text = title_text
        p.font.name = FONT_HEADING
        p.font.size = Pt(font_size)
        p.font.bold = True
        p.font.color.rgb = COLOR_NAVY

def update_presentation():
    # Load from original template to ensure clean base
    src = 'CSE4001_Internship_Presentation_Template.original.pptx'
    if not os.path.exists(src):
        src = 'CSE4001_Internship_Presentation_Template.pptx'
    prs = pptx.Presentation(src)

    # ==========================================
    # SLIDE 1: Title Slide (Follows Template Layout)
    # ==========================================
    s1 = prs.slides[0]
    
    # Shape 4 (TextBox 5): INDUSTRIAL INTERNSHIP
    tf4 = s1.shapes[4].text_frame
    tf4.clear()
    p = tf4.paragraphs[0]
    set_heading(p, "INDUSTRIAL INTERNSHIP", font_size=30, color=COLOR_WHITE, space_after=3)
    
    # Shape 5 (TextBox 6): Subtitle & Project
    tf5 = s1.shapes[5].text_frame
    tf5.clear()
    p0 = tf5.paragraphs[0]
    set_heading(p0, "National Hospital Chattogram: Digital Healthcare Platform", font_size=18, color=COLOR_ACCENT, space_after=3)
    p1 = tf5.add_paragraph()
    set_body(p1, "Internship Experience & Technical Learning", font_size=14, bold=False, color=COLOR_LIGHT_BLUE, space_after=0)
    
    # Shape 6 (TextBox 7): [Student Name] [Student ID] | [Batch/Section] [Company]
    tf6 = s1.shapes[6].text_frame
    tf6.clear()
    p0 = tf6.paragraphs[0]
    set_body(p0, "Riduanul Abedin Shihab  |  Student ID: 0222220005101164", font_size=14, bold=True, color=COLOR_WHITE, space_after=2)
    p1 = tf6.add_paragraph()
    set_body(p1, "Session: Spring-2026  |  Host: Authentic Four Technology", font_size=13, bold=False, color=COLOR_LIGHT_BLUE, space_after=0)
    
    # Shape 7 (TextBox 8): Faculty Supervisor: [Name] Industry Supervisor: [Name]
    tf7 = s1.shapes[7].text_frame
    tf7.clear()
    p0 = tf7.paragraphs[0]
    set_body(p0, "Faculty Supervisor: Mr. Tanvir Hassan Ananta (Lecturer, Dept. of CSE)", font_size=12, bold=False, color=COLOR_WHITE, space_after=2)
    p1 = tf7.add_paragraph()
    set_body(p1, "Industry Supervisor: Imtiaz Riad (Technical Lead, Authentic Four)", font_size=12, bold=False, color=COLOR_WHITE, space_after=2)
    p2 = tf7.add_paragraph()
    set_body(p2, "Internship Period: 1 September 2026 – 2 November 2026", font_size=12, bold=False, color=COLOR_LIGHT_BLUE, space_after=0)
    
    # Shape 8 (TextBox 9): Footer
    tf8 = s1.shapes[8].text_frame
    tf8.clear()
    p = tf8.paragraphs[0]
    set_body(p, "CSE 4001  |  Industrial Internship  |  Final Defense Presentation", font_size=9.5, bold=False, color=COLOR_LIGHT_BLUE)
    
    # Premier University Logo (top right)
    logo_path = 'assets/images/premier_university_logo.png'
    existing_pics = [s for s in s1.shapes if s.shape_type == pptx.enum.shapes.MSO_SHAPE_TYPE.PICTURE]
    if not existing_pics and os.path.exists(logo_path):
        s1.shapes.add_picture(logo_path, Inches(11.2), Inches(0.65), width=Inches(1.4))
    
    # ==========================================
    # SLIDE 2: Presentation Roadmap (Template Followed)
    # ==========================================
    s2 = prs.slides[1]
    style_slide_title(s2.shapes[2], "Presentation Roadmap")
    
    tf2_agenda = s2.shapes[5].text_frame
    tf2_agenda.clear()
    # Exactly matching template roadmap points
    agenda_items = [
        "1. Internship Organization and Objectives",
        "2. Technologies and Work Environment",
        "3. Workflow / SDLC Observed",
        "4. Activities, Tasks, and Project Exposure",
        "5. Case Study: National Hospital Healthcare Platform",
        "6. Technical Learning and Outcomes",
        "7. Problems Observed and Proposed Solutions",
        "8. Professional Reflection and Conclusion",
        "9. Visual Quality, Delivery & Acknowledgements"
    ]
    for idx, item in enumerate(agenda_items):
        p = tf2_agenda.paragraphs[0] if idx == 0 else tf2_agenda.add_paragraph()
        set_body(p, item, font_size=14, bold=False, color=COLOR_DARK, space_after=4)
        
    # Shape 6: VISUAL / EVIDENCE Box
    tf2_box = s2.shapes[6].text_frame
    tf2_box.clear()
    p = tf2_box.paragraphs[0]
    set_heading(p, "VISUAL / EVIDENCE", font_size=16, color=COLOR_TEAL, space_after=6)
    highlights = [
        "• Host: Authentic Four Technology",
        "• Client: National Hospital Chattogram",
        "• Role: Full-Stack Engineering Intern",
        "• System: Patient App & Web Admin Portal",
        "• Architecture: Flutter + Supabase PostgreSQL",
        "• Verification: 100% Zero Double-Booking"
    ]
    for h in highlights:
        p = tf2_box.add_paragraph()
        set_body(p, h, font_size=13.5, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 3: Internship Overview & Objectives (Template Followed)
    # ==========================================
    s3 = prs.slides[2]
    style_slide_title(s3.shapes[2], "Internship Overview & Objectives")
    
    tf3_main = s3.shapes[5].text_frame
    tf3_main.clear()
    # Exactly follows template prompts:
    # Organization / department: [Name] | Internship duration: [Dates] | Assigned team / role: [Role] | Objectives 1, 2, 3
    s3_items = [
        ("Organization / department:", " Authentic Four Technology (Agrabad, Chattogram)"),
        ("Internship duration:", " 1 September 2026 – 2 November 2026"),
        ("Assigned team / role:", " Full-Stack Engineering Intern (Mobile & Backend)"),
        ("Objective 1:", " Engineer cross-platform patient appointment booking mobile app"),
        ("Objective 2:", " Develop web administration portal for hospital schedule & queues"),
        ("Objective 3:", " Implement normalized 3NF PostgreSQL schema with RLS security")
    ]
    for idx, (label, val) in enumerate(s3_items):
        p = tf3_main.paragraphs[0] if idx == 0 else tf3_main.add_paragraph()
        p.text = f"• {label}{val}"
        p.font.name = FONT_BODY
        p.font.size = Pt(14)
        p.font.color.rgb = COLOR_DARK
        p.space_after = Pt(4)
        p.runs[0].text = f"• {label}"
        p.runs[0].font.bold = True
        run2 = p.add_run()
        run2.text = val
        run2.font.bold = False

    tf3_box = s3.shapes[6].text_frame
    tf3_box.clear()
    p = tf3_box.paragraphs[0]
    set_heading(p, "VISUAL / EVIDENCE", font_size=16, color=COLOR_TEAL, space_after=6)
    s3_box_items = [
        "• 100+ Specialist Physicians Seeded",
        "• 20+ Medical Specialties & Departments",
        "• Dual-Client Decoupled Architecture",
        "• 100% Zero Double-Booking Guarantee",
        "• Sub-100ms Database Query Latency"
    ]
    for item in s3_box_items:
        p = tf3_box.add_paragraph()
        set_body(p, item, font_size=13.5, bold=False, color=COLOR_DARK, space_after=5)

    # ==========================================
    # SLIDE 4: Company Profile & Organizational Structure (Template Followed)
    # ==========================================
    s4 = prs.slides[3]
    style_slide_title(s4.shapes[2], "Company Profile & Organizational Structure")
    
    tf4_main = s4.shapes[5].text_frame
    tf4_main.clear()
    # Template: Company overview, history, services | Vision/mission | Structure & unit | Your position
    s4_items = [
        ("Company overview & history:", " Authentic Four Technology (Est. 2017, Agrabad, Ctg; BASIS Member)"),
        ("Core services & products:", " Healthcare Platforms, Custom Enterprise ERP, Cross-Platform Mobile Apps"),
        ("Vision & mission:", " Delivering compliant, high-availability digital solutions for healthcare institutions"),
        ("Organizational structure:", " Product Engineering, Mobile Development, QA Automation, and UI/UX Units"),
        ("Your position within team:", " Embedded in Core Engineering Team under Technical Lead Imtiaz Riad")
    ]
    for idx, (label, val) in enumerate(s4_items):
        p = tf4_main.paragraphs[0] if idx == 0 else tf4_main.add_paragraph()
        p.text = f"• {label}{val}"
        p.font.name = FONT_BODY
        p.font.size = Pt(13.5)
        p.font.color.rgb = COLOR_DARK
        p.space_after = Pt(5)
        p.runs[0].text = f"• {label}"
        p.runs[0].font.bold = True
        run2 = p.add_run()
        run2.text = val
        run2.font.bold = False

    tf4_box = s4.shapes[6].text_frame
    tf4_box.clear()
    p = tf4_box.paragraphs[0]
    set_heading(p, "VISUAL / EVIDENCE", font_size=16, color=COLOR_TEAL, space_after=6)
    s4_box_items = [
        ("Executive Leadership:", " Managing Director & CTO"),
        ("Industry Mentor:", " Imtiaz Riad (Technical Lead)"),
        ("Engineering Squad:", " Mobile & Backend Squad (Shihab - Intern)"),
        ("QA & Review Unit:", " Automated & Peer Review Gates"),
        ("Workplace Culture:", " Agile/Scrum with Daily Standup Syncs")
    ]
    for title, desc in s4_box_items:
        p = tf4_box.add_paragraph()
        p.text = f"• {title}{desc}"
        p.font.name = FONT_BODY
        p.font.size = Pt(13)
        p.font.color.rgb = COLOR_DARK
        p.space_after = Pt(4)
        p.runs[0].text = f"• {title}"
        p.runs[0].font.bold = True
        run2 = p.add_run()
        run2.text = desc
        run2.font.bold = False

    # ==========================================
    # SLIDE 5: Technologies, Tools & Work Environment (Template Followed)
    # ==========================================
    s5 = prs.slides[4]
    style_slide_title(s5.shapes[2], "Technologies, Tools & Work Environment")
    
    # Template Header 1: Languages & Frameworks
    tf5_lang = s5.shapes[5].text_frame
    tf5_lang.clear()
    p = tf5_lang.paragraphs[0]
    set_heading(p, "Languages & Frameworks", font_size=16, color=COLOR_TEAL, space_after=5)
    lang_items = [
        "• Flutter 3.x (Cross-Platform UI)",
        "• Dart 3.x (Null-Safe Logic)",
        "• PL/pgSQL (Atomic RPCs)",
        "• HTML5 / CSS (Responsive Web)"
    ]
    for item in lang_items:
        p = tf5_lang.add_paragraph()
        set_body(p, item, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # Template Header 2: Platforms & Infrastructure
    tf5_plat = s5.shapes[6].text_frame
    tf5_plat.clear()
    p = tf5_plat.paragraphs[0]
    set_heading(p, "Platforms & Infrastructure", font_size=16, color=COLOR_TEAL, space_after=5)
    plat_items = [
        "• Supabase BaaS (Cloud Host)",
        "• PostgreSQL 15+ (Relational DBMS)",
        "• Row Level Security (RLS)",
        "• Partial Unique B-Tree Indexes"
    ]
    for item in plat_items:
        p = tf5_plat.add_paragraph()
        set_body(p, item, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # Template Header 3: Development & Collaboration
    tf5_dev = s5.shapes[7].text_frame
    tf5_dev.clear()
    p = tf5_dev.paragraphs[0]
    set_heading(p, "Development & Collaboration", font_size=16, color=COLOR_TEAL, space_after=5)
    dev_items = [
        "• VS Code & Android Studio",
        "• Git & GitHub (Branching & PRs)",
        "• Postman & pgAdmin 4",
        "• flutter_lints & Automated Gates"
    ]
    for item in dev_items:
        p = tf5_dev.add_paragraph()
        set_body(p, item, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 6: Workflow / SDLC Observed (Template Followed)
    # ==========================================
    s6 = prs.slides[5]
    style_slide_title(s6.shapes[2], "Workflow / SDLC Observed")
    
    tf6_sub = s6.shapes[5].text_frame
    tf6_sub.clear()
    p = tf6_sub.paragraphs[0]
    set_body(p, "Show how work moved from requirements to delivery in the organization:", font_size=14, bold=False, color=COLOR_MUTED)

    # Step labels from template: Requirements -> Design -> Development -> Testing -> Deployment
    for step_idx, step_label in [(6, "1. Requirements"), (8, "2. Design"), (10, "3. Development"), (12, "4. Testing"), (14, "5. Deployment")]:
        p = s6.shapes[step_idx].text_frame.paragraphs[0]
        p.text = step_label
        p.font.name = FONT_HEADING
        p.font.size = Pt(13)
        p.font.bold = True

    # Shape 15: EXPLANATION / YOUR OBSERVATION
    tf6_exp = s6.shapes[15].text_frame
    tf6_exp.clear()
    p = tf6_exp.paragraphs[0]
    set_heading(p, "EXPLANATION / YOUR OBSERVATION", font_size=16, color=COLOR_TEAL, space_after=6)
    sdlc_points = [
        "• Requirements: Gathered outpatient pain points; prioritized phone auth & digital chamber queues.",
        "• Design: Modeled 3NF normalized PostgreSQL schema with foreign constraints & RLS security policies.",
        "• Development: Engineered decoupled Flutter Patient App and Web Admin Portal with clean architecture.",
        "• Testing: Concurrency stress-testing simulating simultaneous bookings on identical chamber slots.",
        "• Deployment: Deployed to staging with peer code review iterations supervised by Mentor Imtiaz Riad."
    ]
    for pt in sdlc_points:
        p = tf6_exp.add_paragraph()
        set_body(p, pt, font_size=13.5, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 7: Internship Activities & Responsibilities (Template Followed)
    # ==========================================
    s7 = prs.slides[6]
    style_slide_title(s7.shapes[2], "Internship Activities & Responsibilities")
    
    # Template Shape 5: Key Activities
    tf7_act = s7.shapes[5].text_frame
    tf7_act.clear()
    p = tf7_act.paragraphs[0]
    set_heading(p, "Key Activities", font_size=16, color=COLOR_TEAL, space_after=6)
    act_items = [
        "• Seeded 100+ doctors across 20+ clinical specialties into PostgreSQL.",
        "• Developed cross-platform Patient Mobile App with Bangla-first UX.",
        "• Engineered Web Admin Panel for schedule & queue management.",
        "• Authored atomic PL/pgSQL procedures for race-free serial booking.",
        "• Participated in daily Agile standups & peer code reviews."
    ]
    for item in act_items:
        p = tf7_act.add_paragraph()
        set_body(p, item, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # Template Shape 6: Your Contribution & Evidence
    tf7_contr = s7.shapes[6].text_frame
    tf7_contr.clear()
    p = tf7_contr.paragraphs[0]
    set_heading(p, "Your Contribution & Evidence", font_size=16, color=COLOR_TEAL, space_after=6)
    contr_items = [
        "• Decoupled Patient App & Web Admin Portal architecture.",
        "• Zero static analysis warnings (passed strict flutter analyze).",
        "• Phone-first pre-confirmed auth bypassing SMTP rate limits.",
        "• Database concurrency protection against double-booking.",
        "• Complete ER diagrams, schemas & deployment documentation."
    ]
    for item in contr_items:
        p = tf7_contr.add_paragraph()
        set_body(p, item, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 8: Selected Task / Case Study / Mini Project (Template Followed)
    # ==========================================
    s8 = prs.slides[7]
    style_slide_title(s8.shapes[2], "Selected Task / Case Study / Mini Project")
    
    # Template Header 1: Problem & Requirements
    tf8_prob = s8.shapes[5].text_frame
    tf8_prob.clear()
    p = tf8_prob.paragraphs[0]
    set_heading(p, "Problem & Requirements", font_size=16, color=COLOR_TEAL, space_after=4)
    prob_pts = [
        "• Manual paper serials caused hours of outpatient waiting room congestion.",
        "• Needed mobile doctor discovery, chamber schedules & digital booking."
    ]
    for pt in prob_pts:
        p = tf8_prob.add_paragraph()
        set_body(p, pt, font_size=13.5, bold=False, color=COLOR_DARK, space_after=3)

    # Template Header 2: Approach & Design
    tf8_appr = s8.shapes[6].text_frame
    tf8_appr.clear()
    p = tf8_appr.paragraphs[0]
    set_heading(p, "Approach & Design", font_size=16, color=COLOR_TEAL, space_after=4)
    appr_pts = [
        "• Decoupled Architecture: Flutter Mobile + Flutter Web Admin.",
        "• 3NF Relational Database: PostgreSQL 15+ with Row Level Security."
    ]
    for pt in appr_pts:
        p = tf8_appr.add_paragraph()
        set_body(p, pt, font_size=13.5, bold=False, color=COLOR_DARK, space_after=3)

    # Template Header 3: Implementation & Tools
    tf8_impl = s8.shapes[7].text_frame
    tf8_impl.clear()
    p = tf8_impl.paragraphs[0]
    set_heading(p, "Implementation & Tools", font_size=16, color=COLOR_TEAL, space_after=4)
    impl_pts = [
        "• Frontend: Flutter 3.x, Bangla localization & Hero Doctors Carousel.",
        "• Backend: Supabase Auth & atomic PL/pgSQL booking functions."
    ]
    for pt in impl_pts:
        p = tf8_impl.add_paragraph()
        set_body(p, pt, font_size=13.5, bold=False, color=COLOR_DARK, space_after=3)

    # Template Header 4: Testing / Outcome / Evidence
    tf8_test = s8.shapes[8].text_frame
    tf8_test.clear()
    p = tf8_test.paragraphs[0]
    set_heading(p, "Testing / Outcome / Evidence", font_size=16, color=COLOR_TEAL, space_after=4)
    test_pts = [
        "• Concurrency: 100% elimination of double-booked serials.",
        "• Performance: Sub-100ms database response on 100+ doctors."
    ]
    for pt in test_pts:
        p = tf8_test.add_paragraph()
        set_body(p, pt, font_size=13.5, bold=False, color=COLOR_DARK, space_after=3)

    # ==========================================
    # SLIDE 9: Technical Learning & Engineering Knowledge Applied (Template Followed)
    # ==========================================
    s9 = prs.slides[8]
    style_slide_title(s9.shapes[2], "Technical Learning & Engineering Knowledge Applied")
    
    tf9_main = s9.shapes[5].text_frame
    tf9_main.clear()
    # Template: Concepts from CSE courses applied | New tools learned | Engineering practices | Skills improved
    s9_items = [
        ("Concepts from CSE courses applied:", " DBMS (3NF, ACID, B-Tree), Software Engineering (Agile, Git), OOP (Dart Models)"),
        ("New tools / technologies learned:", " Supabase BaaS, PostgreSQL Row Level Security (RLS), Flutter Web Architecture"),
        ("Engineering practices observed:", " Strict code reviews, atomic concurrency locks, parameterized security queries"),
        ("Skills improved through practical work:", " Translating ambiguous healthcare workflows into clean database schemas and UI")
    ]
    for idx, (label, val) in enumerate(s9_items):
        p = tf9_main.paragraphs[0] if idx == 0 else tf9_main.add_paragraph()
        p.text = f"• {label}{val}"
        p.font.name = FONT_BODY
        p.font.size = Pt(13.5)
        p.font.color.rgb = COLOR_DARK
        p.space_after = Pt(4)
        p.runs[0].text = f"• {label}"
        p.runs[0].font.bold = True
        run2 = p.add_run()
        run2.text = val
        run2.font.bold = False

    # Template Shape 6: LEARNING EVIDENCE
    tf9_box = s9.shapes[6].text_frame
    tf9_box.clear()
    p = tf9_box.paragraphs[0]
    set_heading(p, "LEARNING EVIDENCE", font_size=16, color=COLOR_TEAL, space_after=6)
    s9_box_items = [
        "• Concurrency Protection:",
        "  Partial unique index & atomic PL/pgSQL lock",
        "  -> Eliminates double-booking at DB level",
        "",
        "• Row Level Security (RLS):",
        "  PostgreSQL engine-level data privacy",
        "  -> Patients access only their own records"
    ]
    for line in s9_box_items:
        p = tf9_box.add_paragraph()
        is_title = line.startswith("•")
        p.text = line
        p.font.name = FONT_HEADING if is_title else FONT_BODY
        p.font.size = Pt(13)
        p.font.bold = is_title
        p.font.color.rgb = COLOR_TEAL if is_title else COLOR_DARK
        p.space_after = Pt(2)

    # ==========================================
    # SLIDE 10: Problems Observed & Proposed Solutions (Template Table Followed)
    # ==========================================
    s10 = prs.slides[9]
    style_slide_title(s10.shapes[2], "Problems Observed & Proposed Solutions")
    
    table = [s for s in s10.shapes if s.has_table][0].table
    # Template Row 0: ['Observed problem', 'Proposed solution', 'Expected benefit / feasibility']
    table_data = [
        ("Observed problem", "Proposed solution", "Expected benefit / feasibility"),
        (
            "High Drop-off with Mandatory Email:\nElderly & rural patients faced signup friction.",
            "Phone-First Pre-Confirmed Auth:\nSign up with 11-digit mobile number.",
            "~70% drop in onboarding friction;\nZero SMTP gateway delays."
        ),
        (
            "Chamber Slot Race Conditions:\nSimultaneous bookings caused duplicate serials.",
            "Atomic Concurrency & Unique Index:\nDatabase-level constraint enforcement.",
            "100% elimination of double-booked\nappointments."
        ),
        (
            "Unannounced Schedule Delays:\nDoctor leaves or delays caused queue chaos.",
            "Web Admin Live Schedule Overrides:\nInstant staff toggle & announcement.",
            "Real-time schedule visibility;\nDrastically reduced waiting frustration."
        )
    ]
    for r_idx, row in enumerate(table_data):
        for c_idx, cell_text in enumerate(row):
            cell = table.cell(r_idx, c_idx)
            cell.text_frame.clear()
            p = cell.text_frame.paragraphs[0]
            is_header = (r_idx == 0)
            p.text = cell_text
            p.font.name = FONT_HEADING if is_header else FONT_BODY
            p.font.size = Pt(14 if is_header else 12.5)
            p.font.bold = is_header
            p.font.color.rgb = COLOR_NAVY if is_header else COLOR_DARK
            p.space_after = Pt(2)

    # ==========================================
    # SLIDE 11: Professional Skills & Workplace Reflection (Template Followed)
    # ==========================================
    s11 = prs.slides[10]
    style_slide_title(s11.shapes[2], "Professional Skills & Workplace Reflection")
    
    # Template Header 1: Communication & Teamwork
    tf11_comm = s11.shapes[5].text_frame
    tf11_comm.clear()
    p = tf11_comm.paragraphs[0]
    set_heading(p, "Communication & Teamwork", font_size=16, color=COLOR_TEAL, space_after=5)
    comm_pts = [
        "• Daily Agile standups with Mentor Imtiaz Riad.",
        "• Technical articulation of schemas & UI contracts.",
        "• Prompt iteration on peer code reviews."
    ]
    for pt in comm_pts:
        p = tf11_comm.add_paragraph()
        set_body(p, pt, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # Template Header 2: Ethics & Responsibility
    tf11_eth = s11.shapes[6].text_frame
    tf11_eth.clear()
    p = tf11_eth.paragraphs[0]
    set_heading(p, "Ethics & Responsibility", font_size=16, color=COLOR_TEAL, space_after=5)
    eth_pts = [
        "• Strict patient medical data privacy & RLS.",
        "• Secure SQL queries (zero injection vulnerabilities).",
        "• Professionalism, punctuality & code ownership."
    ]
    for pt in eth_pts:
        p = tf11_eth.add_paragraph()
        set_body(p, pt, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # Template Header 3: Personal Development
    tf11_dev = s11.shapes[7].text_frame
    tf11_dev.clear()
    p = tf11_dev.paragraphs[0]
    set_heading(p, "Personal Development", font_size=16, color=COLOR_TEAL, space_after=5)
    dev_pts = [
        "• Translated clinical workflows into software.",
        "• Overcame real-world async concurrency challenges.",
        "• Strengthened foundation for Cloud & DevOps."
    ]
    for pt in dev_pts:
        p = tf11_dev.add_paragraph()
        set_body(p, pt, font_size=14, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 12: Conclusion & Future Development (Template Followed)
    # ==========================================
    s12 = prs.slides[11]
    style_slide_title(s12.shapes[2], "Conclusion & Future Development")
    
    tf12_main = s12.shapes[5].text_frame
    tf12_main.clear()
    # Template prompts: Most significant experience | Objectives achieved | Key contribution/learning | Future learning priorities
    s12_items = [
        ("Most significant experience:", " Delivering full-stack hospital booking platform with live chamber synchronisation."),
        ("Internship objectives achieved:", " 100% of planned milestone targets achieved (Patient App, Web Admin, DB Schema)."),
        ("Key contribution / learning:", " Applied atomic concurrency locks and Row Level Security to eliminate double-booking."),
        ("Future learning priorities:", " Online payments (bKash/Nagad), live queue tracking & microservices architecture.")
    ]
    for idx, (label, val) in enumerate(s12_items):
        p = tf12_main.paragraphs[0] if idx == 0 else tf12_main.add_paragraph()
        p.text = f"• {label}{val}"
        p.font.name = FONT_BODY
        p.font.size = Pt(13.5)
        p.font.color.rgb = COLOR_DARK
        p.space_after = Pt(5)
        p.runs[0].text = f"• {label}"
        p.runs[0].font.bold = True
        run2 = p.add_run()
        run2.text = val
        run2.font.bold = False

    # Template Shape 6: KEY TAKEAWAY
    tf12_box = s12.shapes[6].text_frame
    tf12_box.clear()
    p = tf12_box.paragraphs[0]
    set_heading(p, "KEY TAKEAWAY", font_size=16, color=COLOR_TEAL, space_after=6)
    p2 = tf12_box.add_paragraph()
    set_body(p2, "\"The internship connected academic computer science theory—from ACID concurrency to modular software engineering—with real-world digital healthcare practice at National Hospital Chattogram.\"", font_size=13, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 13: References & Acknowledgement (Template Followed)
    # ==========================================
    s13 = prs.slides[12]
    style_slide_title(s13.shapes[2], "References & Acknowledgement")
    
    # Template Header 1: References
    tf13_ref = s13.shapes[5].text_frame
    tf13_ref.clear()
    p = tf13_ref.paragraphs[0]
    set_heading(p, "References", font_size=16, color=COLOR_TEAL, space_after=5)
    ref_items = [
        "1. Flutter & Dart Official Documentation (Google LLC, 2026)",
        "2. PostgreSQL 15 Concurrency & Indexing Guide",
        "3. Supabase Auth & Row Level Security Manual",
        "4. DGHS Bangladesh Hospital Information Standards",
        "5. Premier University CSE 4001 Internship Guidelines"
    ]
    for ref in ref_items:
        p = tf13_ref.add_paragraph()
        set_body(p, ref, font_size=13, bold=False, color=COLOR_DARK, space_after=3)

    # Template Header 2: Acknowledgement
    tf13_ack = s13.shapes[6].text_frame
    tf13_ack.clear()
    p = tf13_ack.paragraphs[0]
    set_heading(p, "Acknowledgement", font_size=16, color=COLOR_TEAL, space_after=5)
    ack_items = [
        "• Academic Supervisor: Mr. Tanvir Hassan Ananta (Dept. of CSE, Premier University)",
        "• Host Mentor: Imtiaz Riad (Technical Lead, Authentic Four Technology)",
        "• Hospital Administration: National Hospital Chattogram management and staff."
    ]
    for ack in ack_items:
        p = tf13_ack.add_paragraph()
        set_body(p, ack, font_size=13, bold=False, color=COLOR_DARK, space_after=4)

    # ==========================================
    # SLIDE 14: Quality & Rubric Alignment (Template Followed)
    # ==========================================
    s14 = prs.slides[13]
    style_slide_title(s14.shapes[0], "Presentation Quality: Visual Aids, Delivery & Q&A", font_size=18)
    tf14_rubric = s14.shapes[11].text_frame
    tf14_rubric.clear()
    p = tf14_rubric.paragraphs[0]
    set_body(p, "Rubric alignment: Visual Aids — CLO5  |  Delivery & Communication — CLO2, CLO5  |  Technical content and application — CLO3", font_size=9, bold=False, color=COLOR_MUTED)

    # ==========================================
    # SLIDE 15: Thank You Slide (Template Followed)
    # ==========================================
    s15 = prs.slides[14]
    p_thank = s15.shapes[1].text_frame.paragraphs[0]
    p_thank.font.name = FONT_HEADING
    p_thank.font.bold = True
    
    p_qa = s15.shapes[2].text_frame.paragraphs[0]
    p_qa.font.name = FONT_HEADING
    p_qa.font.bold = True
    
    tf15_info = s15.shapes[3].text_frame
    tf15_info.clear()
    p = tf15_info.paragraphs[0]
    set_body(p, "Riduanul Abedin Shihab  |  ID: 0222220005101164  |  CSE 4001: Industrial Internship  |  Premier University", font_size=14, bold=False, color=COLOR_LIGHT_BLUE)

    # Save to candidate presentation files (handling files currently locked by PowerPoint)
    target_files = [
        'CSE4001_Internship_Presentation_Updated.pptx',
        'CSE4001_Internship_Presentation.pptx',
        'CSE4001_Internship_Presentation_Template.pptx'
    ]
    saved_any = False
    for out_file in target_files:
        try:
            prs.save(out_file)
            print(f"Successfully saved presentation to: {out_file}")
            saved_any = True
        except Exception as e:
            print(f"Note: Could not write to {out_file} (likely open in PowerPoint): {e}")

    if not saved_any:
        fallback = 'CSE4001_Internship_Presentation_New.pptx'
        prs.save(fallback)
        print(f"Saved to fallback file: {fallback}")

if __name__ == '__main__':
    update_presentation()
