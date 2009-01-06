require "#{File.dirname(__FILE__)}/../helpers.rb"

Test = Class.new { include Waves::Views::Mixin }

describe "A class which has included Waves::Views::Mixin" do

  before do
    @view = Test.new( env( '/', :method => 'GET' ) )
  end



end