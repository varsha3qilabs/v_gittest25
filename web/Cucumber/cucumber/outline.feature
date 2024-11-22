Feature: Test Cucumber script
	I want to test cucumber

Scenario Outline: TestScenario1
 Given I run with Watir-webdriver
When I open a new browser
Then I go to the url "<values>"
    	
	Examples:
		| values |
        |facebook.com|
  		|www.bing.com|
  		|www.yahoo.in|
