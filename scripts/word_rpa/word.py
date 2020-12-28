# --- ARGS ---
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-orgnr", help = "Company orgnr", required = True)
parser.add_argument("-name", help = "Company name", required = True)
parser.add_argument("-ceo", help = "Company CEO", required = True)
args = parser.parse_args()

# --- LIBS ---
from RPA.Word.Application import Application

# --- VARS ---
orgnr = args.orgnr
name = args.name
ceo = args.ceo
input_filename = 'template.docx'
output_filename = '/temp/new.docx'

# --- TASKS ---
app = Application()
app.open_application(visible = False, display_alerts = True)
app.open_file(input_filename)
app.replace_text("$COMPANY_NAME$", name)
app.replace_text("$CEO$", ceo)
app.replace_text("$ORGNR$", orgnr)
app.save_document_as(output_filename)
app.quit_application()
