#Bootcamp Example 2: IE, Classic Watir, Excel data repository
require 'watir'
require 'win32ole'
@ai = ::WIN32OLE.new('AutoItX3.Control')
require 'pry'
require 'roo'

timestamp              = Time.now.strftime("%Y%m%d%H%M%S")
acct_name              = "Acct #{timestamp}" # DRY: avoid literals

workbook               = Excel.new("bootcamp_data.xls")

# load login information from spreadsheet
@login                 = Hash.new
workbook.default_sheet = workbook.sheets[0]

script_col   = 0
role_col     = 0
userid_col   = 0
password_col = 0
url_col      = 0
name_col     = 0

1.upto(workbook.last_column) do |col|
  header = workbook.cell(1, col)
  case header
    when File.basename($0, ".rb")
      script_col = col
    when 'role'
      role_col = col
    when 'userid'
      userid_col = col
    when 'password'
      password_col = col
    when 'url'
      url_col = col
    when 'name'
      name_col = col
  end
end

2.upto(workbook.last_row) do |line|
  role     = workbook.cell(line, role_col)
  userid   = workbook.cell(line, userid_col)
  password = workbook.cell(line, password_col)
  url      = workbook.cell(line, url_col)
  username = workbook.cell(line, name_col)
  enabled  = workbook.cell(line, script_col).to_s

  if enabled == 'Y'
    @login['role']     = role
    @login['userid']   = userid
    @login['password'] = password
    @login['url']      = url
    @login['name']     = username
    @login['enabled']  = enabled
    break
  end
end

# load variables from data spreadsheet
@var                   = Hash.new
workbook.default_sheet = workbook.sheets[1]
script_col                = 0
name_col    = 0

1.upto(workbook.last_column) do |col|
  header = workbook.cell(1, col)
  case header
    when File.basename($0, ".rb")
      script_col = col
    when 'Variable'
      name_col = col
  end
end

2.upto(workbook.last_row) do |line|
  name       = workbook.cell(line, name_col)
  value      = workbook.cell(line, script_col).to_s.strip
  @var[name] = value
end

# open the browser
browser = Watir::Browser.new
browser.goto(@login['url'])
sleep(2)

# log in
browser.text_field(:name, 'lid').set(@login['userid'])
browser.text_field(:name, 'pwd').set(@login['password'])
browser.button(:value, 'Sign In').click
sleep(2)

# navigate to Accounts in CRM Software
browser.link(:title, 'CRM Software').click
sleep(2)
browser.link(:id, 'tab_Accounts').click
sleep(2)

# add new account
browser.button(:value, 'New Account').click
sleep(2)
browser.text_field(:name, /Account Name/).set(acct_name)

# add data to the new account

# save the new account
browser.button(:value, 'Save').click
sleep(2)

# verify saved account
browser.span(:id, 'value_Account Name').text == acct_name
sleep(2)
browser.link(:id, 'tab_Accounts').click
sleep(2)
puts browser.text.include?(acct_name)
sleep(2)

# delete the account
browser.link(:text, acct_name).click
sleep(2)
browser.button(:name, 'Delete2').click
@ai.WinWait("Message from webpage")
sleep(2)
@ai.ControlClick("Message from webpage", "", "OK")
sleep(2)

# verify the account is gone
puts browser.text.include?(acct_name)
sleep(2)

# sign out and close browser
browser.image(:class, 'sort_desc').click
sleep(1)
browser.button(:value, 'Sign Out').click
sleep(4)
browser.close
