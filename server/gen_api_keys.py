import time
from types import NoneType
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
#  for browser_type in [p.chromium, p.firefox]:
    browser_type = p.chromium
#  for browser_type in [p.chromium, p.firefox]:
    browser = browser_type.launch()
    page = browser.new_page()
    page.goto('http://localhost/login')
    time.sleep(2)
    print("Logged in ...")
    page.screenshot(path=f'login-{browser_type.name}.png')
    page.goto("http://localhost/api_keys")
    # get_started = page.locator("text=Manage API keys")
    time.sleep(1)
    try:
      tour_pop_check = page.locator.evaluate_handle("#dont-notify", timeout=2)
      if tour_pop_check != None and tour_pop_check != NoneType:
        tour_pop_check.hover()
        tour_pop_check.click()
        time.sleep(1)
        tour_close = page.locator(".shepherd-cancel-icon")
        tour_close.click()
    except:
      print("Tour popup not found")
    print("Navigate to api_keys page ...")
    page.screenshot(path=f'api01-{browser_type.name}.png', full_page=True)
    # Expects the URL to contain intro.
    # expect(page).to_have_url(re.compile(".*login"))
    chkbox = page.locator("#expiration")
    # expect(chkbox).to_have_attribute("type", "checkbox")
    chkbox.hover()
    chkbox.click()
    time.sleep(1)
    submit = page.locator("text=Create")
    # expect(submit).to_have_attribute("type", "submit")
    submit.hover()
    submit.click()
    time.sleep(1)
    print("Keys generated!")
    page.screenshot(path=f'api02-{browser_type.name}.png', full_page=True)
#    page.locator("#api-keys-tbody").screenshot(path="api_keys.png")
    page.locator("#api-keys-tbody").screenshot(path=f'api_keys-{browser_type.name}.png')
    page.emulate_media(media="screen")
    page.pdf(path=f'api-keys-{browser_type.name}.pdf', landscape=True)
    browser.close()
