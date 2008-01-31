module Waves
	
	module Helpers
		
		# Form helpers are used in generating forms. Since Markaby already provides Ruby
		# methods for basic form generation, the focus of this helper is on provide templates
		# to handle things that go beyond the basics. You must define a form template 
		# directory with templates for each type of form element you wish to use. The names
		# of the template should match the +type+ option provided in the property method.
		# 
		# For example, this code:
		#
		#   property :name => 'blog.title', :type => :text, :value => @blog.title
		#
		# will invoke the +text+ form view (the template in +templates/form/text.mab+),
		# passing in the name ('blog.title') and the value (@blog.title) as instance variables.
		#
		module Form
		
			# This method really is a place-holder for common wrappers around groups of 
			# properties. You will usually want to override this. As is, it simply places
			# a DIV element with class 'properties' around the block.
			def properties(&block)
			  div.properties do
			    yield
			  end
			end
			
			# Invokes the form view for the +type+ given in the option.
			def property( options )
			  self << view( :form, options[:type], options )
			end
			
			
		end
		
	end
	
end