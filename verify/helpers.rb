%w( rubygems bacon ).each { |f| require f }

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

# protect TextMate from itself.

# Prepend the framework lib to the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "lib") )
require 'waves'

# define basic app for use in testing
# before methods may add to it using helper methods
module Test ; include Waves::Foundations::Simple ; end
module Test ; include Waves::Layers::SimpleErrors ; end
Waves << Test
Waves::Console.load( :mode => :development )


module Helpers
  
  def mapping
    ::Test::Configurations::Mapping
  end

  def path(*args,&block)
    mapping.path(*args,&block)
  end
  
  def url(*args,&block)
    mapping.url(*args,&block)
  end
  
  def use_mock_request
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

Bacon::Context.instance_eval do
  include Helpers 
  alias_method :specify, :it
end