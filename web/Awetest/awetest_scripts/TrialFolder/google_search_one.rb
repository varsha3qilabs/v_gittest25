module AwetestDslAllDefaults

  # In Awetestlib requires -e www.google.com and -b (browser abbreviation)
  def run

	for i in 1..8000
      passed_to_log("Step : #{i}")
	end	
  end
end
