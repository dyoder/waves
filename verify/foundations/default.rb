# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

Dir.chdir File.dirname(__FILE__) / "default_application" do
module DefaultApplication
  include Waves::Foundations::Default
end
Waves::Console.load( :mode => :development )
DA = DefaultApplication

  describe "An application module which includes the Simple foundation" do

    it "should have basic submodules defined" do
      DA::Configurations::Mapping
      DA::Configurations::Default.host.should == nil
      DA::Configurations::Development.host.should == '127.0.0.1'
      DA::Models::Default
      DA::Views::Default
      DA::Controllers::Default
      DA::Helpers::Default
      DA::Helpers::Testing
    end

    it "should auto_load Helpers, Models, Views, and Controllers when their files exist" do
      Waves::Application.instance.mapping.send(:mapping).should.not.be.empty
      DA::Helpers::Default.instance_methods.should.include "layout"
      DA::Helpers::Testing.instance_methods.should.include "layout"
      DA::Helpers::Testing.should.respond_to :foundation_testing
      DA::Models::Default.should.respond_to :crayola
      DA::Models::Different.should.respond_to :sargent
      DA::Controllers::Default.instance_methods.should.include "attributes"
      DA::Controllers::Default.instance_methods.should.include "destroy_all"
      DA::Controllers::Different.instance_methods.should.include "attributes"
      DA::Controllers::Different.instance_methods.should.include "destroy_all"
      DA::Views::Default.instance_methods.should.include "renderer"
      DA::Views::Default.instance_methods.should.include "upside_down"
      DA::Views::Different.instance_methods.should.include "renderer"
      DA::Views::Different.instance_methods.should.include "upside_down"
    end

    it "should have accessors defined" do
      [ :config, :configurations, :controllers, :models, :helpers, :views ].each do |method|
        DA.should.respond_to method
      end
    end

    it "should define [] method for appropriate submodules" do
      DA::Configurations.should.respond_to :[]
      DA::Models.should.respond_to :[]
      DA::Views.should.respond_to :[]
      DA::Controllers.should.respond_to :[]
    end

  end

end
