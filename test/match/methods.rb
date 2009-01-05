require "#{File.dirname(__FILE__)}/../../test/helpers.rb"
require 'foundations/compact'

describe "Matching Request Methods" do
    
  before do
    Test = Module.new { include Waves::Foundations::Compact }
    Test::Resources::Map.module_eval {
      %w( get put post delete head ).each { |m| on( m ) { m } } }
    Waves << Test
  end
  
  after do
    Waves.applications.clear
    Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
  end
    
  %w( get put post delete head ).each do |m|
    feature( "Match the '#{m}' method" ) { send( m, '/' ).body.should == m }
  end
  
end