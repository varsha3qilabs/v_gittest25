module AwetestDslAllDefaults

  ### In Awetestlib requires -e www.google.com and -b (browser abbreviation) test
  def run

	for i in 1..10
      passed_to_log("Step : #{i}")
	end	
  end
end
