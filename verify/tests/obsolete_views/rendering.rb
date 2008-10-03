# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

Dir.chdir(File.dirname(__FILE__)) do
  class TestView
    include Waves::Views::Mixin
  end

  describe "Waves::Views" do
  
    it "provides a list of Renderers" do
      Waves::Views.renderers.should.respond_to :[]
    end
  
    it "defines an error for missing templates" do
      defined?(Waves::Views::NoTemplateError).should.not.be.nil
    end
  
  end

  describe "A class which has included Waves::Views::Mixin" do
  
    before do
      @view = TestView.new(mock(:request))
    end
  
    it "uses the first renderer for which it can find a template file with the associated extension" do
      @view.renderer("foo").should == Waves::Renderers::Erubis
      @view.renderer("moo").should == Waves::Renderers::Erubis
      @view.renderer("bleat").should == nil
    end
  
  end
end