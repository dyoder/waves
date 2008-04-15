%w( rubygems bacon ).each { |f| require f }

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

# protect TextMate from itself.
require 'redgreen' if ENV['TM_FILENAME'].nil?

# Prepend the framework lib to the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "lib") )
require 'waves'

# define basic app for use in testing
# before methods may add to it using helper methods
module Test ; include Waves::Foundations::Simple ; end
Waves << Test
Waves::Console.load( :mode => :development )


module Helpers

  def path(*args,&block)
    ::Test::Configurations::Mapping.path(*args,&block)
  end
  
  def url(*args,&block)
    ::Test::Configurations::Mapping.url(*args,&block)
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