# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

Dir.chdir File.dirname(__FILE__) / "default_application" do
module DefaultApplication
  include Waves::Foundations::Default
end
Waves::Console.load( :mode => :development )
DA = DefaultApplication


  describe "An application module which includes the Default foundation" do

    it "defines basic namespaces" do
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

      DA::Models::Default.should.respond_to :crayola
      DA::Controllers::Default.instance_methods.should.include "attributes"
      DA::Controllers::Default.instance_methods.should.include "destroy_all"
      
      DA::Views::Default.instance_methods.should.include "renderer"
      DA::Views::Default.instance_methods.should.include "from_default"
    end
    
    it "auto_creates Models when their files do not exist" do
      DA::Models::Created.superclass.should == DA::Models::Default
    end
    
    it "auto_loads Models when their files exist" do
      DA::Models::Loaded.instance_methods.should.include "from_loaded"
    end
    
    it "auto_creates Controllers when their files do not exist" do
      DA::Controllers::Created.superclass.should == DA::Controllers::Default
    end
    
    it "auto_loads Controllers when their files exist" do
      DA::Controllers::Loaded.instance_methods.should.include "from_loaded"
    end
    
    it "auto_creates Views when their files do not exist" do
      DA::Views::Created.superclass.should == DA::Views::Default
    end
    
    it "auto_loads Views when their files exist" do
      DA::Views::Loaded.instance_methods.should.include "from_loaded"
    end
    
    it "auto_creates Helpers when their files do not exist" do
      DA::Helpers::Created.included_modules.should.include Waves::Helpers::Default
    end
    
    it "auto_loads Helpers when their files exist" do
      DA::Helpers::Loaded.instance_methods.should.include "doctype"
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
