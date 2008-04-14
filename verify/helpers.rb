$:.unshift( 'lib' )
require 'lib/waves.rb'
module Test
  module Configurations
    class Test < Waves::Configurations::Default ; end
    module Mapping
      extend Waves::Mapping
    end
  end
  extend Autocreate
  [ :Configurations, :Models, :Views, :Controllers, :Helpers ].each do | name |
		autocreate( name, Module.new ) do
      # dynamically access module constants
			def self.[]( cname )
			  eval("#{name}::#{cname.to_s.camel_case}")
			end
		end
	end
  # accessor methods for modules and other key application objects ...
	class << self
		def config ; Waves::Server.config rescue nil || Waves::Console.config ; end
		def configurations ; Test::Configurations ; end
		def controllers ; Test::Controllers ; end
		def models ; Test::Models ; end
		def helpers ; Test::Helpers ; end
		def views ; Test::Views ; end
	end
end
Waves << Test

module Helpers

  def path(*args)
    ::Test::Configurations::Mapping.path(*args)
  end
  
  def mock_request
    @mock = Rack::MockRequest.new( Waves::Dispatchers::Default.new )
  end
  
  [:get,:put,:post,:delete].each do |method|
    define_method method do | path |
      @mock.send( method, path )
    end
  end
  
end

module Kernel
  private
  def specification(name, &block)  Bacon::Context.new(name, &block) end
end

Bacon::Context.instance_eval { 
  include Helpers 
  alias_method :specify, :it
}