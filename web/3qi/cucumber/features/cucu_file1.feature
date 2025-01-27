
Feature: Test Cucumber script
	I want to test cucumber

Scenario: TestScenario1
        Given I run with Watir-webdriver
	When I open a new browser
        Then I wait 5 seconds
	Then I go to the url "http://google.com"
	Then I close the browser

Scenario: TestScenario2
        Given I run with Watir-webdriver
	When I open a new browser
        Then I wait 5 seconds
	Then I go to the url "http://yahoo.com"
	Then I close the browser
