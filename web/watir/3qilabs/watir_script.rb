require 'rubygems'
require 'watir'
b = Watir::Browser.new
sleep(5)
b.goto("www.google.com")
b.text_field(:name, "q").set("3qilabs")
b.button(:name, "btnK").fire_event :click
b.text.include? "3QI Labs"
b.close