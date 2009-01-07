require "#{here = File.dirname(__FILE__)}/../helpers.rb"
require 'foundations/classic'
require 'layers/renderers/erubis'
require 'layers/renderers/markaby'
require 'fileutils'

  
Test = Module.new { include Waves::Foundations::Classic }
Waves << Test




describe "A class which has included Waves::Views::Mixin" do
  Dir.chdir(here) do

    before do
      @view = Test::Views::Test.new( Waves::Request.new(env( '/', :method => 'GET' ) ))
      FileUtils.rm_rf "templates" if File.exist? "templates"
      FileUtils.mkdir_p "templates/test"
      File.write "templates/test/smurf.mab", "span 'Smurf'"
    end
  
  
    it "works" do
      @view.render("smurf").should == "<span>Smurf</span>\n"
      @view.smurf.should == "<span>Smurf</span>\n"
    end

  end
end

