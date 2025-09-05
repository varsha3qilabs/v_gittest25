import re
from playwright.sync_api import Page, expect
from project_assets import awetest

def test_example(page: Page) -> None:
    url = awetest.get_env_url()
    page.goto(url)
    expect(page.get_by_role("link", name="ATMs/Locations")).to_be_visible()
    page.get_by_role("link", name="ATMs/Locations").click()
    page.get_by_text("Enter an address, landmark,").click()
    page.get_by_label("Enter an address, landmark,").fill("10001")
    page.get_by_label("Enter an address, landmark,").press("Enter")
    expect(page.get_by_text("PENN STATION MAIN LOBBY-")).to_be_visible()
