# require 'test_helper' because RubyMate needs help
require File.join(File.dirname(__FILE__) , "helpers")

Dir.chdir File.dirname(__FILE__) / "default_application"
module DefaultApplication ; include Waves::Foundations::Default ; end

# Waves << DefaultApplication
# Waves::Console.load( :mode => :development )


describe "An application module which includes the Simple foundation" do

  it "should work" do
    
  end
  
  it "should have basic submodules defined" do   
    lambda do
      DefaultApplication::Configurations::Mapping
      DefaultApplication::Configurations::Development
      DefaultApplication::Helpers
      DefaultApplication::Models
      DefaultApplication::Views
      DefaultApplication::Controllers
    end.should.not.raise
  end
  
  it "should autoload Helpers, Models, Views, and Controllers when their files exist" do
    DefaultApplication::Helpers::Testing.should.respond_to :foundation_testing
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