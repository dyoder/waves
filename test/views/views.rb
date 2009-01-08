require "#{here = File.dirname(__FILE__)}/../helpers.rb"
require 'foundations/classic'
require 'layers/renderers/erubis'
require 'layers/renderers/markaby'
require 'fileutils'


describe "A class which has included Waves::Views::Mixin" do
  
    
    before do
      Test = Module.new { include Waves::Foundations::Classic }
      Waves << Test
      Dir.chdir(here) do      
        FileUtils.rm_rf "templates" if File.exist? "templates"
        FileUtils.mkdir_p "templates/test"
        File.write "templates/test/smurf.mab", "span 'Smurf'"
      end
      @view = Test::Views::Test.new( Waves::Request.new(env( '/', :method => 'GET' ) ))
    end

    after do
      Waves.applications.clear
      Object.instance_eval { remove_const(:Test) if const_defined?(:Test) }
    end
  
    it "works" do
      Dir.chdir(here) do
        @view.render("smurf").should == "<span>Smurf</span>\n"
        @view.smurf.should == "<span>Smurf</span>\n"
      end
    end

end

