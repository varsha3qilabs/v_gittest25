require 'rubygems'
require 'watir-webdriver'
b = Watir::Browser.new
b.goto("www.google.com")
b.text_field(:name, "q").set("3qilabs")
sleep 60
b.button(:name, "samplebuttonawetest").click
b.text.include? "gaqrbvafengfduhye"
b.close