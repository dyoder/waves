require "#{here = File.dirname(__FILE__)}/../helpers.rb"
require 'foundations/classic'
require 'layers/renderers/erubis'
require 'layers/renderers/markaby'

Dir.chdir(here) do
  
  Test = Module.new { include Waves::Foundations::Classic }
  Waves << Test


  

  describe "A class which has included Waves::Views::Mixin" do

    before do
      @view = Test::Views::Test.new( Waves::Request.new(env( '/', :method => 'GET' ) ))
    end
    
    it "works" do
      @view.render("smurf").should == "<span>Smurf</span>\n"
      @view.smurf.should == "<span>Smurf</span>\n"
    end

    it "new stuff works" do
      @view.template_file("gnome").should == "templates/test/gnome.erb"
      @view.render("smurf").should == "<span>Smurf</span>\n"
      @view.mab("span 'Toe'").should == "<span>Toe</span>\n"
    end

  end

end