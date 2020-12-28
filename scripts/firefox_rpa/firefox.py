# --- LIBS ---
from RPA.Desktop.Windows import Windows
win = Windows()

# --- TASKS ---
win.open_from_search("firefox", "Mozilla Firefox")
win.send_keys_to_input("https://www.google.com")
win.send_keys_to_input("RPA{SPACE}is{SPACE}cool")
win.screenshot("desktop.png", desktop=True, overwrite=True)
#win.close_all_applications



