#Bootcamp Example 3: IE, Classic Watir, Excel data repository, Project library
require 'bootcamp_library_1'

$watir_script = true

class Bootcamp3IeCw
  include BootcampLibrary1
  extend BootcampLibrary1

  $xls_path = "bootcamp_data.xls"
  $my_name   = File.basename($0, ".rb")

  def run_test(browser)
    acct_name = "Acct #{@timestamp}" # DRY: avoid literals

    navigate_to_accounts_in_crm(browser)
    open_new_account(browser, acct_name)
    edit_account(browser, acct_name)
    browser.button(:value, 'Save').click
    sleep(2)
    verify_account_saved(browser, acct_name)
    delete_account(browser, acct_name)
# verify the account is gone
    puts !browser.text.include?(acct_name)
    sleep(2)
  end

  def navigate_to_accounts_in_crm(browser)
    browser.link(:title, 'CRM Software').click
    sleep(2)
    browser.link(:id, 'tab_Accounts').click
    sleep(2)
  end

  def open_new_account(browser, acct_name)
    browser.button(:value, 'New Account').click
    sleep(2)
    browser.text_field(:name, /Account Name/).set(acct_name)
  end

  def edit_account(browser, acct_name)

    browser.text_field(:id, 'property(Phone)').set(@var['account_phone'])
    browser.select_list(:name, 'property(Account Type)').select(@var['account_type'])
    browser.select_list(:name, 'property(Industry)').select(@var['account_industry'])
    browser.text_field(:id, 'property(Billing Street)').set(@var['account_billing_street'])
    browser.text_field(:id, 'property(Billing City)').set(@var['account_billing_city'])
    browser.text_field(:id, 'property(Billing State)').set(@var['account_billing_state'])
    browser.text_field(:id, 'property(Billing Code)').set(@var['account_billing_zipcode'].to_i.to_s)
    browser.text_field(:id, 'property(Billing Country)').set(@var['account_billing_country'])

    browser.button(:id, 'copyAddress'). click
    sleep(1)
    browser.element(:text, 'Billing to Shipping').click

    puts browser.text_field(:id, 'property(Shipping Street)').value == @var['account_billing_street']
    puts browser.text_field(:id, 'property(Shipping City)').value == @var['account_billing_city']
    puts browser.text_field(:id, 'property(Shipping State)').value == @var['account_billing_state']
    puts browser.text_field(:id, 'property(Shipping Code)').value == @var['account_billing_zipcode'].to_i.to_s
    puts browser.text_field(:id, 'property(Shipping Country)').value == @var['account_billing_country']

  end

  def delete_account(browser, acct_name)
    browser.link(:text, acct_name).click
    sleep(2)
    browser.button(:name, 'Delete2').click
    close_alert(browser, "Message from webpage", "OK")
  end

  def verify_account_saved(browser, acct_name)
    puts browser.span(:id, 'value_Account Name').text == acct_name
    sleep(2)
    browser.link(:id, 'tab_Accounts').click
    sleep(2)
    puts browser.text.include?(acct_name)
    sleep(2)
  end

end

Bootcamp3Cw.new.run
