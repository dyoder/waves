# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")
require 'layers/orm/sequel'

Dir.chdir File.dirname(__FILE__) / "default_application" do
module DefaultApplication ; include Waves::Foundations::Default ; end


  describe "An application module which includes the Simple foundation" do

    it "should have basic submodules defined" do
      DefaultApplication::Configurations::Mapping
      DefaultApplication::Configurations::Default
      DefaultApplication::Configurations::Development
      DefaultApplication::Helpers::Testing
      DefaultApplication::Models::Default.superclass.should == Waves::Layers::ORM::Model
      DefaultApplication::Views
      DefaultApplication::Views::Default
      DefaultApplication::Controllers::Default
    end

    it "should autoload Helpers, Models, Views, and Controllers when their files exist" do
      DefaultApplication::Helpers::Testing.should.respond_to :foundation_testing
      DefaultApplication::Models::Default.should.respond_to :crayola
      DefaultApplication::Models::Different.should.respond_to :sargent
      DefaultApplication::Controllers::Default.instance_methods.should.include "attributes"
      DefaultApplication::Controllers::Default.instance_methods.should.include "destroy_all"
      DefaultApplication::Controllers::Different.instance_methods.should.include "destroy_all"
      DefaultApplication::Views::Default.instance_methods.should.include "renderer"
      DefaultApplication::Views::Default.instance_methods.should.include "upside_down"
      DefaultApplication::Views::Different.instance_methods.should.include "upside_down"
    end

    it "should have accessors defined" do
      [ :database, :config, :configurations, :controllers, :models, :helpers, :views ].each do |method|
        DefaultApplication.should.respond_to method
      end
    end

    it "should define [] method for appropriate submodules" do
      DefaultApplication::Configurations.should.respond_to :[]
      DefaultApplication::Models.should.respond_to :[]
      DefaultApplication::Views.should.respond_to :[]
      DefaultApplication::Controllers.should.respond_to :[]
    end

  end

end
