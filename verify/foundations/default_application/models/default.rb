module DefaultApplication
	
	module Models
		
		class Default < Sequel::Model			
			before_save do
				set(:updated_on => Time.now) if columns.include? :updated_on
			end
		end
		
	end
	
end