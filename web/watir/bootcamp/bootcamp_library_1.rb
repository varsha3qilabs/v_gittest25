module BootcampLibrary1

  def run
    do_requires
    @timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    load_data_spreadsheet($xls_path)
    browser = open_the_browser_to_url
    sleep(2)
    log_in(browser)
    run_test(browser)
    sign_out_and_close(browser)
  end

  def do_requires
    require 'rubygems'
    require 'pry'
    require 'roo'
    if $watir_script
      require 'watir'
      require 'win32ole'
      $ai = ::WIN32OLE.new('AutoItX3.Control')
    else
      require 'watir-webdriver'
    end
  end

  def log_in(browser)
    browser.text_field(:name, 'lid').set(@login['userid'])
    browser.text_field(:name, 'pwd').set(@login['password'])
    browser.button(:value, 'Sign In').click
    sleep(2)
  end

  def sign_out_and_close(browser)
    browser.image(:class, 'sort_desc').click
    sleep(1)
    browser.button(:value, 'Sign Out').click
    sleep(4)
    browser.close
  end

  def open_the_browser_to_url
    if $watir_script
      browser = Watir::Browser.new
    else
      browser = Watir::Browser.new $browser_sym
    end
    browser.goto(@login['url'])
    browser
  end

  def load_data_spreadsheet(file)
    workbook               = Excel.new(file)
    @login = load_login_data(workbook)
    @var   = load_variable_data(workbook)
  end

  def load_variable_data(workbook)
    hash                   = Hash.new
    workbook.default_sheet = workbook.sheets[1]
    script_col             = 0
    name_col               = 0

    1.upto(workbook.last_column) do |col|
      header = workbook.cell(1, col)
      case header
        when $my_name
          script_col = col
        when 'Variable'
          name_col = col
      end
    end

    2.upto(workbook.last_row) do |line|
      name       = workbook.cell(line, name_col)
      value      = workbook.cell(line, script_col).to_s.strip
      hash[name] = value
    end

    hash
  end

  def load_login_data(workbook)
    hash                 = Hash.new
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
        when $my_name
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
        hash['role']     = role
        hash['userid']   = userid
        hash['password'] = password
        hash['url']      = url
        hash['name']     = username
        hash['enabled']  = enabled
        break
      end
    end

    hash
  end

  def close_alert(browser, title, button)
    if $watir_script
      $ai.WinWait(title)
      sleep(2)
      $ai.ControlClick(title, "", button)
      sleep(2)
    else
      case button
        when /ok/i, /yes/i, /submit/i
          browser.alert.when_present.ok
        when /cancel/i, /close/i
          browser.alert.when_present.close
        else
          puts("'#{button} for alert not recognized.")
      end
    end
  end

  # override incorrect method in awetest dsl
  def element_contains_text?(browser, element, how, what, expected, desc = '')
    msg = build_message("Element #{element} :{how}=>#{what} contains text '#{expected}'.", desc)
    case how
      when :href
        who = browser.link(how, what)
      else
        who = browser.element(how, what)
    end
    if who
      text = who.text
      if expected and expected.length > 0
        rgx = Regexp.new(Regexp.escape(expected))
        if text =~ rgx
          passed_to_log(msg)
          true
        else
          debug_to_log("exp: [#{expected.gsub(' ', '^')}]")
          debug_to_log("act: [#{text.gsub(' ', '^')}]")
          failed_to_log("#{msg} Found '#{text}'. #{desc}")
        end
      else
        if text.length > 0
          debug_to_log("exp: [#{expected.gsub(' ', '^')}]")
          debug_to_log("act: [#{text.gsub(' ', '^')}]")
          failed_to_log("#{msg} Found '#{text}'. #{desc}")
        else
          passed_to_log(msg)
          true
        end
      end
    end
  rescue
    failed_to_log("Unable to verify #{msg} '#{$!}'")
  end


end
