module Waves
	
	class Console < Application
		
		class << self

			attr_reader :console

			def load( options={} )
				@console ||= Waves::Console.new( options )
				Kernel.load( :lib / 'startup.rb' )
			end
			
			# allow Waves::Console to act as The Console Instance
			def method_missing(*args); @console.send(*args); end
			
		end
	
	end
	
end