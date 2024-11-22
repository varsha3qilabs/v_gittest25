require 'rubygems'
require 'watir'

b = Watir::Browser.new
b.goto("www.google.com")
b.text_field(:name, "q").set("3qilabs")
sleep 5
b.button(:name, "btnG").click
b.text.include? "3QI Labs"
b.close
