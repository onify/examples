# --- ARGS ---
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("-orgnr", help = "Company orgnr", required = True)
args = parser.parse_args()

# --- LIBS ---
from RPA.Browser.Selenium import Browser
lib = Browser()

# --- VARS ---
orgnr = args.orgnr
url = "https://www.allabolag.se"

# --- TASKS ---
lib.open_headless_chrome_browser(url) #lib.open_available_browser(url)
lib.input_text("name:what", orgnr)
lib.click_button("Sök")
ceo = lib.get_text('//*[@id="company-card_overview"]/div[3]/div[1]/dl/dd[1]/a')
phone = lib.get_text('//*[@id="company-card_overview"]/div[3]/div[2]/dl/dd[1]/a/span')
address = lib.get_text('//*[@id="company-card_overview"]/div[3]/div[2]/dl/dd[2]')
zip_city = lib.get_text('//*[@id="company-card_overview"]/div[3]/div[2]/dl/dd[3]')
lib.close_browser
print("CEO: " + ceo)
print("Phone: " + phone)
print("Address: " + address)
print("Zip & City: " + zip_city)
