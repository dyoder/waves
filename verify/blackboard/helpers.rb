%w( rubygems bacon facon extensions/all).each { |f| require f }

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

# Prepend the framework lib to the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "..", "lib") )
require 'waves'

module Kernel
  private
  def specification(name, &block)  Bacon::Context.new(name, &block) end
end

Bacon::Context.instance_eval do
  # include ::Waves::Verify::Helpers::Mapping
  # include ::Waves::Verify::Helpers::Request
  alias_method :specify, :it
end

module Test ; include Waves::Foundations::Simple ; end
Waves << Test
Waves::Console.load( :mode => :development )
